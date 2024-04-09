import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/app.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/utils/constant.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/size.dart';
import '../../assets.gen.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences prefs;



  Future<void> _initAsyncState() async {
    prefs = await SharedPreferences.getInstance();
    // Any other asynchronous initialization can be added here
    var language = prefs.getString("language");
    if (language == null) {
     PokedexApp.of(context)?.changeLang(Locale("eng"));
    } else {
      PokedexApp.of(context)?.changeLang(Locale(language));
    }
  }

  @override
  void initState() {
    scheduleMicrotask(() async {
      _initAsyncState();
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      if(prefs.getBool("isAdmin") ==true ){
        PokedexApp.of(context)?.changeLang(Locale("eng"));
      }
      isfirstOpen()
          ? context.router.replaceAll([const OnboardingRoute()])
          : ((FirebaseAuth.instance?.currentUser != null)
              ? (prefs.getBool("isAdmin") == true
                  ? context.router.replaceAll([const MainAdminRoute()])
                  : context.router.replaceAll([const MenuHomeRoute()]))
              : context.router.replaceAll([
                  SignInRoute(from: FromScreen.SPLASH.text, idgiveAway: null)
                ]));

      prefs.setBool(kFirstOpen, false);
      // await context.router.replaceAll([const HomeRoute()]);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: getFullWigth(context),
      height: getFullHeight(context),
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              width: 120,
              height: 100,
              image: Assets.images.chachingIcon.provider()),
          SizedBox(
            width: getFullWigth(context) * 0.5,
            height: 6,
            child: const LinearProgressIndicator(
              backgroundColor: AppColors.paarl,
              valueColor: AlwaysStoppedAnimation(AppColors.paarl_lite),
              minHeight: 6,
            ),
          )
        ],
      ),
    ));
  }

  bool isfirstOpen() {
    bool? isFirstOpen = prefs.getBool(kFirstOpen);
    return isFirstOpen ?? true;
  }
}
