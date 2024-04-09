import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/commande.dart';
import 'package:pokedex/data/repositories/commande/commande_repository.dart';
import 'package:pokedex/utils/enums.dart';

import '../../entities/giveaway.dart';

class CommandeArgs {
  final ApiActions actions;

  final Commande commande;

  final int? status;

  final List<GiveAway>? listGiveAwaY;

  CommandeArgs(
      {required this.actions, required this.commande, required this.status,required this.listGiveAwaY});
}

@singleton
class CommandeAUDUseCase extends UseCase<int, CommandeArgs> {
  final CommandeRepository itemRepository;

  CommandeAUDUseCase({required this.itemRepository});

  @override
  Future<int> call(CommandeArgs params) async {
    switch (params.actions) {
      case ApiActions.ADD:
        return itemRepository.addCommande(params.commande,params.listGiveAwaY??[]);
      case ApiActions.DELETE:
        return itemRepository.removeProduct(params.commande.id);
      case ApiActions.UPDATE:
        return itemRepository.updateProduct(
            params.commande, params.status ?? params.commande.status);
    }
  }
}

@singleton
class CommandeFetchUseCase extends UseCase<List<Commande>, String?> {
  final CommandeRepository itemRepository;

  CommandeFetchUseCase({required this.itemRepository});

  @override
  FutureOr<List<Commande>> call(String? noParams) {
    return itemRepository.getAllItems(noParams);
  }
}
