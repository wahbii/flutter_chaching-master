part of '../product_list.dart';

class ProductGrid extends StatefulWidget {

  final String idTombola ;
  const ProductGrid({required this.idTombola});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  static const double _endReachedThreshold = 200;

  final GlobalKey<NestedScrollViewState> _scrollKey = GlobalKey();

  ProductCatBloc get productCatBloc => context.read<ProductCatBloc>();

  ProductBloc get productBloc => context.read<ProductBloc>();

  CardBloc get cardBloc => context.read<CardBloc>();

  GiveAwayBloc get giveAwayBloc => context.read<GiveAwayBloc>();

  late GiveAway giveAway ;


  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
     // productCatBloc.add(LoadProductCatEvent());
      giveAway = giveAwayBloc.mainData.where((element) => element.id == widget.idTombola).first ;
      productBloc.add(LoadProductEvent());
      _scrollKey.currentState?.innerController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollKey.currentState?.innerController.dispose();
    _scrollKey.currentState?.dispose();

    super.dispose();
  }

  void _onScroll() {
    final innerController = _scrollKey.currentState?.innerController;

    if (innerController == null || !innerController.hasClients) return;

    final thresholdReached =
        innerController.position.extentAfter < _endReachedThreshold;
  }

  Future _onRefresh() async {
    productBloc.add(LoadProductEvent());
  }

  List<Product> products = [];
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          width: MediaQuery
              .sizeOf(context)
              .width,
          height: MediaQuery
              .sizeOf(context)
              .height ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: _cardList()),],
          ),
        ),

     /* _FabMenu(idGiveAway: widget.idTombola ,onSearch: (elm){

        productBloc.add(LoadProductEventBySearch(elm??""));
      },),*/
    ],);
  }

  Widget _buildGrid(List<Product> products) {
    return products.isEmpty ?  Center(child: Text("${AppLocalizations.of(context)?.empty_products}"),):
        CustomScrollView(
          slivers: [
         //   PokemonRefreshControl(onRefresh: _onRefresh),
            SliverPadding(
              padding: const EdgeInsets.all(1),
              sliver: NumberOfPokemonsSelector((numberOfPokemons) {
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (_, index) {
                      return buildCard(products[index]);
                    },
                    childCount: products.length,
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: PokemonCanLoadMoreSelector((canLoadMore) {
                if (!canLoadMore) {
                  return const SizedBox.shrink();
                }

                return Container(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: null,
                );
              }),
            ),
          ],



    );
  }

  Widget _buildError() {
    return CustomScrollView(
      slivers: [
        PokemonRefreshControl(onRefresh: _onRefresh),
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





  Widget _cardList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery
          .sizeOf(context)
          .width,
      height: MediaQuery
          .sizeOf(context)
          .height  - MediaQuery
          .sizeOf(context)
          .width * 0.22-105,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoadingState) {
                setState(() {
                  showLoader = true;
                });
              } else if (state is ProductLoadedState) {
                setState(() {
                  showLoader = false;
                  products = state.data.where((element) =>  element.price >= giveAway.prixMin && element.price <= giveAway.prixMax).toList();
                });
                // Display data
              } else if (state is ProductErrorState) {
                setState(() {
                  showLoader = false;
                });
              }
            },
          ),
          BlocListener<CardBloc, CardState>(
            listener: (context, state) {
              if (state is CardLoadingState) {
                setState(() {
                  showLoader = true;
                });
              } else if (state is AddToCardState) {
                setState(() {
                  showLoader = false;
                });
                // Display data
              } else if (state is CardErrorState) {
                setState(() {
                  showLoader = false;
                });
              }
            },
          )
        ],
        child: Center(
          child: _buildGrid(products),
        ),
      ),
    );
  }

  Card buildCard(Product product) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: InkWell(
            onTap: () {
              //  ProductDetailPage.product = product ;
              if (FirebaseAuth.instance.currentUser != null) {
                context.router.push(ProductDetailRoute(id: product.id,idTombola: widget.idTombola ));
              } else {
                context.router.push(SignInRoute(from: FromScreen.OTHER.text,idgiveAway: widget.idTombola));
              }
            },
            child: Column(
              children: [
                Container(
                    height: 110.0,
                    child: Image.memory(
                      base64Decode(product.images),
                      fit: BoxFit.cover,
                    )),
                ListTile(
                  title: Text(PokedexApp.of(context)?.local == Locale("ar")
                      ? product.nameAr
                      : (PokedexApp.of(context)?.local == Locale("fr")
                      ? product.nameFr
                      : product.nameEng),),
                  subtitle: Text(product.price.toString() +  AppLocalizations.of(context)!.currency ??""),
                  trailing: Card(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: AppColors.paarl,
                    child: const InkWell(
                        child: Icon(
                          Icons.add,
                          color: AppColors.white,
                        )),
                  ),
                ),
              ],
            )));
  }




}

