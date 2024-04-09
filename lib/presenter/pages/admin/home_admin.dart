import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/admin/give_away_managment/widget/fabMenu.dart';
import 'package:pokedex/presenter/pages/admin/views/adamin_item_view_data.dart';
import 'package:pokedex/presenter/pages/admin/widgets/widgets.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';

import '../../../data/states/pokemon/pokemon_selector.dart';
import '../../app.dart';
import '../../widgets/app_bar.dart';
import '../productList/widgets/ca_card_widget.dart';

@RoutePage()
class MainAdminScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainAdminState();
  }
}

class _MainAdminState extends State<MainAdminScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  List<MenuAdminData> actions = [
    MenuAdminData(managmentType:ManagmentType.USER, title:  "User Management" ),
    MenuAdminData(managmentType:ManagmentType.GIVEAWAY, title:  "Give Away managment" ),
    MenuAdminData(managmentType:ManagmentType.PRODUCT, title: "Product Managment"),
    MenuAdminData(managmentType:ManagmentType.COMMANDE, title:  "Commande Managment"),
  ];

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return PokeballScaffold(
      body: Stack(children: [
        NestedScrollView(
          headerSliverBuilder: (_, __) => [
            AppMovingTitleSliverAppBar(title: 'Welcome Admin'),
          ],
          body: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [_buildGrid(actions)],
            ),
          ),
        ),
        FabMenu(onSearch: (value){

        },onSubmit: (){

        },destination: AdminScreen.HOME,)
      ],)
    );
  }

  Widget _buildGrid(List<MenuAdminData> cases) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.75,
        child:              GridView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            childAspectRatio: 1.5,
            mainAxisSpacing: 20,
          ),
          children:
          actions!.map((e) =>
              CategoryCard(
                  title: e.title,
                  color: AppColors.listColors[Random().nextInt(AppColors.listColors.length-1)],
                  onPressed: () {
                    switch(e.managmentType){
                      case ManagmentType.USER:
                           context.router.push(const UserManagmentRoute());
                        break;
                      case ManagmentType.GIVEAWAY:
                           context.router.push(const  GiveAwayMnRoute());
                        break;
                      case ManagmentType.COMMANDE:
                      // Handle GIVEAWAYS case
                          context.router.push(const CommandeManagmentRoute());
                        break;
                      case ManagmentType.PRODUCT:
                        context.router.push(const  ProductsMnRoute());

                        break;


                    }

                  }
              ),
          ).toList()

          ,
        ),
    );
  }


}
