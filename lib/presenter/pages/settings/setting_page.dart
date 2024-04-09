import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokedex/presenter/app.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/settings/widget/bottom_sheet_contact.dart';
import 'package:pokedex/presenter/pages/settings/widget/rotate_icon.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/presenter/widgets/scaffold.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/size.dart';
import '../../themes/colors.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<SettingScreen> {
  String _selectedLanguage = "";
  var expended = false;

  List<bool> selctedLanguges = [false, false, false];

  late SharedPreferences prefs;

  Future<void> _initAsyncState() async {
    prefs = await SharedPreferences.getInstance();
    // Any other asynchronous initialization can be added here
    var language = prefs.getString("language");
    print("lng : $language");
    if (language == null) {
      _selectedLanguage = AppLocalizations.of(context)?.english ?? "";
      selctedLanguges[0]=true ;
    } else {
      if (language == "eng") {
        _selectedLanguage = AppLocalizations.of(context)?.english ?? "";
      }
      if (language == "ar") {
        _selectedLanguage = AppLocalizations.of(context)?.arabe ?? "";
      }
      if (language == "fr") {
        _selectedLanguage = AppLocalizations.of(context)?.french ?? "";
      }
      selctedLanguges[languges(context).indexOf(_selectedLanguage)]= true ;
      print("lng $selctedLanguges");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAsyncState();
  }

  List<String> languges(BuildContext) {
    return [
      AppLocalizations.of(context)?.english ?? "",
      AppLocalizations.of(context)?.french ?? "",
      AppLocalizations.of(context)?.arabe ?? ""
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PokeballScaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.settings ?? "",
          style: context.typographies.body
              .withColor(AppColors.black)
              .withWeight(FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LanguageItemMunu(),
            FirebaseAuth.instance?.currentUser != null
                ? getHeader(
                    AppLocalizations?.of(context)?.log_out ?? "", Icons.logout,
                    () {
                    FirebaseAuth.instance.signOut().then((value) =>
                        context.router.replaceAll([
                          SignInRoute(
                              from: FromScreen.OTHER.text, idgiveAway: "")
                        ]));
                  }, false)
                : getHeader(
                    AppLocalizations?.of(context)?.login ?? "", Icons.login,
                    () {
                    context.router.replaceAll([
                      SignInRoute(from: FromScreen.OTHER.text, idgiveAway: "")
                    ]);
                  }, false),
            getHeader(
                AppLocalizations?.of(context)?.contact_us ?? "", Icons.mail,
                () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ContactModalDialog(
                  onSucess: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }, false)
          ],
        ),
      ),
    );
  }

  Widget getHeader(
      String title, IconData icon, Function onClick, bool isDropDawn) {
    return Container(
      height: getFullHeight(context) * 0.08,
      width: getFullWigth(context) * 0.9,
      margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: AppColors.paarl_lite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Icon(
                icon,
                color: AppColors.paarl_lite,
                size: 30,
              ),
            ),
          ),
          SizedBox(
              width: getFullWigth(context) * 0.6,
              child: Text(
                title,
                style: context.typographies.body
                    .withColor(AppColors.black)
                    .withWeight(FontWeight.w600),
              )),
          isDropDawn
              ? (!expended
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          expended = !expended;
                        });
                      },
                      child: Icon(
                        Icons.expand_circle_down_outlined,
                        color: AppColors.white,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          expended = !expended;
                        });
                      },
                      child: RotatedIcon(
                        icon: Icons.expand_circle_down_outlined,
                        angle: 180 * (3.141592653589793 / 180),
                        color: AppColors.white,
                      ),
                    ))
              : InkWell(
                  onTap: () {
                    onClick.call();
                  },
                  child: RotatedIcon(
                    icon: Icons.expand_circle_down_outlined,
                    angle: -90 * (3.141592653589793 / 180),
                    color: AppColors.white,
                  ),
                )
        ],
      ),
    );
  }

  //AppLocalizations.load(Locale('ar'));

  Widget getListLanguage(BuildContext context) {

    return Container(
      height: getFullHeight(context) * 0.07 * 3,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: languges(context).length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                setState(() {
                  selctedLanguges = List.generate(3, (index) => false);
                  selctedLanguges[index] = !selctedLanguges[index];
                  _selectedLanguage = selctedLanguges[index]
                      ? languges(context)[index]
                      : languges(context)[0];
                  if (!selctedLanguges[index]) selctedLanguges[0] = true;
                  index == 0
                      ? prefs.setString("language", "eng")
                      : (index == 1
                          ? prefs.setString("language", "fr")
                          : prefs.setString("language", "ar"));
                  index == 0
                      ? PokedexApp.of(context)?.changeLang(Locale("eng"))
                      : (index == 1
                          ?  PokedexApp.of(context)?.changeLang(Locale("fr"))
                          : PokedexApp.of(context)?.changeLang(Locale("ar")));
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: getFullHeight(context) * 0.07,
                width: getFullWigth(context) * 0.9,
                decoration: const BoxDecoration(
                  color: AppColors.lightGrey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        width: getFullWigth(context) * 0.6,
                        child: Text(
                          languges(context)[index],
                          style: context.typographies.body
                              .withColor(AppColors.black)
                              .withWeight(FontWeight.w600),
                        )),
                    Visibility(
                      visible: selctedLanguges[index],
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.lightGreen,
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  Widget LanguageItemMunu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getHeader(AppLocalizations.of(context)?.language ?? "", Icons.language,
            () {}, true),
        Visibility(
          visible: expended,
          child: getListLanguage(context),
        )
      ],
    );
  }
}
