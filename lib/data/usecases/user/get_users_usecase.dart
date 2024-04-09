


import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/repositories/usernamangment/user_data_repository.dart';
@singleton
class GetUsersUseCase extends UseCase<List<UserData>,NoParams?>{

  final UserDataRepository userDataRepository;

  GetUsersUseCase({
   required this.userDataRepository
});

  @override
  FutureOr<List<UserData>> call(NoParams? params) {
    return userDataRepository.featchUsers();
  }


}