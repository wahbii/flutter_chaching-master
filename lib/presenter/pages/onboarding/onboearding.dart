import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/onboarding/widget/rounded_button.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/size.dart';
import 'onboardingModel.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  static const path = "OnboardingScreen";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingPage> {
  var currentIndex = 0;

  List<OnboardingModel> provideData(BuildContext context){
    return [
      OnboardingModel(
          AppLocalizations.of(context)?.step_1_title??"",
          "Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée",
          "assets/images/login.svg"),
      OnboardingModel(
          AppLocalizations.of(context)?.step_2_title??"",
          "Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée",
          "assets/images/onboarding_step_1.svg"),
      OnboardingModel(
          AppLocalizations.of(context)?.step_3_title??"",
          "Le lorem ipsum est, en imprimerie, une suite de mots sans signification utilisée à titre provisoire pour calibrer une mise en page, le texte définitif venant remplacer le faux-texte dès qu'il est prêt ou que la mise en page est achevée",
          "assets/images/gift_winner.svg")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: getFullWigth(context),
      height: getFullHeight(context),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          progressHeader(context),
          Container(
            height: getFullHeight(context) * 0.8,
            width: getFullWigth(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                    width: getFullWigth(context) * 0.9,
                    height: getFullHeight(context) * 0.3,
                    provideData(context)[currentIndex].image),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    provideData(context)[currentIndex].title,
                    textAlign: TextAlign.start,
                    style: context.typographies.body.copyWith(
                        color: AppColors.paarl,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none).withSize(18),
                  ),
                ),

              ],
            ),
          ),
          listOfAction(context)
        ],
      ),
    ));
  }

  Widget progressHeader(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: getFullHeight(context) * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            itemprogressHeader(context, AppColors.paarl),
            currentIndex >= 1
                ? itemprogressHeader(context, AppColors.paarl)
                : itemprogressHeader(context, AppColors.paarl_lite),
            currentIndex == provideData(context).length - 1
                ? itemprogressHeader(context, AppColors.paarl)
                : itemprogressHeader(context, AppColors.paarl_lite),
          ],
        ));
  }

  Widget itemprogressHeader(BuildContext context, Color color) {
    return Container(
      width: getFullWigth(context) * 0.3,
      height: 5,
      color: color,
    );
  }

  Widget listOfAction(BuildContext context) {
    return Container(
      width: getFullWigth(context),
      height: getFullHeight(context) * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RoundedButton(
              onlyText: true,
              key: Key("next"),
              text: currentIndex == provideData(context).length - 1 ? AppLocalizations.of(context)?.sign_in ??"" : AppLocalizations.of(context)?.next ??"",
              width: getFullWigth(context) * 0.4,
              onPressed: () {
                print(currentIndex);
                if (currentIndex < provideData(context).length - 1) {
                  setState(() {
                    currentIndex++;
                  });
                } else {
                  //Navigator.pushReplacementNamed(context, HomeScreen.path);
                  context.router.push( SignUpRoute(from: FromScreen.SPLASH.text));
                }
              },
              color: AppColors.paarl_lite),
          RoundedButton(
              onlyText: false,
              key: Key("Sign In "),
              text: AppLocalizations.of(context)?.login ??"",
              width: getFullWigth(context) * 0.4,
              onPressed: () {
                //Navigator.pushReplacementNamed(context, HomeScreen.path);
                context.router.push( SignInRoute(from: FromScreen.SPLASH.text,idgiveAway: null));
              },
              color: AppColors.paarl)
        ],
      ),
    );
  }
}
