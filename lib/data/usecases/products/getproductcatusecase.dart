
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/repositories/product/productcarreposirory.dart';

import '../../../core/usecase.dart';
@singleton
class GetProductcatUsecase extends UseCase<List<ProductCat>, NoParams?> {
  final ProductCatRepository _itemRepository;

  const GetProductcatUsecase ({
    required ProductCatRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<List<ProductCat>> call([NoParams? params]) {
    return _itemRepository.getAllCatProducts();
  }
}
