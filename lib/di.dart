import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/data/states/item/item_bloc.dart';
import 'package:pokedex/data/states/pokemon/pokemon_bloc.dart';
import 'package:pokedex/data/states/providers/auth_bloc.dart';
import 'package:pokedex/data/states/providers/cardManagment/card_bloc.dart';
import 'package:pokedex/data/states/providers/commande/commande_bloc.dart';
import 'package:pokedex/data/states/providers/giveAwayBloc.dart';
import 'package:pokedex/data/states/providers/homeprovider.dart';
import 'package:pokedex/data/states/providers/product_cat_bloc.dart';
import 'package:pokedex/data/states/providers/user_bloc.dart';
import 'package:pokedex/data/states/settings/settings_bloc.dart';
import 'package:pokedex/data/usecases/giveaway/getCatgiveawaysUsecase.dart';
import 'package:pokedex/data/usecases/giveaway/getGiveAwayUseCase.dart';
import 'package:provider/provider.dart';

import 'data/states/providers/product_bloc.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
FutureOr<void> configureDependencies() => getIt.init();

@module
abstract class RegisterModule {
  @singleton
  Dio get dio => Dio();
}

class GlobalBlocProviders extends StatelessWidget {
  final Widget child;

  const GlobalBlocProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PokemonBloc>(
          create: (context) => getIt.get<PokemonBloc>(),
        ),
        BlocProvider<ItemBloc>(
          create: (context) => getIt.get<ItemBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => getIt.get<SettingsBloc>(),
        ),
        BlocProvider<GiveAwayBloc>(
          create: (context) => getIt.get<GiveAwayBloc>(),
        ),
        Provider(create: (context) => HomeProvider(
            getCatGiveAwaysUsecase: getIt.get<GetCatGiveAwaysUsecase>(),
            getGiveAwaysUsecase: getIt.get<GetGiveAwayUseCase>()
        )),
        BlocProvider<ProductCatBloc>(
          create: (context) => getIt.get<ProductCatBloc>(),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => getIt.get<ProductBloc>(),
        ),
        BlocProvider<RegisterBloc>(  create: (context) => getIt.get<RegisterBloc>(),),
        BlocProvider<UserBloc>(  create: (context) => getIt.get<UserBloc>(),),
        BlocProvider<CardBloc>(  create: (context) => getIt.get<CardBloc>(),),
        BlocProvider<CommandeBloc>(  create: (context) => getIt.get<CommandeBloc>(),)
        

      ],
      child: child,
    );
  }
}
