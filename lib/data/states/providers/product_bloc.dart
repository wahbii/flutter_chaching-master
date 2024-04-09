
// Define Events
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/usecases/products/crud_product_usecase.dart';

import '../../entities/product.dart';
import '../../usecases/products/get_product_usecase.dart';

abstract class ProductEvent {}

class LoadProductEvent extends ProductEvent {


}


class CrudProductEvent extends ProductEvent {
  final ArgProduct argProduct;

  CrudProductEvent(this.argProduct);

}

class LoadProductEventById extends ProductEvent {
  final String id;

  LoadProductEventById(this.id);

}

class LoadProductEventBySearch extends ProductEvent {
  final String search;


  LoadProductEventBySearch(this.search );

}



// Define States
abstract class ProductState {}

class ProductLoadingState extends ProductState {
}

class ProductLoadedState extends ProductState {
  final List<Product> data;

  ProductLoadedState(this.data);
}

class CrudProductLoadedState extends ProductState {
  final int response;

  CrudProductLoadedState(this.response);
}

class ProductLoadedByIdState extends ProductState {
  final Product data;

  ProductLoadedByIdState({required this.data});
}


class ProductErrorState extends ProductState {
  final dynamic error;

  ProductErrorState(this.error);
}
@singleton
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase getProductsUsecase;
  final CrudProductUseCase crudProductUseCase ;
   List<Product> mainProduct = [] ;

  ProductBloc(this.getProductsUsecase,this.crudProductUseCase) : super(ProductLoadingState()) {
    // Register event handlers here
    on<LoadProductEvent>((event, emit) => _onLoadProduct(event, emit));
    on<LoadProductEventById>((event, emit) => _onLoadProductById(event, emit, event.id));
    on<LoadProductEventBySearch>((event, emit) => _onLoadProductBySearchName(event, emit, event.search));
    on<CrudProductEvent>((event, emit) => _onCrudProduct(event, emit, event.argProduct));


  }

  void _onLoadProduct(LoadProductEvent event, Emitter<ProductState> emit ) async {
    emit(ProductLoadingState());
    try {
        mainProduct = await getProductsUsecase.call();
        emit(ProductLoadedState( mainProduct));


    } catch (error) {
      emit(ProductErrorState(error));
    }
  }
  void _onLoadProductById(LoadProductEventById event, Emitter<ProductState> emit , String id) async {
    emit(ProductLoadingState());
    try {
         var dataList = mainProduct;
        emit(ProductLoadedByIdState(  data: dataList.where((element) => element.id == id).first));

    } catch (error) {
      emit(ProductErrorState(error));
    }
  }

  void _onCrudProduct(CrudProductEvent event, Emitter<ProductState> emit , ArgProduct argProduct) async {
    emit(ProductLoadingState());
    try {
      final reponse =  await crudProductUseCase.call(argProduct);
      emit(CrudProductLoadedState(reponse ));
    } catch (error) {
      emit(ProductErrorState(error));
    }
  }

  void _onLoadProductBySearchName(LoadProductEventBySearch event, Emitter<ProductState> emit , String name ) async {
    emit(ProductLoadingState());
    try {
      var dataList = mainProduct;
      if(!name.isNotEmpty){
        emit(ProductLoadedState(mainProduct));
      }else {
        print(name +" : ${dataList.length}");
        emit(ProductLoadedState( dataList.where((element) => element.nameEng.toUpperCase().contains(name.toUpperCase())).toList()));

      }

    } catch (error) {
      emit(ProductErrorState(error));
    }
  }

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    // This method is now empty because we're handling events in individual event handlers
  }
}
