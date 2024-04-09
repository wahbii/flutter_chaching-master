import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/repositories/usernamangment/user_data_repository.dart';
@singleton
class RemoveUserUseCase extends UseCase<int, String> {
  final UserDataRepository repository;

  RemoveUserUseCase({required this.repository});

  @override
  FutureOr<int> call(String params) {
    return repository.removeUser(params);
  }
}
