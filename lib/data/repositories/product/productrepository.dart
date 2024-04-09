import 'package:pokedex/data/entities/product.dart';

abstract class ProductRepository {
  const ProductRepository();

  Future<List<Product>> getAllItems();

  Future<int> removeProduct(String id);

  Future<int> updateProduct(
    Product product,
    String? nameFr,
    String? nameAr,
    String? nameEng,
    String? descAr,
    String? descFr,
    String? descEng,
    int? units,
    double? price,
    String? images,
  );

  Future<int> addProduct(Product product);
}
