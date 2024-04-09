

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/usecases/giveaway/getCatgiveawaysUsecase.dart';
import 'package:pokedex/data/usecases/giveaway/getGiveAwayUseCase.dart';

import '../../entities/giveaway.dart';

@singleton
class HomeProvider extends ChangeNotifier  {

  List<GiveAway> dataGiveAwayFilted = [] ;
  List<GiveAway> dataGiveAway = [] ;
  final GetCatGiveAwaysUsecase getCatGiveAwaysUsecase ;
  final GetGiveAwayUseCase getGiveAwaysUsecase ;

  HomeProvider({
    required this.getCatGiveAwaysUsecase ,
    required this.getGiveAwaysUsecase
  });

  Future<List<CatGiveAway>> getListCatGiveAway(){
     return getCatGiveAwaysUsecase.call();
  }

  Future<void> getListGiveAway() async {
     getGiveAwaysUsecase.call().then((value) {
       dataGiveAway = value ;
       dataGiveAwayFilted = value;

     }).onError((error, stackTrace) {

     });
  }

}