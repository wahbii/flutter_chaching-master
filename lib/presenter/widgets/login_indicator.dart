



import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/utils/enums.dart';

import '../../utils/size.dart';
import '../assets.gen.dart';
import '../navigation/navigation.dart';
import '../pages/onboarding/widget/rounded_button.dart';
import '../themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [

    SvgPicture.asset(
    width: getFullWigth(context) * 0.9,
      height: getFullHeight(context) * 0.8,
         Assets.images.login),
      RoundedButton(
          onlyText: false,
          key: Key("next"),
          text: AppLocalizations.of(context)?.key_message_need_log_in ??""  ,
          width: getFullWigth(context) * 0.8,
          onPressed: () {

              //Navigator.pushReplacementNamed(context, HomeScreen.path);
              context.router.push( SignInRoute   (from: FromScreen.OTHER.text, idgiveAway: null));
          },
          color: AppColors.paarl_lite),
    ],),);
  }

}