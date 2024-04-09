import 'package:pokedex/data/entities/productcat.dart';

abstract class ProductCatRepository {
  const ProductCatRepository();

  Future<List<ProductCat>> getAllCatProducts();

  Future<int> addProductCat(ProductCat productCat);
  Future<int> removeProductCat(String id);
  Future<int> updateProductCat(ProductCat productCat);

}