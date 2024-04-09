import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/repositories/usernamangment/user_data_repository.dart';

class UserUpdated {
  final String? email;

  final String? password;
  final bool? isAdmin;

  final UserData userData;


  UserUpdated(
      {required this.userData,
      required this.isAdmin,
      required this.password,
      required this.email});
}
@singleton
class UpdateUserUsercase extends UseCase<int, UserUpdated> {
  final UserDataRepository repository;

  UpdateUserUsercase({required this.repository});

  @override
  FutureOr<int> call(UserUpdated params) async {
    return repository.updateUser(
        params.userData, params.email, params.password, params.isAdmin);
  }
}
