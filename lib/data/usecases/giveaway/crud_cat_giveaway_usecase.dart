import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';

import '../../../utils/enums.dart';
import '../../repositories/giveAway/catGiveAwayRepository.dart';

class ArgCatGiveAway {
  final ApiActions action;
  final CatGiveAway catGiveAway;

  ArgCatGiveAway({required this.action, required this.catGiveAway});
}
@singleton
class CrudCatGiveAwayUseCase extends UseCase<int, ArgCatGiveAway> {
  final CatGiveAwayRepository itemRepository;

  CrudCatGiveAwayUseCase({required this.itemRepository});

  @override
  Future<int> call(ArgCatGiveAway params) async {
    switch (params.action) {
      case ApiActions.ADD:
        return itemRepository.addGiveAwayCat(params.catGiveAway);
      case ApiActions.DELETE:
        return itemRepository.removeGiveAwayCat(params.catGiveAway.id ?? "");
      case ApiActions.UPDATE:
        return itemRepository.updateGiveAwayCat(params.catGiveAway);
    }
  }
}
