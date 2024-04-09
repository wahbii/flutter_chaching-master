import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/product.dart';
import 'package:pokedex/utils/enums.dart';

import '../../../core/usecase.dart';
import '../../repositories/product/productrepository.dart';

class ArgProduct {
  final Product product;
  final ApiActions apiActions;


  String? nameFr;

  String? nameAr;

  String? nameEng;
  String? descFr;
  String? descEng;
  String? descAr;
  int? units;

  double? price;
  String? images;

  ArgProduct({required this.product, required this.apiActions});
}

@singleton
class CrudProductUseCase extends UseCase<int, ArgProduct> {
  final ProductRepository itemRepository;

  CrudProductUseCase({required this.itemRepository});

  @override
  FutureOr<int> call(ArgProduct params) {
    switch (params.apiActions) {
      case ApiActions.ADD:
        return itemRepository.addProduct(params.product);
      case ApiActions.DELETE:
        return itemRepository.removeProduct(params.product.id);
      case ApiActions.UPDATE:
        return itemRepository.updateProduct(
            params.product,
            params.nameFr,
            params.nameAr,
            params.nameEng,
            params.nameAr,
            params.nameFr,
            params.nameEng,
            params.units,
            params.price,
            params.images);
    }
  }
}
