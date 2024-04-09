import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../entities/giveaway.dart';
import 'giveawayRepository.dart';

@Singleton(as: GiveAwayRepository)
class GiveAwayRepositoryImpl extends GiveAwayRepository {
  GiveAwayRepositoryImpl();

  var db = FirebaseFirestore.instance;

  static const String dbName = "giveaways";




  @override
  Future<List<GiveAway>> getAllItems() async {
    List<GiveAway> documents = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(dbName).get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      List<dynamic> firebaseData = data?["commandeId"] ?? [];
      List<String> commandIds = firebaseData.cast<String>().toList();
      documents.add(GiveAway(
        titleAr: data?["titleAr"],
        titleEng: data?["titleEng"],
        titleFr: data?["titleFr"],
        descFr:data?["descFr"] ,
        descAr:data?["descAr"] ,
        descEng:data?["descEng"] ,
        id: doc.id,
        img: data?["image"],
        idWinner:data?["idWinner"] ,
        Url: data?["Url"],
        participante: data?["participante"],
        dateRest: data?["tempsRest"],
        commandesId: commandIds,
         prixMax: data?["prixMax"] as double,
         prixMin: data?["prixMin"] as double,
      ));
    });

    return documents;
  }

  @override
  Future<int> addGiveAway(GiveAway giveAway) async {
    await db.collection(dbName).doc().set({
      "titleEng": giveAway.titleEng,
       "titleFr":giveAway.titleFr,
       "titleAr":giveAway.titleAr,
      "image": giveAway.img,
      "tempsRest": giveAway.dateRest,
      "participante": 0,
      "Url": giveAway.Url,
      "idWinner": giveAway.idWinner,
      "commandeId":[],
      "descFr":giveAway.descFr,
      "descAr":giveAway.descAr,
      "descEng":giveAway.descEng,
      "prixMax":  giveAway.prixMax,
      "prixMin": giveAway.prixMin
    });
    return 0;
  }

  @override
  Future<int> removeGiveAway(String id) async{
    await db.collection(dbName).doc(id).delete();
    return 0;
  }
  @override
  Future<int> updateGiveAway(GiveAway giveAway, String? titleFr,String? titleAr,String? titleEng ,String? descFr,String? descAr,String? descEng ,String? img, Timestamp? dateRest, int? participante, String? Url, String? idWinner,double? prixMax,
  double? prixMin, ) async {
    await db.collection(dbName).doc(giveAway.id).set({

      "titleEng":titleEng?? giveAway.titleEng,
      "titleFr":titleFr?? giveAway.titleFr,
      "titleAr":titleAr ??giveAway.titleAr,
      "image": img?? giveAway.img,
      "tempsRest": dateRest ?? giveAway.dateRest,
      "participante": participante ?? giveAway.participante,
      "Url": Url ?? giveAway.Url,
      "descFr": descFr?? giveAway.descFr,
      "descAr": descAr ?? giveAway.descAr,
      "descEng": descEng ?? giveAway.descEng,
      "idWinner": idWinner ??giveAway.idWinner,
       "prixMax": prixMax ?? giveAway.prixMax,
       "prixMin":prixMin ?? giveAway.prixMin,
      "commandeId":giveAway.commandesId,


    });
    return 0;
  }


}
