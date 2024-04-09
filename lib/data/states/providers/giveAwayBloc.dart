

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/usecases/giveaway/crud_cat_giveaway_usecase.dart';
import 'package:pokedex/data/usecases/giveaway/crud_giveaway_use_case.dart';
import 'package:pokedex/data/usecases/giveaway/getCatgiveawaysUsecase.dart';
import 'package:pokedex/data/usecases/giveaway/getGiveAwayUseCase.dart';
import 'package:pokedex/utils/enums.dart';

import '../../entities/giveaway.dart';

// Define Events
abstract class GiveAwayEvent {}

// ***** give away categorie events ****

class LoadGiveAwayCatEvent extends GiveAwayEvent {}

class CrudGiveAwayCatEvent extends GiveAwayEvent{
    final ArgCatGiveAway argCatGiveAway;
    CrudGiveAwayCatEvent({
        required this.argCatGiveAway
});
}
// **********
// ***** give away  events ****
class LoadGiveAwayEvent extends GiveAwayEvent {}
class LoadGiveAwayByIDEvent extends GiveAwayEvent {
    final String? categoryId;
    final List<GiveAway>? data;

    LoadGiveAwayByIDEvent(this.categoryId ,this.data);
}

class LoadGiveAwayBySearch extends GiveAwayEvent {
    final String? search;
    final List<GiveAway>? data;

    LoadGiveAwayBySearch(this.search ,this.data);
}

class CrudGiveAwayEvent extends GiveAwayEvent {
    final ArgGiveAway argGiveAway ;

    CrudGiveAwayEvent(this.argGiveAway);
}


//*******

// Define States
abstract class GiveAwayState {}

class GiveAwayLoadingState extends GiveAwayState {}

// **** give aways state
class GiveAwayLoadedState extends GiveAwayState {
    final List<GiveAway> data;

    GiveAwayLoadedState(this.data);
}
class GiveAwayLoadedStateByIdCat extends GiveAwayState {
    final List<GiveAway> data;

    GiveAwayLoadedStateByIdCat(this.data);
}

class GiveAwayLoadedStateSearch extends GiveAwayState {
    final List<GiveAway> data;

    GiveAwayLoadedStateSearch(this.data);
}
class CrudGiveAwayState extends GiveAwayState {
    final int response ;
    CrudGiveAwayState(this.response);
}

//********

// give awayscat state
class GiveAwayCatLoadedState extends GiveAwayState {
    final List<CatGiveAway> data;

    GiveAwayCatLoadedState(this.data);
}
class CrudGiveAwayCatState extends GiveAwayState {
    final int response ;
    CrudGiveAwayCatState(this.response);
}
//******


class GiveAwayErrorState extends GiveAwayState {
    final dynamic error;

    GiveAwayErrorState(this.error);
}
@singleton
class GiveAwayBloc extends Bloc<GiveAwayEvent, GiveAwayState> {
    final GetGiveAwayUseCase getGiveAwaysUsecase;
    final GetCatGiveAwaysUsecase getCatGiveAwaysUsecase;
    final CrudCatGiveAwayUseCase crudCatGiveAwatUseCase;
    final CrudGiveAwayUseCase crudGiveAwayUseCase;
    List<GiveAway> mainData = [];
    List<CatGiveAway> catGiveAways = [];



    GiveAwayBloc(
        this.getGiveAwaysUsecase ,
        this.getCatGiveAwaysUsecase,
        this.crudGiveAwayUseCase,
        this.crudCatGiveAwatUseCase
        ) : super(GiveAwayLoadingState()) {
        // Register event handlers here
        on<LoadGiveAwayEvent>(_onLoadGiveAway);
        on<LoadGiveAwayCatEvent>(_onLoadGiveAwayCats);
        on<LoadGiveAwayByIDEvent>((event, emit) => _onLoadGiveAwayFilterByCate(event, emit, event.categoryId,event.data));
        on<LoadGiveAwayBySearch>((event, emit) => _onLoadGiveAwayFilterBySearch(event, emit, event.search,event.data));
        on<CrudGiveAwayCatEvent>((event, emit) => _onCrudCatgiveAway(event, emit, event.argCatGiveAway));
        on<CrudGiveAwayEvent>((event, emit) => _onCrudgiveAway(event, emit, event.argGiveAway));


    }
 // give away cat
    void _onLoadGiveAwayCats(LoadGiveAwayCatEvent event, Emitter<GiveAwayState> emit) async {
        emit(GiveAwayLoadingState());
        try {
            final List<CatGiveAway> data = await getCatGiveAwaysUsecase.call();
            catGiveAways = data ;
            emit(GiveAwayCatLoadedState(data));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }
    }

    void _onCrudCatgiveAway(CrudGiveAwayCatEvent event ,Emitter<GiveAwayState> emit ,ArgCatGiveAway argCatGiveAway)async{
        emit(GiveAwayLoadingState());
        try {
            emit(CrudGiveAwayCatState(await crudCatGiveAwatUseCase.call(argCatGiveAway)));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }

    }


// ************

// give aways

    void _onCrudgiveAway(CrudGiveAwayEvent event ,Emitter<GiveAwayState> emit ,ArgGiveAway argGiveAway)async{
        emit(GiveAwayLoadingState());
        try {
            emit(CrudGiveAwayState(await crudGiveAwayUseCase.call(argGiveAway)));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }

    }


    void _onLoadGiveAway(LoadGiveAwayEvent event, Emitter<GiveAwayState> emit) async {
        emit(GiveAwayLoadingState());
        try {
            final List<GiveAway> data = await getGiveAwaysUsecase.call();
            emit(GiveAwayLoadedState(data));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }
    }
    void _onLoadGiveAwayFilterByCate(LoadGiveAwayByIDEvent event, Emitter<GiveAwayState> emit ,String? id ,    List<GiveAway>? dataToFilter
    ) async {
        emit(GiveAwayLoadingState());
        List<GiveAway> data = [] ;
        try {

                data = (await getGiveAwaysUsecase.call());
                mainData = data ;
            emit(GiveAwayLoadedState(data));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }
    }

    void _onLoadGiveAwayFilterBySearch(LoadGiveAwayBySearch  event, Emitter<GiveAwayState> emit ,String? name ,    List<GiveAway>? dataToFilter
        ) async {
        emit(GiveAwayLoadingState());
        List<GiveAway> data = [] ;
        try {

            data = dataToFilter?.where((element) => element.titleEng.contains(name.toString())|| element.titleFr.contains(name.toString())||element.titleAr.contains(name.toString())).toList()??[];
            print(data);
            emit(GiveAwayLoadedState(data));
        } catch (error) {
            emit(GiveAwayErrorState(error));
        }
    }
 // *************
    @override
    Stream<GiveAwayState> mapEventToState(GiveAwayEvent event) async* {
        // This method is now empty because we're handling events in individual event handlers
    }
}
