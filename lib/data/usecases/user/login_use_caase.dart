

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/repositories/usernamangment/register_repository.dart';
@singleton
class LoginUseCase extends UseCase<UserCredential ,UserAuth> {

  final RegisterRepository registerRepository ;

  LoginUseCase({
    required this.registerRepository,
});

  @override
  FutureOr<UserCredential> call(UserAuth params) {
    return registerRepository.login(params);
  }


}