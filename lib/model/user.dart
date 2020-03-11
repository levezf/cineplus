import 'package:aqueduct/aqueduct.dart';
import 'package:aqueduct/managed_auth.dart';
import 'package:cineplus/cineplus.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User>{
  @Serialize(input: true, output:false)
  String password;

  @Serialize()
  @Column(unique: true)
  String email;

  @Serialize()
  @Column(unique: true)
  String fullname;

}

class _User extends ResourceOwnerTableDefinition {}