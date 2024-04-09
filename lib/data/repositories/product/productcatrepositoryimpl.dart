import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/entities/productcat.dart';
import 'package:pokedex/data/repositories/product/productcarreposirory.dart';

@Singleton(as: ProductCatRepository)
class ProductCatRepositoryImpl extends ProductCatRepository {
  ProductCatRepositoryImpl();
  final  db = FirebaseFirestore.instance;
  static String dbname = "CatProducts";

  @override
  Future<List<ProductCat>> getAllCatProducts() async {
    List<ProductCat> documents = [];
    documents.add(
        ProductCat(titleEng: "Top Item Sold", titleFr: "Article le plus vendu",titleAr :"أعلى بيع السلعة",isSlected: true, id: '',));
    QuerySnapshot querySnapshot =
        await db.collection(dbname).get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      documents.add(
          ProductCat(titleEng: data?["titleEng"], titleAr:data?["titleAr"],titleFr :data?["titleFr"], id: doc.id,isSlected: false,));
    });
    return documents;
  }

  @override
  Future<int> addProductCat(ProductCat productCat) async{
    var result = await db.collection(dbname).doc().set({
      "titleEng": productCat.titleEng ,
       "titleFr":productCat.titleFr,
      "titleAr" :productCat.titleAr
    });
    return 0 ;
  }

  @override
  Future<int> removeProductCat(String id) async {
    var result = await db.collection(dbname).doc(id).delete();
    return 0 ;
  }

  @override
  Future<int> updateProductCat(ProductCat productCat) async {
    var result = await db.collection(dbname).doc(productCat.id).set({
      "titleEng": productCat.titleEng ,
      "titleFr":productCat.titleFr,
      "titleAr" :productCat.titleAr
    });
    return 0 ;
  }
}
