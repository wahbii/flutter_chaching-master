import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokedex/data/entities/giveaway.dart';

abstract class GiveAwayRepository {
  const GiveAwayRepository();

  Future<List<GiveAway>> getAllItems();

  Future<int> addGiveAway(GiveAway catGiveAway);

  Future<int> removeGiveAway(String id);

  Future<int> updateGiveAway(
    GiveAway GiveAway,
    String? titleFr,
    String? titleAr,
    String? titleEng,
    String? descFr,
    String? descAr,
    String? descEng,
    String? img,
    Timestamp? dateRest,
    int? participante,
    String? Url,
    String? idWinner,
    double? prixMax,
    double? prixMin,
  );
}
