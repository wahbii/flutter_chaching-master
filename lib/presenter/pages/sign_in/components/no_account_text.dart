import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class NoAccountText extends StatelessWidget {
  final String fromScrenn ;
  const NoAccountText({
    Key? key,
    required this.fromScrenn
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Text(
          AppLocalizations.of(context)?.no_account??"",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: (){
              context.router.push(SignUpRoute(from: fromScrenn));
          },
          child: Text(
            AppLocalizations.of(context)?.signup_title??"",
            style: TextStyle(fontSize: 16, color: AppColors.paarl_lite),
          ),
        ),
      ],
    );
  }
}
