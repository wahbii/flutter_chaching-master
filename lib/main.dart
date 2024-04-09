import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/app.dart';
import 'package:pokedex/di.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  Provider.debugCheckInvalidValueType = null;

  runApp(
    GlobalBlocProviders(
      child: PokedexApp(),
    ),
  );
}
