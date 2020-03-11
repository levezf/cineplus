import 'package:aqueduct/managed_auth.dart';
import 'package:cineplus/controller/register_controller.dart';
import 'package:cineplus/model/user.dart';
import 'controller/user_controller.dart';

import 'cineplus.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class CineplusChannel extends ApplicationChannel {
  ManagedContext context;
  AuthServer authServer;


  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = CinePlusConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username, 
      config.database.password, 
      config.database.host, 
      config.database.port, 
      config.database.databaseName
    );

    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);

  }


  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/auth/token")
      .link(() => AuthController(authServer));

    router
      .route("/users/[:username]")
      .link(() => Authorizer.bearer(authServer))
      .link(() => UserController(context));
    
    router
      .route("/register")
      .link(() => RegisterController(context, authServer));

    return router;
  }
}

class CinePlusConfig extends Configuration{
  CinePlusConfig(String path): super.fromFile(File(path));

  DatabaseConfiguration database;
}