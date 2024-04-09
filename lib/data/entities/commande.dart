

import 'package:pokedex/data/entities/product.dart';

import 'card_item.dart';

class Commande {
  final String ref;
  final String id ;
  final String userId;
  final String name;
  final String phone;
  final  List<CardItem> items ;
  final  int status ;
  final  String adress;
  final String email ;
  Commande({required this.id ,required this.userId ,required this.name,required this.phone,required this.adress ,required this.email ,required this.items,required this.status,required this.ref});
}