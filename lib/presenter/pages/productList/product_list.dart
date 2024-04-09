import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokedex/data/entities/giveaway.dart';
import 'package:pokedex/data/states/pokemon/pokemon_selector.dart';
import 'package:pokedex/data/states/providers/cardManagment/card_bloc.dart';
import 'package:pokedex/data/states/providers/giveAwayBloc.dart';
import 'package:pokedex/data/states/providers/product_cat_bloc.dart';
import 'package:pokedex/presenter/modals/generation_modal.dart';
import 'package:pokedex/presenter/modals/search_modal.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/animated_overlay.dart';
import 'package:pokedex/presenter/widgets/dialog.dart';
import 'package:pokedex/presenter/widgets/fab.dart';
import 'package:pokedex/presenter/widgets/pokemon_refresh_control.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/extensions/animation.dart';

import '../../../data/entities/product.dart';
import '../../../data/states/providers/product_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app.dart';

part 'sections/fab_menu.dart';

part 'sections/product_grid.dart';

@RoutePage()
class ProductListPage extends StatefulWidget {
  final String idGiveAway;

  const ProductListPage({
    @PathParam('id') required this.idGiveAway,
  });

  @override
  State<StatefulWidget> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.products ?? "",style: context.typographies.body.withColor(AppColors.black),),
        leading: null,
        
      ),
      body: ProductGrid(
        idTombola: widget.idGiveAway,
      ),
    );
  }
}
