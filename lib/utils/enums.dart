

enum FromScreen {
  SPLASH("SPLASH"),
  OTHER("OTHER");
  const FromScreen(this.text);
  final String text;
}

enum ManagmentType{
  USER(id: 0),
  GIVEAWAY(id: 1),
  PRODUCT(id: 2),
  COMMANDE(id: 3),
;



  const ManagmentType({required this.id});
  final int id;



}


enum ApiActions{
  UPDATE(id:0),
  DELETE(id:1),
  ADD(id:3);

  const ApiActions({required this.id});
  final int id;

}
enum AdminScreen{
  HOME(id:0),
  MNGIVEAWAY(id:1),
  MNPRODUCT(id:3),
  MNCOMMANDE(id: 4);

  const AdminScreen({required this.id});
  final int id;

}

