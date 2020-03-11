

import 'package:cineplus/cineplus.dart';
import 'package:cineplus/model/user.dart';

class UserController extends ResourceController {
  UserController(this.context);

  final ManagedContext context;

  @Operation.get('username')
  Future<Response> getUserbyUsername(@Bind.path('username') String username) async {
    final userQuery = Query<User>(context)
      ..where((u) => u.username).equalTo(username);

    final user = await userQuery.fetchOne();
    if (user == null){
      return Response.notFound();
    }
    return Response.ok(user);
  }
}