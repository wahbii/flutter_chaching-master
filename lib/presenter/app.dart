import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:pokedex/data/states/settings/settings_selector.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';

class PokedexApp extends StatefulWidget {
  final AppRouter _router = AppRouter();

  PokedexApp({super.key});

  static _PokedexState? of(BuildContext context) => context.findAncestorStateOfType<_PokedexState>();


  @override
  State<StatefulWidget> createState() {
    return _PokedexState();
  }
}

class _PokedexState extends State<PokedexApp> {
   var local = Locale('ar');



     void changeLang(Locale locale ){
       setState(() {
         local = locale;
       });


  }

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      maximumSize: const Size(400, 800),
      backgroundColor: Colors.black12,
      enabled: MediaQuery.sizeOf(context).shortestSide > 600,
      builder: (_) => SettingsThemeSelector(
        builder: (theme) => MaterialApp.router(
            title: 'ChaChing',
            theme: theme.themeData,
            routerConfig: widget._router.config(),
            scrollBehavior: AppScrollBehavior(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: local,
            supportedLocales: [
              Locale('en'), // English
              Locale('fr'),
              Locale('ar'), // Spanish
            ]),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
