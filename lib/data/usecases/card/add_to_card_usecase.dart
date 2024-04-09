

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/core/usecase.dart';
import 'package:pokedex/data/entities/card_item.dart';
import 'package:pokedex/data/repositories/card/card_repository.dart';
@singleton
class AddToCardUsercase extends UseCase<int, CardItem>{

  final CardRepository cardRepository;

  AddToCardUsercase({required this.cardRepository});

  @override
  FutureOr<int> call(CardItem params) {
     return cardRepository.addToCard(params);
  }

}