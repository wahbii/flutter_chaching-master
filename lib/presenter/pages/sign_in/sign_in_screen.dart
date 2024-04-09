import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/enums.dart';
import '../../assets.gen.dart';
import '../../navigation/navigation.dart';
import '../../themes/colors.dart';
import '../../widgets/scaffold.dart';
import 'components/no_account_text.dart';
import 'components/sign_form.dart';
import 'components/socal_card.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
@RoutePage()
class SignInScreen extends StatelessWidget {
  final String from;
  final String? idgiveAway ;


  final TextEditingController emailController = TextEditingController();


  SignInScreen({super.key, @PathParam('from') required this.from,required this.idgiveAway});

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      appBar: AppBar(
        leading:  InkWell(
          child: const Icon(Icons.close),
          onTap: () async {
            /*if (from == FromScreen.SPLASH.text) {
              await context.router.replaceAll([const HomeRoute()]);
            } else {

            }*/
            await context.router.replaceAll([const MenuHomeRoute()]);

          },
        ),

      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image(
                    image: Assets.images.chachingIcon.provider(),
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                   Text(
                    AppLocalizations.of(context)?.welcome??"",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   Text(
                    AppLocalizations.of(context)?.sign_in_title??""  ,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SignForm(from: from),
                  const SizedBox(height: 20),
                  NoAccountText(fromScrenn: from),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }








}
