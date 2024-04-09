import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/data/entities/card_item.dart';
import 'package:pokedex/data/states/providers/cardManagment/card_bloc.dart';
import 'package:pokedex/data/states/providers/giveAwayBloc.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/detail_product/widgets/corners.dart';
import 'package:pokedex/presenter/pages/detail_product/widgets/product_des.dart';
import 'package:pokedex/presenter/pages/detail_product/widgets/product_image.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/entities/product.dart';
import '../../../data/states/providers/product_bloc.dart';
import '../../../utils/enums.dart';
import '../../widgets/scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


@RoutePage()
class ProductDetailPage extends StatefulWidget {
  final String id;
  final String idTombola;

  const ProductDetailPage({
    @PathParam('id') required this.id,
    @PathParam('id_tombola') required this.idTombola,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetailPage> {
  ProductBloc get productBloc => context.read<ProductBloc>();

  CardBloc get cardBloc => context.read<CardBloc>();

  Product? product;

  bool showloader = true;

  int quantite = 0;
  late SharedPreferences prefs ;

  @override
  void initState() {
    super.initState();
    initializeState();

  }

  void initializeState() async {
    showloader = true ;
    prefs = await SharedPreferences.getInstance();
    productBloc.add(LoadProductEventById(widget.id));
  }



  @override
  Widget build(BuildContext context) {


    return PokeballScaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star, color: AppColors.yellow,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoadingState) {

              } else if (state is ProductLoadedByIdState) {
                setState(() {
                  showloader = false;
                  product = state.data;
                });
              } else if (state is ProductErrorState) {
                setState(() {
                  showloader = false;
                });
              }
            },
          ),
          BlocListener<CardBloc, CardState>(listener: (context, state) {
            if (state is CardLoadingState) {

            } else if (state is AddToCardState) {
              setState(() {
                showloader = false;
              });
              context.router.push(const CartRoute());
            } else if (state is ProductErrorState) {
              setState(() {
                showloader = false;
              });
            }
          })
        ],
        child: getProductContent(product),
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                child:  ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:

                          MaterialStateProperty.all<Color>(AppColors.paarl),
                        ),
                        onPressed: () {
                          //Navigator.pushNamed(context, CartScreen.routeName);
                          if (quantite != 0) {
                            setState(() {
                              showloader = true;
                            });
                            var user = FirebaseAuth.instance?.currentUser;
                            user != null
                                ? cardBloc.add(AddProductToCardEvent(
                                cardItem: CardItem(
                                  id: "",
                                  nameFr: product!.nameFr,
                                  nameEng: product!.nameEng,
                                  nameAr: product!.nameAr,
                                  quantite: quantite,
                                  price: product!.price * quantite,
                                  images: product!.images,
                                  pId: product!.id,
                                  units: product!.units,
                                  userId: prefs.getString("id")??"",
                                  idTobola: widget.idTombola, cat: ''
                                )))
                                : context.router
                                .push(SignUpRoute(from: FromScreen.OTHER.text));
                          }
                        },
                        child: Text(AppLocalizations.of(context)?.add_to_card ?? ""),
                      )
                    ))));


  }

  Widget getProductContent(Product? product) {
    return Stack(
      children: [
        ListView(
          children: [
            ProductImages(product: product),
            TopRoundedContainer(
              color: Colors.white,
              child: Column(
                children: [
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return ProductDescription(
                        product: product,
                        quantite: quantite,
                        add: () {
                          setState(() {
                            quantite++;
                          });
                        },
                        minus: () {
                          quantite > 0
                              ? setState(() {
                            quantite--;
                          })
                              : print("object");
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: showloader,
          child: const Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  Widget _buildError() {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Container(
            padding: const EdgeInsets.only(bottom: 28),
            alignment: Alignment.center,
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
