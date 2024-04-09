import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/entities/cat.giveaway.dart';
import 'package:pokedex/data/states/providers/homeprovider.dart';
import 'package:pokedex/data/states/settings/settings_bloc.dart';
import 'package:pokedex/data/states/settings/settings_event.dart';
import 'package:pokedex/data/states/settings/settings_selector.dart';
import 'package:pokedex/presenter/app.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/productList/product_list.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/themes/themes/themes.dark.dart';
import 'package:pokedex/presenter/themes/themes/themes.light.dart';
import 'package:pokedex/presenter/widgets/app_bar.dart';
import 'package:pokedex/presenter/widgets/button.dart';
import 'package:pokedex/presenter/widgets/input.dart';
import 'package:pokedex/presenter/widgets/keyboard.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/extensions/string.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../data/entities/giveaway.dart';
import '../../../data/states/providers/giveAwayBloc.dart';
import '../../../data/states/providers/giveAwayBloc.dart';
import '../../assets.gen.dart';
import '../onboarding/widget/rounded_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


part 'sections/header.dart';

part 'sections/news.dart';

part 'widgets/category_card.dart';

part 'widgets/news_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GiveAwayBloc get giveAwayBloc => context.read<GiveAwayBloc>();


  @override
  void initState() {
    super.initState();
    giveAwayBloc.add(LoadGiveAwayByIDEvent(null,null));

  }

  bool showLoader = true;

  List<GiveAway> filterData = [];
  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {



    return KeyboardDismisser(
        child: Scaffold(
      backgroundColor: context.colors.backgroundDark,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (_, innerBoxIsScrolled) => [
          AppExpandableSliverAppBar(
            backgroundColor: AppColors.paarl_lite,
            title:  Text(AppLocalizations.of(context)?.app_name??"",style: context.typographies.bodyLarge.withColor(Color.fromRGBO(0, 0, 0, 0))),
            background: _HeaderSection(
              height: MediaQuery.sizeOf(context).height * 0.35,
              onPressed: (id) {
                filterData = giveAwayBloc.mainData ;
                _scrollToBody();
                if (id == "0") {
                  giveAwayBloc.add(LoadGiveAwayByIDEvent(null,null));
                } else {
                  giveAwayBloc.add(LoadGiveAwayByIDEvent(id,filterData));
                }
              },
              onSearch: (String? search) {
                filterData = giveAwayBloc.mainData ;
                filterData.sort((a, b) => b.dateRest.toDate().compareTo(a.dateRest.toDate()));
                giveAwayBloc.add(LoadGiveAwayBySearch(search, filterData));
              },
            ),
          ),
        ],
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return MultiBlocListener(
            listeners: [
              BlocListener<GiveAwayBloc, GiveAwayState>(
                listener: (context, state) {
                  if (state is GiveAwayLoadingState) {
                  } else if (state is GiveAwayLoadedState) {
                    setState(() {
                      filterData = state.data ;
                      filterData.sort((a, b) => b.dateRest.toDate().compareTo(a.dateRest.toDate()));
                      showLoader = false;
                    });
                  } else if (state is GiveAwayErrorState) {
                    print("error : ${state.error}");
                    setState(() {
                      showLoader = false;
                    });
                  }
                },
              ),
            ],
            child: Stack(children: [
              _NewsSection(
                data: filterData,
              ),
              Visibility(
                  visible: showLoader,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ))
            ]),
          );
        }),

        //     Center(
        //   child: _widgetOptions.elementAt(_selectedIndex),
        // ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.card_giftcard),
        //       label: 'Gifts',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_cart),
        //       label: 'Panier',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: AppColors.paarl_lite,
        //   onTap: _onItemTapped,
        // ),)
      ),
    ));
  }
  void _scrollToBody() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
