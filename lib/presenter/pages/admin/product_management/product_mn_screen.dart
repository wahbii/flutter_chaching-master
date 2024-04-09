import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/states/providers/product_bloc.dart';
import 'package:pokedex/data/usecases/products/crud_product_usecase.dart';
import 'package:pokedex/presenter/pages/admin/give_away_managment/widget/fabMenu.dart';
import 'package:pokedex/presenter/pages/admin/product_management/widgets/dialog_edit.dart';
import 'package:pokedex/presenter/pages/admin/product_management/widgets/dialog_edit_cat.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';

import '../../../../data/entities/product.dart';
import '../../../../data/entities/productcat.dart';
import '../../../../data/states/providers/product_cat_bloc.dart';
import '../../../widgets/app_bar.dart';

@RoutePage()
class ProductsMnPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsMnState();
  }
}

class _ProductsMnState extends State<ProductsMnPage> {

  ProductBloc get productBloc => context.read<ProductBloc>();
  List<Product> productList = [];
  bool showLoader = true;

  @override
  void initState() {
    super.initState();
    productBloc.add(LoadProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
        body: Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (_, __) => [
            AppMovingTitleSliverAppBar(title: 'Products'),
          ],
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: MultiBlocListener(
                listeners: [
                  BlocListener<ProductBloc, ProductState>(
                    listener: (context, state) {
                      if (state is ProductLoadingState) {
                        setState(() {
                          showLoader = true;
                        });
                      }  else if (state is ProductLoadedState) {
                        setState(() {
                          showLoader = false;
                          productList = state.data;
                        });
                      } else if (state is CrudProductLoadedState) {
                          productList= [];
                          productBloc.add(LoadProductEvent());
                      } else if (state is ProductErrorState) {
                        setState(() {
                          showLoader = false;
                        });
                      }
                    },
                  ),
                ],
                child: Stack(children: [
                  _buildItem(),
                  Visibility(
                      visible: showLoader,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ))
                ])),
          ),
        ),
        FabMenu(
          onSearch: (value) {},
          onSubmit: () {
           // productBloc.add(LoadProductEvent());
          },
          destination: AdminScreen.MNPRODUCT,
        )
      ],
    ));
  }

  Widget _buildItem() {
    return Card(
      elevation: 6,
       child: _expandedBodyWidgetItemList(productList),
      );

  }



  Widget _expandedBodyWidgetItemList(List<Product> products) {
    return ListView.builder(
      padding: null,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _expandedItem(products[index]);
      },
    );
  }

  Widget _expandedItem(Product product) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => RoundedDialog(
                product: product,
                onSubmit: () {
                  //productCatBloc.add(LoadProductCatEvent());
                  //Navigator.of(context).pop();
                  productBloc.add(LoadProductEvent());
                }));
      },
      key: ValueKey('expandedItem_${product.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Image.memory(base64Decode(product.images),
                        width: 100, height: 100, gaplessPlayback: true),
                    Container(
                      width: getFullWigth(context) * 0.3,
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nameEng,
                            style: context.typographies.bodySmall
                                .withWeight(FontWeight.w600),
                          ),
                          Text("Units  : ${product.units}",
                              style: context.typographies.bodySmall),
                          Text("Price  : ${product.price}",
                              style: context.typographies.bodySmall)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getFullHeight(context) * 0.1,
                      width: getFullWigth(context) * 0.25,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                showLoader = true;
                              });

                              productBloc.add(CrudProductEvent(ArgProduct(
                                  product: product,
                                  apiActions: ApiActions.DELETE)));
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            width: getFullWigth(context) * 0.8,
            height: 1,
            color: AppColors.paarl_lite,
          )
        ]),
      ),
    );
  }
}
