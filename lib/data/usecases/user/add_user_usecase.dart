

import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/user_data.dart';
import '../../repositories/usernamangment/user_data_repository.dart';
@singleton
class AddUserUseCase extends UseCase<void ,UserData>{
  final UserDataRepository repository ;
  AddUserUseCase({
    required this.repository
});

  @override
  FutureOr<int> call(UserData params) {
    return repository.addUser(params);
  }

}