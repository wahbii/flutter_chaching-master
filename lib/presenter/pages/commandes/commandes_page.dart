import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/states/providers/commande/commande_bloc.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/entities/card_item.dart';
import '../../../data/entities/commande.dart';
import '../../../data/entities/giveaway.dart';
import '../../../data/states/providers/giveAwayBloc.dart';
import '../../../utils/size.dart';
import '../../themes/colors.dart';
import '../../widgets/login_indicator.dart';
import '../cart/components/cart_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


@RoutePage()
class CommadesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CommandesState();
  }
}

class _CommandesState extends State<CommadesScreen> {
  GiveAwayBloc get giveAway => context.read<GiveAwayBloc>();
  late SharedPreferences prefs;
  bool showLoader = true;

  CommandeBloc get cmdBloc => context.read<CommandeBloc>();
  List<Commande> commandes = [];
  List<GiveAway> giveaways = [];
  List<String> jetons = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeState();
  }

  void initializeState() async {
    prefs = await SharedPreferences.getInstance();
    cmdBloc.add(LoadCommandeEvent(id_user: prefs.getString("id") ?? ""));
    giveAway.add(LoadGiveAwayEvent());
    showLoader = true;
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
        appBar: FirebaseAuth.instance.currentUser == null
            ? null
            : AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Define the action you want to perform when the back button is pressed
              // For example, navigate to a different route:
              context.router.replaceAll([const MenuHomeRoute()]);
            },
          ),
          title: Column(
            children: [
              Text(
                AppLocalizations.of(context)?.cmd_title ?? "",
                style:
                    context.typographies.bodyLarge.withColor(AppColors.black),
              ),
            ],
          ),
        ),
        body: FirebaseAuth.instance.currentUser == null
            ? LoginIndicatorWidget()
            : MultiBlocListener(
                listeners: [
                  BlocListener<CommandeBloc, CommandeState>(
                      listener: (context, state) {
                    if (state is CommandeLoadingState) {
                    } else if (state is CommandeFeatchState) {
                      setState(() {
                        commandes = state.data;
                        showLoader = false;
                      });
                    } else if (state is CommandeErrorState) {
                      setState(() {
                        showLoader = false;
                      });
                    }
                  }),
                  BlocListener<GiveAwayBloc, GiveAwayState>(
                    listener: (context, state) {
                      if (state is GiveAwayLoadedState) {
                        setState(() {
                          showLoader = false;
                          giveaways = state.data;
                        });
                      } else if (state is GiveAwayErrorState) {
                        setState(() {
                          showLoader = false;
                        });
                      }
                    },
                  ),
                ],
                child: Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: commandes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 4),
                          child: _buildItem(commandes[index], index),
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
              ));
  }

  Widget getHeader(Commande cmd) {
    return Container(
      height: getFullHeight(context) * 0.06,
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
            width: 50,
          ),
          Text(
            cmd.ref,
            style: context.typographies.body
                .withColor(AppColors.black)
                .withWeight(FontWeight.w600),
          ),
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

  Widget _buildItem(Commande commande, int index) {
    getJetons(commande.ref);
    return InkWell(
        child: Card(
      elevation: 6,
      child: Column(
        children: [
          getHeader(commande),
          getProduct(commande.items),
          _buildBottom(commande.status)
        ],
      ),
    ));
  }

  Widget _buildBottom(int status) {
    return Container(
        height: getFullHeight(context) * 0.1,
        width: getFullWigth(context),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
            color: AppColors.paarl_lite,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified,
                  color: AppColors.paarl,
                ),
                Container(
                  width: getFullWigth(context) * 0.25,
                  color: AppColors.white,
                  height: 2,
                ),
                Icon(
                  Icons.verified,
                  color: status >= 1 ? AppColors.paarl : AppColors.white,
                ),
                Container(
                  width: getFullWigth(context) * 0.25,
                  color: AppColors.white,
                  height: 2,
                ),
                Icon(
                  Icons.verified,
                  color: status == 2 ? AppColors.paarl : AppColors.white,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(AppLocalizations.of(context)?.preparation ?? ""),
                Text(AppLocalizations.of(context)?.execution ?? ""),
                Text(AppLocalizations.of(context)?.cloture ?? ""),
              ],
            )
          ],
        ));
  }

  List<String> getJetons(String ref) {
    List<String> jt = [];
    giveaways.forEach((element) {
      jt = jt + element.filterCommandesId(ref);
    });

    print(jt);
    return jt;
  }
}
