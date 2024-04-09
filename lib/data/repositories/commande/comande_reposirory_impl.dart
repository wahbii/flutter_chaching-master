import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/commande.dart';
import 'package:pokedex/data/repositories/commande/commande_repository.dart';

import '../../../presenter/pages/cart/cart_screen.dart';
import '../../entities/card_item.dart';
import '../../entities/giveaway.dart';

@Singleton(as: CommandeRepository)
class CommandeRepositoryImpl extends CommandeRepository {
  final db = FirebaseFirestore.instance;
  static const String db_name = "commandes";

  @override
  Future<int> addCommande(Commande commande, List<GiveAway> givaways) async {
    List<String> giveAwaysId = [];
    commande.items.forEach((element) {
      if (!giveAwaysId.contains(element.idTobola)) {
        giveAwaysId.add(element.idTobola);
      }
    });
    List<Map<String, dynamic>> productsList = commande.items.map((cardItem) {
      return {
        "quantite": cardItem.quantite,
        "images": cardItem.images,
        "nameFr": cardItem.nameFr,
        "nameAr": cardItem.nameAr,
        "nameEng": cardItem.nameEng,
        "price": cardItem.price,
        "product_id": cardItem.pId,
        "user_id": cardItem.userId,
        "id_tombola": cardItem.idTobola
      };
    }).toList();
    await db.collection(db_name).doc().set({
      "ref": commande.ref,
      "products": productsList,
      "status": commande.status,
      "phone": commande.phone,
      "name": commande.name,
      "id_user": commande.userId,
      "email": commande.email,
      "adress": commande.adress
    });

    giveAwaysId.forEach((element) async {
      List<String> dataJetons = [];
      commande.items
          .where((cmd) => cmd.idTobola == element)
          .toList()
          .forEach((filtrcmd) {
        for (int i = 0; i < filtrcmd.quantite; i++) {
          dataJetons.add("${commande.ref}|| ${generateRandomString(10)}");
          // Print the current value of i
        }
      });
      var giveAway = givaways.where((gv) => gv.id == element).first;
      print(giveAway);
      var comds = giveAway.commandesId;
      comds = comds + dataJetons;
      await db.collection("giveaways").doc(element).set({
        "titleEng": giveAway.titleEng,
        "titleFr": giveAway.titleFr,
        "titleAr": giveAway.titleAr,
        "descAr": giveAway.descAr,
        "descFr": giveAway.descFr,
        "descEng": giveAway.descEng,
        "image": giveAway.img,
        "tempsRest": giveAway.dateRest,
        "participante": 0,
        "Url": giveAway.Url,
        "idWinner": giveAway.idWinner,
        "prixMax": giveAway.prixMax,
        "prixMin": giveAway.prixMin,
        "commandeId": comds
      }).onError((error, stackTrace) => print("errorfirebase  :   $error"));
    });
    commande.items.forEach((element) async {
      await db.collection("panier").doc(element.id).delete();
    });

    return 0;
  }

  @override
  Future<List<Commande>> getAllItems(String? userId) async {
    List<Commande> commandes = [];

    // Query Firestore collection
    QuerySnapshot querySnapshot = await db.collection(db_name).get();

    // Iterate over documents
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      List<CardItem> items = [];
      List<dynamic> products = data?["products"];

      // Iterate over products and convert them to CardItem objects
      products.forEach((product) {
        CardItem item = CardItem(
          pId: "",
          cat: "",
          nameFr: product["nameFr"],
          nameAr: product["nameAr"],
          nameEng: product["nameEng"],
          units: 0,
          price: product["price"],
          images: product["images"],
          id: "",
          quantite: product["quantite"],
          userId: product["user_id"],
          idTobola: product["id_tombola"],
        );
        items.add(item);
      });

      // Create Commande object and add to the list
      Commande commande = Commande(
          userId: data?["id_user"],
          ref: data?["ref"],
          id: doc.id,
          items: items,
          status: data?["status"],
          phone: data?["phone"],
          name: data?["name"],
          adress: data?["adress"],
          email: data?["email"]);
      commandes.add(commande);
    });

    return userId == null
        ? commandes
        : commandes.where((element) => element.userId == userId).toList();
  }

  @override
  Future<int> removeProduct(String id) async {
    await db.collection(db_name).doc(id).delete();
    return 0;
  }

  @override
  Future<int> updateProduct(Commande commande, int status) async {
    List<Map<String, dynamic>> productsList = commande.items.map((cardItem) {
      return {
        "quantite": cardItem.quantite,
        "images": cardItem.images,
        "nameFr": cardItem.nameFr,
        "nameAr": cardItem.nameAr,
        "nameEng": cardItem.nameEng,
        "price": cardItem.price,
        "product_id": cardItem.pId,
        "user_id": cardItem.userId,
        "id_tombola": cardItem.idTobola,
      };
    }).toList();
    await db.collection(db_name).doc(commande.id).set({
      "ref": commande.ref,
      "products": productsList,
      "status": status,
      "phone": commande.phone,
      "name": commande.name,
      "id_user": commande.userId,
      "email": commande.email,
      "adress": commande.adress
    });

    return 0;
  }
}

class GiveAwayJtn {
  String id;
  List<String> jtn;

  GiveAwayJtn({required this.id, required this.jtn});
}
