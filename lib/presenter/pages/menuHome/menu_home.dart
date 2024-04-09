


import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/presenter/pages/cart/cart_screen.dart';
import 'package:pokedex/presenter/pages/home/home.dart';
import 'package:pokedex/presenter/pages/participation/participation_screen.dart';
import 'package:pokedex/presenter/pages/settings/setting_page.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../commandes/commandes_page.dart';

@RoutePage()
class MenuHomeScreen  extends StatefulWidget {



  const MenuHomeScreen();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MenuHomeState();
  }

}

class _MenuHomeState extends State<MenuHomeScreen>{

  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;
  /// widget list
  late List<Widget> bottomBarPages ;
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomBarPages = [
      HomePage(),
      CartScreen(),
      CommadesScreen(),
      ParticipationScreen(),
      SettingScreen(),

    ];
  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: PageView(
       controller: _pageController,
       physics: const NeverScrollableScrollPhysics(),
       children: List.generate(
           bottomBarPages.length, (index) => bottomBarPages[index]),
     ),
     extendBody: true,
     bottomNavigationBar: (bottomBarPages.length <= maxCount)
         ? AnimatedNotchBottomBar(
       notchBottomBarController: _controller,
       color:AppColors.paarl_lite,
       showLabel: true,
       itemLabelStyle: const TextStyle(
           color: Colors.white,
           fontSize: 10.0
       ),
       shadowElevation: 5,
       kBottomRadius: 28.0,
       // notchShader: const SweepGradient(
       //   startAngle: 0,
       //   endAngle: pi / 2,
       //   colors: [Colors.red, Colors.green, Colors.orange],
       //   tileMode: TileMode.mirror,
       // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
       notchColor: AppColors.paarl,

       removeMargins: false,
       bottomBarWidth: 500,
       showShadow: false,
       durationInMilliSeconds: 300,
       elevation: 1,
       bottomBarItems:  [
         BottomBarItem(
           inActiveItem: const Icon(
             Icons.home_filled,
             color: AppColors.white,
           ),
           activeItem: const Icon(
             Icons.home_filled,
             color: AppColors.white,
           ),
           itemLabel: AppLocalizations.of(context)?.giveaways??"",
         ),
         BottomBarItem(
           inActiveItem: const Icon(
             Icons.shopping_cart,
             color: AppColors.white,
           ),
           activeItem:const Icon(
             Icons.shopping_cart,
             color: AppColors.white,
           ),
           itemLabel: AppLocalizations.of(context)?.card??"",
         ),
         BottomBarItem(
           inActiveItem: const Icon(
             Icons.book,
             color: AppColors.white,
           ),
           activeItem: const Icon(
             Icons.book,
             color: AppColors.white,
           ),
           itemLabel: AppLocalizations.of(context)?.order??"",
         ),
          BottomBarItem(
           inActiveItem: const Icon(
             Icons.numbers,
             color: AppColors.white,
           ),
           activeItem: const Icon(
             Icons.numbers,
             color: AppColors.white,
           ),
           itemLabel: AppLocalizations.of(context)?.token??"",
         ),
         BottomBarItem(
           inActiveItem: const Icon(
             Icons.settings,
             color: AppColors.white,
           ),
           activeItem: const Icon(
             Icons.settings,
             color: AppColors.white,
           ),
           itemLabel: AppLocalizations.of(context)?.settings??"",
         ),

       ],
       onTap: (index) {
         /// perform action on tab change and to update pages you can update pages without pages
         log('current selected index $index');
         _pageController.jumpToPage(index);
       },
       kIconSize: 24.0,
     )
         : null,
   );
  }

}