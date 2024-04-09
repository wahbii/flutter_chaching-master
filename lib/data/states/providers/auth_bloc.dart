import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/usecases/user/register_use_case.dart';

import '../../usecases/user/login_use_caase.dart';

abstract class RegisterEvent {}

class RegisterWithEmailEvent extends RegisterEvent {
  final UserAuth userAuth;
  RegisterWithEmailEvent({
    required this.userAuth
  });

}

class LoginEvent extends RegisterEvent {
  final UserAuth userAuth;
  LoginEvent({
    required this.userAuth
  });

}


// Define States
abstract class RegisterState {}

class RegisterLoadingState extends RegisterState {}

class LoginState extends RegisterState {
  final UserCredential data;

  LoginState(this.data);
}

class RegisterWithEmailState extends RegisterState {
  final UserCredential data;

  RegisterWithEmailState (this.data);
}



class RegisterErrorState extends RegisterState {
  final dynamic error;

  RegisterErrorState(this.error);
}
@singleton
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;



  RegisterBloc(this.registerUseCase,this.loginUseCase) : super(RegisterLoadingState()) {
    // Register event handlers here
    on<RegisterWithEmailEvent>((event, emit) => _onRegisterWithEmail(event, emit, event.userAuth));
    on<LoginEvent>((event, emit) => _onLogin(event, emit, event.userAuth));
  }


  void _onRegisterWithEmail(RegisterWithEmailEvent event, Emitter<RegisterState> emit ,UserAuth userAuth) async {
    emit(RegisterLoadingState());
    try {
      emit(RegisterWithEmailState(await registerUseCase.call(userAuth)));
    } catch (error) {
      emit(RegisterErrorState(error));
    }
  }

  void _onLogin(LoginEvent event, Emitter<RegisterState> emit ,UserAuth userAuth) async {
    emit(RegisterLoadingState());
    try {
      emit(LoginState(await loginUseCase.call(userAuth)));
    } catch (error) {
      emit(RegisterErrorState(error));
    }
  }

}


