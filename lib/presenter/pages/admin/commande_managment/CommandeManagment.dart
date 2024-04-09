import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/states/providers/commande/commande_bloc.dart';
import 'package:pokedex/data/usecases/commande/commande_use_case.dart';
import 'package:pokedex/presenter/pages/onboarding/widget/rounded_button.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/entities/card_item.dart';
import '../../../../data/entities/commande.dart';
import '../../../../utils/size.dart';
import '../../../themes/colors.dart';
import '../../../widgets/app_bar.dart';
import '../../cart/components/cart_card.dart';
import '../give_away_managment/widget/fabMenu.dart';

@RoutePage()
class CommandeManagmentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommandeState();
  }
}

class _CommandeState extends State<CommandeManagmentScreen> {
  CommandeBloc get commandeBloc => context.read<CommandeBloc>();
  List<Commande> commandes = [];
  List<Commande> filterCommande = [] ;
  late SharedPreferences prefs;
  bool showLoader = true;
  StatusCmd _selectedItem = StatusCmd(id: 0, title: "Préparation");
  List<StatusCmd> _dropdownItems = [
    StatusCmd(id: 0, title: "Préparation"),
    StatusCmd(id: 1, title: "Exécution"),
    StatusCmd(id: 2, title: "Clôture")
  ];

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    prefs = await SharedPreferences.getInstance();
    commandeBloc.add(LoadCommandeEvent(id_user: null));
    showLoader = true;
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
        body: Stack(children: [
      NestedScrollView(
          headerSliverBuilder: (_, __) => [
                AppMovingTitleSliverAppBar(title: 'Commandes'),
              ],
          body: MultiBlocListener(
            listeners: [
              BlocListener<CommandeBloc, CommandeState>(
                listener: (context, state) async {
                  if (state is CrudCommandeState) {
                    commandeBloc.add(LoadCommandeEvent(
                        id_user: null));
                  } else if (state is CommandeFeatchState) {
                    setState(() {
                      showLoader = false;
                      commandes = state.data;
                      filterCommande = state.data;
                    });
                  } else if (state is CommandeErrorState) {
                    setState(() {
                      showLoader = false;

                    });
                    print("hello ${state.error}");
                  }
                },
              ),
            ],
            child: Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: filterCommande.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 4),
                      child: _buildItem(filterCommande[index], index),
                    );
                  },
                ),
                Visibility(
                  visible: showLoader,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          )),
      FabMenu(
        onSearch: (value) {
          setState(() {
            filterCommande = commandes.where((element) => element.ref == value?.split("xx")).toList();
          });
        },
        onSubmit: () {},
        destination: AdminScreen.MNCOMMANDE,
      )
    ]));
  }

  Widget _buildItem(Commande commande, int index) {
    return InkWell(
        child: Card(
      elevation: 6,
      child: Column(
        children: [
          getHeader(commande),
          getProduct(commande.items),
          _buildBottom(commande)
        ],
      ),
    ));
  }

  Widget getHeader(Commande cmd) {
    return Container(
      height: getFullHeight(context) * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: AppColors.paarl_lite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            // Adjust the radius according to your preference
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Icon(
                Icons.numbers,
                color: AppColors.paarl_lite,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cmd.ref,
                style: context.typographies.body
                    .withColor(AppColors.black)
                    .withWeight(FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          RoundedButton(
              key: Key(""),
              text: _dropdownItems[cmd.status].title,
              onPressed: () {},
              color: AppColors.black,
              width: 150,
              onlyText: false)
        ],
      ),
    );
  }

  Widget getProduct(List<CardItem> data) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return CartCard(
            showIcon: false,
            cart: data[index],
            onMinus: () {},
            onPlus: () {},
          );
        });
  }

  Widget _buildBottom(Commande cmd) {
    return Container(
        height: getFullHeight(context) * 0.25,
        width: getFullWigth(context),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
            color: Color(0xFFF5F6F9),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: getFullWigth(context),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name :",
                      style: context.typographies.body,
                    ),
                    Text(cmd.name, style: context.typographies.body),
                  ],
                )),
            Container(
                width: getFullWigth(context),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone :",
                      style: context.typographies.body,
                    ),
                    Text(cmd.phone, style: context.typographies.body)
                  ],
                )),
            Container(
                width: getFullWigth(context),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Adress :",
                      style: context.typographies.body,
                    ),
                    Text(cmd.adress, style: context.typographies.body)
                  ],
                )),
            Container(
                width: getFullWigth(context),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "email :",
                      style: context.typographies.body,
                        softWrap: false, // Set softWrap to false to prevent wrapping
                        overflow: TextOverflow.ellipsis
                    ),
                    Text(cmd.email, style: context.typographies.body)
                  ],
                )),
            Container(
                width: getFullWigth(context),
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status:",
                      style: context.typographies.body,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<StatusCmd>(
                          value: _dropdownItems[cmd.status],
                          dropdownColor: Colors.grey[200],
                          // Dropdown background color
                          elevation: 0,
                          // No shadow
                          icon: Icon(Icons.arrow_drop_down),
                          // Custom dropdown icon
                          style: TextStyle(color: Colors.black),
                          // Dropdown text color
                          items: _dropdownItems.map((StatusCmd item) {
                            return DropdownMenuItem<StatusCmd>(
                              value: item,
                              child: Text(item.title,
                                  style: context.typographies.body),
                            );
                          }).toList(),
                          onChanged: (StatusCmd? newValue) {
                            setState(() {
                              //_selectedItem = newValue!;
                              setState(() {
                                showLoader = true;
                              });
                              var commandeArgs = CommandeArgs(
                                  actions: ApiActions.UPDATE,
                                  commande: cmd,
                                  status: newValue?.id,
                                  listGiveAwaY: []);
                              commandeBloc.add(CrudCammandeEvent(
                                  commandeArgs: commandeArgs));
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}

class StatusCmd {
  final int id;

  final String title;

  StatusCmd({required this.id, required this.title});
}
