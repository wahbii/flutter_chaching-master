import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/admin/give_away_managment/widget/dialog_edit_giveaway.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/extensions/animation.dart';

import '../../../../../data/entities/productcat.dart';
import '../../../../modals/generation_modal.dart';
import '../../../../modals/search_modal.dart';
import '../../../../widgets/animated_overlay.dart';
import '../../../../widgets/dialog.dart';
import '../../../../widgets/fab.dart';
import '../../product_management/widgets/dialog_edit.dart';

class FabMenu extends StatefulWidget {
  FabMenu(
      {required this.onSearch,
      required this.onSubmit,
      required this.destination,
      });

  final Function(String? value) onSearch;

  final Function() onSubmit;
  final AdminScreen destination;


  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  bool _isFabMenuVisible = false;

  @override
  void initState() {
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _fabAnimation = _fabController.curvedTweenAnimation(
      begin: 0.0,
      end: 1.0,
    );

    super.initState();
  }

  @override
  void dispose() {
    _fabController.dispose();

    super.dispose();
  }

  void _toggleFabMenu() {
    _isFabMenuVisible = !_isFabMenuVisible;

    if (_isFabMenuVisible) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void _showSearchModal(Function(String? value) search) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchBottomModal(
        onSearch: search,
      ),
    );
  }

  void _showGenerationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const GenerationModal(),
    );
  }

  void onPress([Function? callback]) {
    _toggleFabMenu();

    callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return AnimatedOverlay(
      animation: _fabAnimation,
      color: Colors.black,
      onPress: _toggleFabMenu,
      child: Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 26, bottom: 26 + safeAreaBottom),
        child: ExpandedAnimationFab(
          animation: _fabAnimation,
          onPress: _toggleFabMenu,
          items: getMenu(),
        ),
      ),
    );
  }

  List<FabItemData> getMenu() {
    return [

      FabItemData(
        'Log Out',
        Icons.logout,
        onPress: () {
          FirebaseAuth.instance.currentUser != null
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      message: "Are you sure to logout",
                      onComfirme: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          setState(() {
                            context.router.replaceAll([
                              SignInRoute(
                                  from: FromScreen.SPLASH.text,
                                  idgiveAway: null)
                            ]);
                          });
                        });
                      },
                      onCancel: () {
                        context.router.popForced();
                      },
                    );
                  },
                )
              : print("");
          setState(() {
            _toggleFabMenu();
          });
        },
      ),
      if (widget.destination == AdminScreen.MNGIVEAWAY)
        FabItemData(
          'Add Give Away',
          Icons.add_box,
          onPress: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => EditGiveAwayDialog(
                      product: null,
                      onsubmit: () {
                        widget.onSubmit.call();
                      },
                    ));
            setState(() {
              _toggleFabMenu();
            });
          },
        ),
      if (widget.destination == AdminScreen.MNPRODUCT)
        FabItemData('Add Product', Icons.category, onPress: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => RoundedDialog(
                  product: null,
                  onSubmit: () {
                    //productCatBloc.add(LoadProductCatEvent());
                    widget.onSubmit.call();
                    _toggleFabMenu();
                  }));
        }),
      if (widget.destination == AdminScreen.MNCOMMANDE)
        FabItemData('Search for Commande by ref', Icons.search, onPress: () {
          _toggleFabMenu();
          _showSearchModal((value) => widget.onSearch.call(value));
        }),
    ];
  }
}
