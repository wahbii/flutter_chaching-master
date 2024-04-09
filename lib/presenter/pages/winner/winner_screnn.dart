import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../data/entities/commande.dart';
import '../../../data/states/providers/commande/commande_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class WinnerScreen extends StatefulWidget {
  final String? idVideo;

  final String? jetons;

  WinnerScreen(
      {@PathParam('jetons') required this.jetons,
      @PathParam('idvideo') required this.idVideo});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WinnerScreen();
  }
}

class _WinnerScreen extends State<WinnerScreen> {
  CommandeBloc get commandeBloc => context.read<CommandeBloc>();
  late SharedPreferences prefs;
  late YoutubePlayerController _controller;

  Commande? commande;

  bool showLoader = true;

  bool noWinnerSelectedYet = false;

  void initializeState() async {
    prefs = await SharedPreferences.getInstance();
    commandeBloc.add(LoadCommandeByRefEvent(ref: widget.jetons ?? ""));
    showLoader = true;
    _controller = YoutubePlayerController(
      initialVideoId: '${widget.idVideo}',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.jetons?.isEmpty  != true && widget.jetons != null ) {
      print(widget.jetons);
      initializeState();
    } else {
      setState(() {
        noWinnerSelectedYet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
        appBar: AppBar(
          title: Text(
            "",
            style: context.typographies.body
                .withColor(AppColors.black)
                .withWeight(FontWeight.bold),
          ),
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<CommandeBloc, CommandeState>(
                listener: (context, state) async {
                  if (state is CommandeFeatchByRefState) {
                    setState(() {
                      commande = state.data;
                      showLoader = false;
                    });
                  } else if (state is CommandeErrorState) {
                    setState(() {
                      showLoader = false;
                    });
                    print("show  commande : ${state.error}");
                  }
                },
              ),
            ],
            child: noWinnerSelectedYet
                ? Center(
                    child: Text("${AppLocalizations.of(context)?.winner_not_chosen}"),
                  )
                : showLoader
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
              mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          winnerWidget(commande)
                        ],
                      )));
  }

  Widget winnerWidget(Commande? commande) {
    return Container(
      height: getFullHeight(context) * 0.5,
      width: getFullWigth(context) * 0.9,
      margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/winner.png",
            width: 200,
            height: getFullHeight(context) * 0.2,
          ),
          Text("${AppLocalizations.of(context)?.the_winner_is} ${commande?.name}",style: context.typographies.bodyLarge,),
          Container(
            height: getFullHeight(context) * 0.25,
            width: getFullWigth(context) * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5))),
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
              progressColors: const ProgressBarColors(
                playedColor: AppColors.paarl,
                handleColor: AppColors.paarl_lite,
              ),
              onReady: () {
                _controller.addListener(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
