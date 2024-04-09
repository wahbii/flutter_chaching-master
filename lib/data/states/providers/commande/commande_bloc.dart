

// events



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/usecases/commande/commande_use_case.dart';

import '../../../entities/commande.dart';
// Define Events
abstract class CommandeEvent {}

class LoadCommandeEvent extends CommandeEvent {
  final String? id_user ;
  LoadCommandeEvent({required this.id_user});
}
class LoadCommandeByRefEvent extends CommandeEvent {
  final String ref ;

  LoadCommandeByRefEvent({required this.ref});
}

class CrudCammandeEvent extends CommandeEvent{
  final CommandeArgs commandeArgs;
  CrudCammandeEvent({
    required this.commandeArgs
  });
}

class CommandeErrorState extends CommandeState {
  final dynamic error;

  CommandeErrorState(this.error);
}

// Define State

abstract class CommandeState {}

class CommandeLoadingState extends CommandeState {}

class CommandeFeatchState extends CommandeState {
  final List<Commande> data;

  CommandeFeatchState({required this.data});
}
class CommandeFeatchByRefState extends CommandeState {
  final Commande data;
  CommandeFeatchByRefState({required this.data});
}

class CrudCommandeState extends CommandeState {
  final int result;

  CrudCommandeState(this.result);
}

@singleton
class CommandeBloc extends Bloc<CommandeEvent,CommandeState>{

  final CommandeAUDUseCase commandeAUDUseCase ;
  final CommandeFetchUseCase commandeFetchUseCase ;


  CommandeBloc( {required this.commandeFetchUseCase ,required this.commandeAUDUseCase}):super(CommandeLoadingState()){
    on<CrudCammandeEvent>(
            (event, emit) => _onCrudCommande(event, emit, event.commandeArgs));

    on<LoadCommandeEvent>((event, emit) =>
        _onFetchCommande(event, emit,event.id_user ));
    on<LoadCommandeByRefEvent>((event, emit) =>
        _onFetchCommandeByRef(event, emit ,event.ref ));
  }


  void _onCrudCommande(CrudCammandeEvent event, Emitter<CommandeState> emit,
      CommandeArgs commandeArgs) async {
    emit(CommandeLoadingState());
    try {
      emit(CrudCommandeState(await commandeAUDUseCase.call(commandeArgs)));
    } catch (error) {
      emit(CommandeErrorState(error));
    }
  }

  void _onFetchCommande(LoadCommandeEvent event, Emitter<CommandeState> emit ,String? id_user) async {
    emit(CommandeLoadingState());
    try {
      emit(CommandeFeatchState( data: await commandeFetchUseCase.call(id_user)));
    } catch (error) {
      emit(CommandeErrorState(error));
    }
  }

  void _onFetchCommandeByRef(LoadCommandeByRefEvent event, Emitter<CommandeState> emit  ,String ref) async {
    emit(CommandeLoadingState());
    try {
      var data = await commandeFetchUseCase.call(null);
      emit(CommandeFeatchByRefState( data: data.where((element) => element.ref.contains(ref)).first));
    } catch (error) {
      emit(CommandeErrorState(error));
    }
  }

}

