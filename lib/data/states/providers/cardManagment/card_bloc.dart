import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/card_item.dart';
import 'package:pokedex/data/usecases/card/add_to_card_usecase.dart';

import '../../../usecases/card/fetch_card_usecase.dart';
import '../../../usecases/card/modify_quantite_use_case.dart';

abstract class CardEvent {}

class LoadCardEvent extends CardEvent {
  final String userId;

  LoadCardEvent(this.userId);
}

class AddProductToCardEvent extends CardEvent {
  final CardItem cardItem;

  AddProductToCardEvent({required this.cardItem});
}

class ModifyQtProdutEvent extends CardEvent {
  final CardItem modifyItemCard;

  ModifyQtProdutEvent({required this.modifyItemCard});
}

// Define States
abstract class CardState {}

class CardLoadingState extends CardState {}

class CardFeatchState extends CardState {
  final List<CardItem> data;

  CardFeatchState({required this.data});
}

class AddToCardState extends CardState {
  final int result;

  AddToCardState(this.result);
}

class CardErrorState extends CardState {
  final dynamic error;

  CardErrorState(this.error);
}
@singleton
class CardBloc extends Bloc<CardEvent, CardState> {
  final AddToCardUsercase addToCardUsercase;
  final ModifyQuantiteUseCase modifyQuantiteUseCase;
  final FetchCardUseCase fetchCardUseCase;

  CardBloc(
      {required this.addToCardUsercase,
      required this.modifyQuantiteUseCase,
      required this.fetchCardUseCase})
      : super(CardLoadingState()) {
    // Register event handlers here
    on<AddProductToCardEvent>(
        (event, emit) => _onAddProductCard(event, emit, event.cardItem));
    on<ModifyQtProdutEvent>((event, emit) =>
        _onModifyProductCard(event, emit, event.modifyItemCard));
    on<LoadCardEvent>((event, emit) =>
        _onFetchProductCard(event, emit, event.userId));
  }

  void _onAddProductCard(AddProductToCardEvent event, Emitter<CardState> emit,
      CardItem cat) async {
    emit(CardLoadingState());
    try {
      emit(AddToCardState(await addToCardUsercase.call(cat)));
    } catch (error) {
      emit(CardErrorState(error));
    }
  }

  void _onModifyProductCard(ModifyQtProdutEvent event, Emitter<CardState> emit,
      CardItem modifyItemCard) async {
    emit(CardLoadingState());
    try {
      emit(AddToCardState(await modifyQuantiteUseCase.call(modifyItemCard)));
    } catch (error) {
      emit(CardErrorState(error));
    }
  }

  void _onFetchProductCard(LoadCardEvent event, Emitter<CardState> emit,
      String id) async {
    emit(CardLoadingState());
    try {
      emit(CardFeatchState( data: await fetchCardUseCase.call(id)));
    } catch (error) {
      emit(CardErrorState(error));
    }
  }

  @override
  Stream<CardState> mapEventToState(CardEvent event) async* {
    // This method is now empty because we're handling events in individual event handlers
  }
}
