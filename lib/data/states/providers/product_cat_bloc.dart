

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/usecases/products/crud_cat_product_usecase.dart';
import 'package:pokedex/data/usecases/products/getproductcatusecase.dart';


// Define Events
abstract class ProductCatEvent {}

class LoadProductCatEvent extends ProductCatEvent {}

class  CrudProductCatEvent extends ProductCatEvent {
  final ArgCatProduct argCatProduct;
  
  CrudProductCatEvent({
    required this.argCatProduct
});
  
}



// Define States
abstract class ProductCatState {}

class ProductCatLoadingState extends ProductCatState {}

class ProductCatLoadedState extends ProductCatState {
  final List<ProductCat> data;

  ProductCatLoadedState(this.data);
}

class CrudProductCatLoadedState extends ProductCatState {
  final int response;

  CrudProductCatLoadedState(this.response);
}


class ProductCatErrorState extends ProductCatState {
  final dynamic error;

  ProductCatErrorState(this.error);
}
@singleton
class ProductCatBloc extends Bloc<ProductCatEvent, ProductCatState> {
  final GetProductcatUsecase getProductCatsUsecase;
  final CrudCatProductUseCase crudCatProductUseCase ;

  ProductCatBloc(this.getProductCatsUsecase ,this.crudCatProductUseCase) : super(ProductCatLoadingState()) {
    // Register event handlers here
    on<LoadProductCatEvent>(_onLoadProductCat);
    on<CrudProductCatEvent>(((event, emit) => _onCrudProductCat(event,emit,event.argCatProduct)));
  }

  void _onLoadProductCat(LoadProductCatEvent event, Emitter<ProductCatState> emit) async {
    emit(ProductCatLoadingState());
    try {
      final List<ProductCat> data = await getProductCatsUsecase.call();
      emit(ProductCatLoadedState(data));
    } catch (error) {
      emit(ProductCatErrorState(error));
    }
  }
  void _onCrudProductCat(CrudProductCatEvent event, Emitter<ProductCatState> emit , ArgCatProduct argCatProduct) async {
    emit(ProductCatLoadingState());
    try {
      emit(CrudProductCatLoadedState(await crudCatProductUseCase.call(argCatProduct)));
    } catch (error) {
      emit(ProductCatErrorState(error));
    }
  }

  @override
  Stream<ProductCatState> mapEventToState(ProductCatEvent event) async* {
    // This method is now empty because we're handling events in individual event handlers
  }
}
