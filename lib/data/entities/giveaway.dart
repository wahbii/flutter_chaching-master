import 'package:cloud_firestore/cloud_firestore.dart';

class GiveAway {
  String titleEng;
  String titleAr;
  String titleFr;
  String descEng;
  String descAr;
  String descFr;
  String img;
  Timestamp dateRest;
  int participante;
  String id;
  String? Url;
  String? idWinner;
  List<String> commandesId;
  double prixMax;
  double prixMin;

  GiveAway(
      {required this.id,
      required this.dateRest,
      required this.img,
      required this.titleEng,
      required this.titleAr,
      required this.titleFr,
      required this.descEng,
      required this.descFr,
      required this.descAr,
      required this.commandesId,
      required this.participante,
      this.Url,
      required this.prixMax,
      required this.prixMin,
      this.idWinner});

  //Function to filter commandesId based on a given argument
  List<String> filterCommandesId(String arg) {
    List<String> filteredList = [];
    for (String commandId in commandesId) {
      if (commandId.contains(arg)) {
        filteredList.add(commandId);
      }
    }
    return filteredList;
  }
}
