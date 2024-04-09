import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/card_item.dart';

import '../../repositories/card/card_repository.dart';


@singleton
class ModifyQuantiteUseCase extends UseCase<int, CardItem> {
  final CardRepository cardRepository;

  ModifyQuantiteUseCase({required this.cardRepository});

  @override
  FutureOr<int> call(CardItem params) async {
    return cardRepository.addModifyQuantite(params);
  }
}
