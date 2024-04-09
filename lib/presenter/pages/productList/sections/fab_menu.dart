part of '../product_list.dart';

class _FabMenu extends StatefulWidget {
  _FabMenu({required this.onSearch,required this.idGiveAway});

  final String idGiveAway ;
  final Function(String? value) onSearch;

  @override
  State<_FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<_FabMenu>
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
              FirebaseAuth.instance.currentUser != null ? 'Log Out' : AppLocalizations.of(context)?.login??"",
              FirebaseAuth.instance.currentUser != null
                  ? Icons.logout
                  : Icons.login,
              onPress: () {
                setState(() {
                  _toggleFabMenu();
                });

                FirebaseAuth.instance.currentUser != null
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            message: "Are you sure to logout",
                            onComfirme: () {
                              FirebaseAuth.instance.signOut().then((value) {
                                setState(() {
                                  context.router.popForced();

                                });
                              });
                            },
                            onCancel: () {
                              context.router.popForced();
                            },
                          );
                        },
                      )
                    : context.router
                        .push(SignInRoute(from: FromScreen.OTHER.text,idgiveAway: widget.idGiveAway));
              },
            ),
            FabItemData(
              'Settings',
              Icons.filter_vintage,
              onPress: () {
                context.router.push(const SettingRoute());
              },
            ),
            FabItemData(
              'Your Card',
              Icons.shopping_cart,
              onPress: () {
                FirebaseAuth.instance.currentUser != null
                    ? context.router.push(const CartRoute())
                    : context.router
                        .push(SignInRoute(from: FromScreen.OTHER.text,idgiveAway: widget.idGiveAway));
                setState(() {
                  _toggleFabMenu();
                });
              },
            ),
            FabItemData(
              'Your Commande',
              Icons.auto_awesome_mosaic,
              onPress: () {
                FirebaseAuth.instance.currentUser != null
                    ? context.router.push(const CommadesRoute())
                    : context.router
                    .push(SignInRoute(from: FromScreen.OTHER.text,idgiveAway: widget.idGiveAway));
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
                _showSearchModal(widget.onSearch);
              },
            ),
          ],
        ),
      ),
    );
  }
}
