class CardItem {
  String pId;
  String cat ;
  String nameFr ;
  String nameAr ;
  String nameEng;
  int units ;
  double price ;
  String images ;
  String id;
  int quantite;
  String userId ;
  String idTobola ;

  CardItem ({
    required this.pId,
    required this.id ,
    required this.nameAr,
    required this.nameFr,
    required this.nameEng,
    required this.cat ,
    required this.price ,
    required this.units,
    required this.images,
    required this.quantite ,
    required this.userId,
    required this.idTobola
  });
}