
import 'package:injectable/injectable.dart';

import '../../../core/usecase.dart';
import '../../entities/product.dart';
import '../../repositories/product/productrepository.dart';
@singleton
class GetProductUseCase extends UseCase<List<Product>, NoParams?> {
  final ProductRepository _itemRepository;

  const GetProductUseCase({
    required ProductRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<List<Product>> call([NoParams? params]) {
    return _itemRepository.getAllItems();
  }
}
