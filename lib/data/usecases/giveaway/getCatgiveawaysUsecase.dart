import 'package:injectable/injectable.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';

import '../../../core/usecase.dart';
import '../../repositories/giveAway/catGiveAwayRepository.dart';
@singleton
class GetCatGiveAwaysUsecase extends UseCase<List<CatGiveAway>, NoParams?> {
  final CatGiveAwayRepository _itemRepository;

  const GetCatGiveAwaysUsecase({
    required CatGiveAwayRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<List<CatGiveAway>> call([NoParams? params]) {
    return _itemRepository.getAllItems();
  }
}
