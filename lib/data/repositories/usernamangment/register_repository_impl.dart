import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/repositories/usernamangment/register_repository.dart';


@Singleton(as: RegisterRepository)
class RegisterAndAuthRepositoryImlp extends RegisterRepository {
  @override
  Future< UserCredential> register(UserAuth userAuth) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userAuth.email,
        password: userAuth.password
    );
  }

  @override
  Future<UserCredential> login(UserAuth userAuth) async{
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userAuth.email,
        password: userAuth.password
    );
  }

}