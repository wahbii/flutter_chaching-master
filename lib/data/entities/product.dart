class Product {
  String nameFr;
  String nameAr;
  String nameEng;
  String descFr;
  String descEng;
  String descAr;
  int units;
  double price;
  String images;
  String id;

  Product(
      {required this.id,
      required this.nameFr,
      required this.descAr,
      required this.nameEng,
      required this.descEng,
      required this.descFr,
      required this.nameAr,
      required this.price,
      required this.units,
      required this.images});
}
