import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/data/entities/user_auth.dart';

abstract class RegisterRepository {
  const RegisterRepository();

  Future< UserCredential> register(UserAuth userAuth);
  Future< UserCredential> login(UserAuth userAuth);
}