import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../core/usecase.dart';
import '../../../utils/enums.dart';
import '../../entities/giveaway.dart';
import '../../repositories/giveAway/giveawayRepository.dart';

class ArgGiveAway {
  final ApiActions action;
  final GiveAway giveAway;
  String? titleFr;
  String? titleAr;
  String? titleEng;
  String? descFr;
      String? descAr;
  String? descEng;
  String? img;
  Timestamp? dateRest;
  int? participante;
  double? prixMax;
  double? prixMin ;
  String? Url;
  String? idWinner;

  ArgGiveAway({required this.action, required this.giveAway});
}
@singleton
class CrudGiveAwayUseCase extends UseCase<int, ArgGiveAway> {
  final GiveAwayRepository itemRepository;
  CrudGiveAwayUseCase({required this.itemRepository});
  @override
  Future<int> call(ArgGiveAway params) async {
    switch (params.action) {
      case ApiActions.ADD:
        return itemRepository.addGiveAway(params.giveAway);
      case ApiActions.DELETE:
        return itemRepository.removeGiveAway(params.giveAway.id);
      case ApiActions.UPDATE:
        return itemRepository.updateGiveAway(
            params.giveAway,
            params.titleFr,
            params.titleAr,
            params.titleEng,
            params.descFr,
            params.descAr,
            params.descEng,
            params.img,
            params.dateRest,
            params.participante,
            params.Url,
            params.idWinner,
            params.prixMax,
           params.prixMin
        );
    }
  }
}
