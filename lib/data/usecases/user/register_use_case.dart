
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/user_auth.dart';

import '../../../core/usecase.dart';
import '../../repositories/usernamangment/register_repository.dart';
@singleton
class RegisterUseCase extends UseCase<UserCredential, UserAuth> {

  final RegisterRepository _itemRepository;

  const RegisterUseCase({
    required RegisterRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  FutureOr<UserCredential> call(UserAuth params) {
    return _itemRepository.register(params);
  }




}