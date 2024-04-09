import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/card_item.dart';

import '../../../core/usecase.dart';
import '../../repositories/card/card_repository.dart';
@singleton
class FetchCardUseCase extends UseCase<List<CardItem>, String> {
  final CardRepository cardRepository;

  FetchCardUseCase({required this.cardRepository});

  @override
  FutureOr<List<CardItem>> call(String params) async{
    return cardRepository.fetchData(params);
  }


}
