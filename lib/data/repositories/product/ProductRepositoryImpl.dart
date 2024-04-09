


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/product.dart';
import 'package:pokedex/data/repositories/product/productrepository.dart';

@Singleton(as: ProductRepository)
class ProductRepositoryImpl extends ProductRepository {
  ProductRepositoryImpl();

 final db = FirebaseFirestore.instance ;
 static String dbname ="products";
  @override
  Future<List<Product>> getAllItems() async {
    List<Product> documents = [];
    QuerySnapshot querySnapshot =
        await db.collection(dbname).get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      print(data);
      documents.add(Product(
        nameFr: data?["nameFr"] ,
        nameAr: data?["nameAr"] ,
        nameEng: data?["nameEng"],
        descAr: data?["descAr"] ,
        descFr: data?["descFr"] ,
        descEng: data?["descEng"] ,
        id: doc.id,
        images: data?["image"] ,
        units:  int.parse(data?["unit"].toString()??"0") ,
        price: double.parse(data?["price"].toString()??"0") ,
      ));
    });
    print(documents.first.price);
    return documents;
  }

  @override
  Future<int> removeProduct(String id) async{
    await db.collection(dbname).doc(id).delete();
    return 0;
  }

  @override
  Future<int> updateProduct(Product product, String? nameFr,String? nameAr, String? nameEng,String? descAr ,String? descFr,String? descEng  , int? units, double? price, String? images) async{
    await db.collection(dbname).doc(product.id).set({
      "nameFr": nameFr?? product.nameFr ,
      "nameAr": nameAr ?? product.nameAr ,
      "nameEng": nameEng ?? product.nameEng,
      "descAr": descAr ?? product.descAr ,
      "descFr": descFr ?? product.descFr ,
      "descEng": descEng ?? product.descEng,
      "image": images ?? product.images ,
      "unit":  units ?? product.units ,
      "price": price ?? product.price,
    });
    return 0;
  }

  @override
  Future<int> addProduct(Product product) async {
    await db.collection("products").doc().set(
        {
          "nameFr":  product.nameFr ,
          "nameAr": product.nameAr ,
          "nameEng":  product.nameEng,
          "descAr":  product.descAr ,
          "descFr":  product.descFr ,
          "descEng":  product.descEng, // Use default value if name is null
          "image": product.images ,
          "unit":  product.units ,
          "price":  product.price,
        }
    );
    return 0;
  }
}