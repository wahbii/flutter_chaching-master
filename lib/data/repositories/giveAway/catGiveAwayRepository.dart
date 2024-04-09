import 'package:pokedex/data/entities/cat.giveaway.dart';

abstract class CatGiveAwayRepository {
  const CatGiveAwayRepository();
  Future<List<CatGiveAway>> getAllItems();
  Future<int> addGiveAwayCat(CatGiveAway catGiveAway);
  Future<int> removeGiveAwayCat(String id);
  Future<int> updateGiveAwayCat(CatGiveAway catGiveAway);
}