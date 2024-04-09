import 'package:pokedex/data/entities/card_item.dart';

abstract class CardRepository{
  Future<List<CardItem>> fetchData(String userId);
  Future<int> addToCard(CardItem cardItem);
  Future<int> addModifyQuantite( CardItem cardItem,);
  Future<int> removeFromCard(String id);
}