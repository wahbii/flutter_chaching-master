import 'package:pokedex/data/entities/commande.dart';

import '../../entities/giveaway.dart';

abstract class CommandeRepository {
  Future<List<Commande>> getAllItems(String? useriD);

  Future<int> removeProduct(String id);

  Future<int> updateProduct(
    Commande commande,
    int status,
  );

  Future<int> addCommande(Commande commande,List<GiveAway>giveaways);
}
