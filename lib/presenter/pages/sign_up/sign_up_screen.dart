import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../assets.gen.dart';
import '../../widgets/scaffold.dart';
import '../sign_in/components/socal_card.dart';
import 'components/sign_up_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


@RoutePage()
class SignUpScreen extends StatelessWidget {

  final String from ;


  const SignUpScreen({super.key,@PathParam('from') required this.from});

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      appBar: AppBar(

        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 16),
                  Image(
                    image: Assets.images.chachingIcon.provider(),
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                   Text(
                    AppLocalizations.of(context)?.signup_title ??"",
                  ), //style: ),
                   Text(
                     AppLocalizations.of(context)?.sign_up_subtitle ??"",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                   SignUpForm(from: from,),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {},
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)?.generate_condition??"",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
