

import 'package:injectable/injectable.dart';

import '../../../core/usecase.dart';
import '../../entities/giveaway.dart';
import '../../repositories/giveAway/giveawayRepository.dart';

@singleton
class GetGiveAwayUseCase extends UseCase<List<GiveAway>, NoParams?> {
  final GiveAwayRepository _itemRepository;

  const GetGiveAwayUseCase({
    required GiveAwayRepository itemRepository,
  }) : _itemRepository = itemRepository;

  @override
  Future<List<GiveAway>> call([NoParams? params]) {
    return _itemRepository.getAllItems();
  }
}