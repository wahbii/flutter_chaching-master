import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';

import 'catGiveAwayRepository.dart';

@Singleton(as: CatGiveAwayRepository)
class CatGiveAwayRepositoryImpl extends CatGiveAwayRepository {
  CatGiveAwayRepositoryImpl();

  final db = FirebaseFirestore.instance;
  static String nameDb = "CatGiveAwaysDb";

  @override
  Future<List<CatGiveAway>> getAllItems() async {
    List<CatGiveAway> documents = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(nameDb).get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      documents.add(CatGiveAway(titleAr: data?["titleAr"],titleEng:data?["titleEng"] ,titleFr:  data?["titleFr"], id: doc.id));
    });
    documents.add(CatGiveAway(titleEng: "All",titleAr: "كل شىء", titleFr: "Le Tout",id: "0"));
    return documents;
  }

  @override
  Future<int> addGiveAwayCat(CatGiveAway catGiveAway) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('catGiveAWAYS').get();
    var found = false;
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data?["titleEng"] == catGiveAway.titleEng) {
        found = true;
      }
    });
    if(!found){
      var result = await db.collection(nameDb).doc().set({
        "titleEng": catGiveAway.titleEng,
         "titleAr":catGiveAway.titleAr,
          "titleFr":catGiveAway.titleFr
      });
      return 0;
    }else{
      return 1;
    }

  }

  @override
  Future<int> removeGiveAwayCat(String id) async {
    var result = await db.collection(nameDb).doc(id).delete();
    return 0;
  }

  @override
  Future<int> updateGiveAwayCat(CatGiveAway catGiveAway) async{
    var result = await db.collection(nameDb).doc(catGiveAway.id).set(
      {

        "titleEng": catGiveAway.titleEng,
        "titleAr":catGiveAway.titleAr,
        "titleFr":catGiveAway.titleFr

      }
    );
    return 0;
  }
}
