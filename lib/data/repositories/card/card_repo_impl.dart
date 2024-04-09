import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/card_item.dart';
import 'package:pokedex/data/repositories/card/card_repository.dart';

@Singleton(as: CardRepository)
class CardRepositoryImpl extends CardRepository {
  final db = FirebaseFirestore.instance;

  @override
  Future<int> addModifyQuantite( CardItem cardItem) async {
    await db.collection("panier").doc(cardItem.id).set({
      "quantite": cardItem.quantite,
      "images": cardItem.images,
      "nameFr":  cardItem.nameFr ,
      "nameAr": cardItem.nameAr ,
      "nameEng":  cardItem.nameEng,
      "price": cardItem.price,
      "product_id": cardItem.pId,
      "user_id": cardItem.userId,
      "id_tombola":cardItem.idTobola
    });
    return 0;
  }

  @override
  Future<int> addToCard(CardItem cardItem) async {
    CardItem  searchedcardItem = cardItem;
    int quantite = 0 ;
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('panier').get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data?["product_id"] == cardItem.pId) {
         quantite = data?["quantite"] as int ;
        searchedcardItem.id = doc.id ;
      }
    });
    if(searchedcardItem.id.isEmpty){
      await db.collection("panier").doc().set({
        "quantite": cardItem.quantite,
        "images": cardItem.images,
        "nameFr":  cardItem.nameFr ,
        "nameAr": cardItem.nameAr ,
        "nameEng":  cardItem.nameEng,
        "price": cardItem.price,
        "product_id": cardItem.pId,
        "user_id": cardItem.userId,
        "id_tombola":cardItem.idTobola
      });
    }else{
      await db.collection("panier").doc(searchedcardItem.id).set({
        "quantite": quantite+cardItem.quantite,
        "images": cardItem.images,
        "nameFr":  cardItem.nameFr ,
        "nameAr": cardItem.nameAr ,
        "nameEng":  cardItem.nameEng,
        "price": cardItem.price,
        "product_id": cardItem.pId,
        "user_id": cardItem.userId,
        "id_tombola":cardItem.idTobola
      });
    }

    return 0;
  }

  @override
  Future<int> removeFromCard(String id) async {
    await db.collection("panier").doc(id).delete();
    return 0;
  }

  @override
  Future<List<CardItem>> fetchData(String userId) async {
    List<CardItem> documents = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('panier').get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data?["user_id"] == userId) {
        documents.add(CardItem(
            pId: data?["product_id"],
            id: doc.id,
            nameFr:  data?["nameFr"] ,
            nameAr: data?["nameAr"] ,
            nameEng:  data?["nameEng"],
            cat: "",
            units:  0 ,
            price: double.parse(data?["price"].toString()??"0"),
            images: data?["images"],
            quantite: data?["quantite"],
            userId: data?["user_id"],
            idTobola: data?["id_tombola"]
        ));
      }
    });
    return documents;
  }
}
