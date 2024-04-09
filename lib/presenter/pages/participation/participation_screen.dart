import 'dart:core';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/entities/commande.dart';
import 'package:pokedex/data/entities/jetons.dart';
import 'package:pokedex/data/states/providers/giveAwayBloc.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/login_indicator.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/extensions/string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/entities/giveaway.dart';
import '../../../data/states/providers/commande/commande_bloc.dart';
import '../../../utils/size.dart';
import '../../app.dart';
import '../../themes/colors.dart';
import '../admin/widgets/widgets.dart';
import '../settings/widget/rotate_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParticipationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ParticipationState();
  }
}

class _ParticipationState extends State<ParticipationScreen> {
  GiveAwayBloc get giveAway => context.read<GiveAwayBloc>();

  CommandeBloc get commandeBloc => context.read<CommandeBloc>();
  bool showLoader = true;
  String message = "";
  late SharedPreferences prefs;
  List<GiveAway> giveAways = [];
  List<Commande> commandes = [];
  List<Jetons> jtms = [];
  List<bool> expended = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeState();
  }

  void initializeState() async {
    prefs = await SharedPreferences.getInstance();
    giveAway.add(LoadGiveAwayEvent());
    showLoader = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PokeballScaffold(
        appBar: FirebaseAuth.instance.currentUser == null
            ? null
            : AppBar(
                leading: null,
                title: Column(
                  children: [
                    Text(
                      "",
                      style: context.typographies.bodyLarge
                          .withColor(AppColors.black),
                    ),
                  ],
                ),
              ),
        body: FirebaseAuth.instance?.currentUser == null
            ? LoginIndicatorWidget()
            : MultiBlocListener(
                listeners: [
                  BlocListener<GiveAwayBloc, GiveAwayState>(
                    listener: (context, state) {
                      if (state is GiveAwayLoadingState) {
                        setState(() {
                          showLoader = true;
                        });
                      } else if (state is GiveAwayLoadedState) {
                        if (state.data.isEmpty) {
                          message = "${AppLocalizations.of(context)?.card_emty_msg}";
                        } else {
                          message = "";
                          giveAways = state.data;
                          commandeBloc.add(LoadCommandeEvent(
                              id_user: prefs.getString("id") ?? ""));
                        }
                        setState(() {
                          showLoader = false;
                        });

                        // Display data
                      } else if (state is GiveAwayErrorState) {
                        setState(() {
                          showLoader = false;
                        });
                        print("error :${state.error}");
                      }
                    },
                  ),
                  BlocListener<CommandeBloc, CommandeState>(
                    listener: (context, state) {
                      if (state is CommandeLoadingState) {
                        setState(() {
                          showLoader = true;
                        });
                      } else if (state is CommandeFeatchState) {
                        commandes = state.data;
                        setState(() {
                          jtms = getJetons();
                          showLoader = false;
                        });
                      } else if (state is CommandeErrorState) {
                        setState(() {
                          showLoader = false;
                        });
                        print("error :${state.error}");
                      }
                    },
                  )
                ],
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: jtms.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 4),
                      child: _buildItem(jtms[index], index),
                    );
                  },
                ),
              ));
  }

  Widget _buildItem(Jetons jetons, int index) {
    //getJetons(jetons.giveAway);
    return InkWell(
        child: Card(
      elevation: 6,
      child: Column(
        children: [
          getHeader(jetons.giveAway, index),
          Visibility(
              visible: expended[index],
              child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: getProduct(jetons.jetons)))
        ],
      ),
    ));
  }

  List<Jetons> getJetons() {
    List<Jetons> data = [];
    giveAways.forEach((element) {
      var jetons = Jetons(giveAway: element, jetons: []);
      List<String> listJTN = [];
      commandes.forEach((cmd) {
        element.commandesId.forEach((cmdId) {
          print("${cmdId}  ${cmd.ref}");
          if (cmdId.split("||").first == cmd.ref) {
            listJTN.add(cmdId);
          }
        });
      });
      if (listJTN.isNotEmpty) {
        jetons.jetons = listJTN;
        data.add(jetons);
        expended.add(false);
      }
    });

    return data;
  }

  Widget getProduct(List<String> data) {
    return GridView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 2.58,
          mainAxisSpacing: 10,
        ),
        children: data!
            .map(
              (e) => CategoryCard(
                  title: e.toString(),
                  color: const  Color(0xFFF5F6F9),
                  onPressed: () {}),
            )
            .toList());
  }

  Widget getHeader(GiveAway cmd, int index) {
    return Container(
      height: getFullHeight(context) * 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: AppColors.paarl_lite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 20,
            // Adjust the radius according to your preference
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Icon(
                Icons.card_giftcard,
                color: AppColors.paarl_lite,
                size: 30,
              ),
            ),
          ),
          Text(
             PokedexApp.of(context)?.local == Locale("ar")
              ? cmd.titleAr.capitalize()
              : (PokedexApp.of(context)?.local == Locale("fr")
              ? cmd.titleFr.capitalize() ?? ""
              : cmd.titleEng.capitalize() ?? ""),
            style: context.typographies.body
                .withColor(AppColors.white)
                .withWeight(FontWeight.w600),
          ),
          !expended[index]
              ? InkWell(
                  onTap: () {
                    setState(() {
                      expended[index] = !expended[index];
                    });
                  },
                  child: Icon(
                    Icons.expand_circle_down,
                    color: AppColors.white,
                  ),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      expended[index] = !expended[index];
                    });
                  },
                  child: RotatedIcon(
                    icon: Icons.expand_circle_down,
                    angle: 180 * (3.141592653589793 / 180),
                    color: AppColors.white,
                  ),
                )
        ],
      ),
    );
  }
}
