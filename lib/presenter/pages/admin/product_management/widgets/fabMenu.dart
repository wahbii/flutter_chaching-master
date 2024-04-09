
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/utils/extensions/animation.dart';

import '../../../../modals/generation_modal.dart';
import '../../../../modals/search_modal.dart';
import '../../../../widgets/animated_overlay.dart';
import '../../../../widgets/fab.dart';
import 'dialog_edit_cat.dart';

class FabMenu extends StatefulWidget {
   FabMenu({required this.onSearch ,required this.onFinish});
 final  Function(String ? value) onSearch;
   final  Function() onFinish;

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu>
    with SingleTickerProviderStateMixin {
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
          items: [
            FabItemData(
             'Log Out' ,

                   Icons.logout
                  ,
              onPress: () {

                setState(() {
                  _toggleFabMenu();
                });
              },
            ),
            FabItemData(
              'ADD Product',
              Icons.add_box,
              onPress: () => onPress(),
            ),
            FabItemData(
              'ADD Category',
              Icons.category,
              onPress: ()  {
                showDialog(context: context,
                    builder: (BuildContext context){
                      return  DialogEditCatProduct(onsubmit: () {
                        widget.onFinish.call();                       },
                        productCat: null,
                      );
                    });
                setState(() {
                  _toggleFabMenu();
                });

              },
            ),
            FabItemData(
              'Search',
              Icons.search,
              onPress: () {
                _toggleFabMenu();
                _showSearchModal(
                  widget.onSearch
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
