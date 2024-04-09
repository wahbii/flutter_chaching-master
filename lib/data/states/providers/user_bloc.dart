
// Define Events
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/usecases/user/add_user_usecase.dart';
import 'package:pokedex/data/usecases/user/update_user_usecase.dart';
import 'package:pokedex/utils/enums.dart';

import '../../usecases/user/get_users_usecase.dart';
import '../../usecases/user/remove_user_use_case.dart';

abstract class UserEvent {}


class LoadUsersEvent extends UserEvent {
}

class AddUserEvent extends UserEvent {
  final UserData user;
  AddUserEvent({
    required this.user
  });
}

class UpdateUserEvent extends UserEvent {
  final UserUpdated user;
  final ApiActions action ;
  UpdateUserEvent({
    required this.user,
    required this.action
  });
}

class DeleteUserEvent extends UserEvent {
  final String id;
  DeleteUserEvent ({
    required this.id
  });
}


// Define States
abstract class UserState {
  get error => null;
}

class LoadUsersState extends UserState {
  final List<UserData>  userdata;
  LoadUsersState( {required this.userdata});
}

class AddUserLoadingState extends UserState {}

class AddUserState extends UserState {
  final int result ;
  AddUserState( {required this.result});
}

class UpdateUserState extends UserState {
  final int result ;
  UpdateUserState( {required this.result});
}

class DeleteUserState extends UserState {
  final int result ;
  DeleteUserState( {required this.result});
}


class AddUserErrorState extends UserState {
  final dynamic error;

  AddUserErrorState(this.error);
}
@singleton
class UserBloc extends Bloc<UserEvent, UserState> {
  final AddUserUseCase addUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserUsercase updateUserUsercase ;
  final RemoveUserUseCase removeUserUseCase ;


  UserBloc(this.addUserUseCase ,this.getUsersUseCase ,this.updateUserUsercase ,this.removeUserUseCase) : super(AddUserLoadingState()) {
    // Register event handlers here
    on<AddUserEvent>((event, emit) => _addUser(event, emit, event.user));
    on<LoadUsersEvent>(_LoadUsers);
    on<DeleteUserEvent>((event, emit) => _delete(event, emit, event.id));
    on<UpdateUserEvent>((event, emit) => _update(event, emit, event.user,event.action));

  }

  void _addUser(AddUserEvent event, Emitter<UserState> emit, UserData data) async {
    emit(AddUserLoadingState());
    try {
      emit(AddUserState(result: await addUserUseCase.call(data)));
    } catch (error) {
      emit(AddUserErrorState(error));
    }
  }
  void _LoadUsers(LoadUsersEvent event, Emitter<UserState> emit) async {
    emit(AddUserLoadingState());
    try {
      emit(LoadUsersState(userdata:  await getUsersUseCase.call(null)));
    } catch (error) {
      emit(AddUserErrorState(error));
    }
  }
  void _update(UpdateUserEvent event, Emitter<UserState> emit ,UserUpdated userUpdated,ApiActions actions) async {
    emit(AddUserLoadingState());
    try {
       if(actions == ApiActions.UPDATE){
         emit(UpdateUserState( result: await updateUserUsercase.call(userUpdated)));

       }else{
         emit(UpdateUserState( result: await removeUserUseCase.call(userUpdated.userData.id)));

       }

    } catch (error) {
      emit(AddUserErrorState(error));
    }
  }

  void _delete(DeleteUserEvent event, Emitter<UserState> emit ,String userUpdated) async {
    emit(AddUserLoadingState());
    try {
      emit(DeleteUserState( result: await removeUserUseCase.call(userUpdated)));
    } catch (error) {
      emit(AddUserErrorState(error));
    }
  }

  @override
  Stream<AddUserState> mapEventToState(AddUserEvent event) async* {
    // This method is now empty because we're handling events in individual event handlers
  }
}
