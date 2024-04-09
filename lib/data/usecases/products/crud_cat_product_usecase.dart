


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/repositories/product/productcarreposirory.dart';
import 'package:pokedex/utils/enums.dart';


class ArgCatProduct {
  final ProductCat productCat;
  final ApiActions actions;

  ArgCatProduct({
   required this.productCat ,
   required this.actions
});
}
@singleton
class CrudCatProductUseCase  extends UseCase<int,ArgCatProduct>{

  final ProductCatRepository itemRepository;

  CrudCatProductUseCase({
   required this.itemRepository
});

  @override
  FutureOr<int> call(ArgCatProduct params) {
    switch (params.actions) {
      case ApiActions.ADD:
        return itemRepository.addProductCat(params.productCat);
      case ApiActions.DELETE:
        return itemRepository.removeProductCat(params.productCat.id);
      case ApiActions.UPDATE:
        return itemRepository.updateProductCat(params.productCat,);
    }
  }





}