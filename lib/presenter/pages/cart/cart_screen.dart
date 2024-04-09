import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pokedex/data/entities/giveaway.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/states/providers/cardManagment/card_bloc.dart';
import 'package:pokedex/data/states/providers/commande/commande_bloc.dart';
import 'package:pokedex/data/usecases/commande/commande_use_case.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/presenter/pages/cart/components/you_can_pay.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/enums.dart';
import 'package:pokedex/utils/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/entities/card_item.dart';
import '../../../data/entities/commande.dart';
import '../../../data/states/providers/giveAwayBloc.dart';
import '../../widgets/login_indicator.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen();

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CardBloc get cardBloc => context.read<CardBloc>();
  List<CardItem> selectedItem = [];

  GiveAwayBloc get giveAway => context.read<GiveAwayBloc>();

  CommandeBloc get commandeBloc => context.read<CommandeBloc>();

  List<CardItem> cards = [];
  bool showLoader = false;
  String messgge = "";

  double total = 0.0;

  late SharedPreferences prefs;
  late ScrollController _controller;

  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  void initializeState() async {
    prefs = await SharedPreferences.getInstance();
    cardBloc.add(LoadCardEvent((prefs.getString("id") ?? "")));
  }

  @override
  Widget build(BuildContext context) {
    _controller = ScrollController();

    return Scaffold(
      appBar:FirebaseAuth.instance.currentUser == null ?null: AppBar(
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)?.panier ??"",
              style: context.typographies.bodyLarge.withColor(AppColors.black),
            ),
            Text(
              "${cards.length} ${AppLocalizations.of(context)?.items}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: FirebaseAuth.instance.currentUser==null ?

      LoginIndicatorWidget()


          :  MultiBlocListener(
          listeners: [
            BlocListener<CardBloc, CardState>(
              listener: (context, state) {
                if (state is CardLoadingState) {
                  setState(() {
                    showLoader = true;
                  });
                } else if (state is CardFeatchState) {
                  if (state.data.isEmpty) {
                    messgge = AppLocalizations.of(context)?.card_emty_msg ??"";
                  } else {
                    messgge = "";
                  }
                  setState(() {
                    showLoader = false;
                    cards = state.data;

                    groupByTobola(cards).forEach((element) {
                      isSelected.add(false);
                      total = 0.0;
                    });
                  });

                  // Display data
                } else if (state is AddToCardState) {
                  cardBloc.add(LoadCardEvent((prefs.getString("id") ?? "")));

                  // Display data
                } else if (state is CardErrorState) {
                  setState(() {
                    showLoader = false;
                  });
                  print("error :${state.error}");
                }
              },
            ),
            BlocListener<CommandeBloc, CommandeState>(
              listener: (context, state) {
                if (state is CommandeLoadingState) {
                  setState(() {
                    showLoader = true;
                  });
                } else if (state is CrudCommandeState) {
                  // cardBloc.add(LoadCardEvent((prefs.getString("id") ?? "")));
                  context.router.push(const CommadesRoute());
                  // Display data
                } else if (state is CommandeErrorState) {
                  setState(() {
                    showLoader = false;
                  });
                  print("error :${state.error}");
                }
              },
            )
          ],
          child: Stack(
            children: [
              Visibility(
                visible: messgge.isNotEmpty,
                  child: Center(
                child: Text(
                  messgge,
                  style:
                      context.typographies.body.withColor(AppColors.paarl_lite).withWeight(FontWeight.w600),
                ),
              )),
              Visibility(
                  visible: messgge.isEmpty,
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: groupByTobola(cards).length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 4),
                        child: _buildItem(
                            giveAway.mainData
                                .where((element) =>
                                    element.id ==
                                    groupByTobola(cards)[index].first)
                                .first,
                            groupByTobola(cards)[index].second,
                            index),
                      );
                    },
                  )),
              Visibility(
                visible: showLoader,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          )),
      bottomNavigationBar: Visibility(
          visible: total > 0,
          child: CheckoutCard(
            total: total,
            onPaymentDone: (usermodel) async{
              var cmd= Commande(
                  id: "",
                  ref: generateRandomString(10),
                  items: selectedItem,
                  name: usermodel.name,
                  phone: usermodel.phone,
                  email: usermodel.email,
                  adress: usermodel.address,
                  status: 0,
                  userId: prefs.getString("id") ?? "");
             sendEmail(usermodel,cmd);
              commandeBloc.add(CrudCammandeEvent(
                  commandeArgs: CommandeArgs(
                actions: ApiActions.ADD,
                commande: cmd,
                status: null,
                listGiveAwaY: giveAway.mainData,
              )));
            },
          )),
    );
  }

  Widget _buildItem(GiveAway giveAway, List<CardItem> data, int index) {
    return InkWell(
        onTap: () {
          isSelected[index] = !isSelected[index];
          var price = 0.0;
          data.forEach((element) {
            price = element.price * element.quantite + price;
          });
          if (isSelected[index]) {
            setState(() {
              total = total + price;
            });
            data.forEach((element) {
              selectedItem.add(element);
            });
          } else {
            setState(() {
              total = total - price;
            });
            data.forEach((element) {
              selectedItem.remove(element);
            });
          }
        },
        child: Card(
          elevation: 6,
          shape: isSelected[index]
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  // Optional: Adds rounded corners
                  side: BorderSide(
                    color: AppColors.paarl, // Border color
                    width: 3.0, // Border width
                  ),
                )
              : null,
          child: Column(
            children: [getHeader(giveAway), getProduct(data)],
          ),
        ));
  }

  Widget getHeader(GiveAway giveAway) {
    return Container(
      height: getFullHeight(context) * 0.06,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: AppColors.paarl_lite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 20,
            // Adjust the radius according to your preference
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Icon(
                Icons.card_giftcard,
                color: AppColors.paarl_lite,
                size: 30,
              ),
            ),
          ),
          Text(
            giveAway.titleEng,
            style: context.typographies.body
                .withColor(AppColors.black)
                .withWeight(FontWeight.w600),
          ),
          InkWell(
            child: Icon(
              Icons.expand_circle_down,
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget getProduct(List<CardItem> data) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return CartCard(
          showIcon: true,
          cart: data[index],
          onMinus: () {
            var q = data[index].quantite - 1;
            if (q >= 0) {
              var card = data[index];
              card.quantite = q;
              cardBloc.add(ModifyQtProdutEvent(modifyItemCard: card));
            }
          },
          onPlus: () {
            var q = data[index].quantite + 1;
            var card = data[index];
            card.quantite = q;
            cardBloc.add(ModifyQtProdutEvent(modifyItemCard: card));
          },
        );
      },
    );
  }
}

List<Pair<String, List<CardItem>>> groupByTobola(List<CardItem> data) {
  Map<String, List<CardItem>> groupedMap = {};

  // Grouping by idTobola
  for (var item in data) {
    if (!groupedMap.containsKey(item.idTobola)) {
      groupedMap[item.idTobola] = [];
    }
    groupedMap[item.idTobola]?.add(item);
  }

  // Converting to List<Pair<String, List<CardItem>>>
  List<Pair<String, List<CardItem>>> result = [];
  groupedMap.forEach((key, value) {
    result.add(Pair<String, List<CardItem>>(key, value));
  });

  return result;
}

class Pair<K, V> {
  final K first;
  final V second;

  Pair(this.first, this.second);
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
void sendEmail(UserModel userModel,Commande commande) async {
  String username = 'noreplychaching@gmail.com'; // Your email address
  String password = 'xsnm hybm bljm vgcp'; // Your email password
  double price = 0 ;
  commande.items.forEach((element) {
    price = price + element.price * element.quantite ;
  });
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Chaching')
    ..recipients.add(userModel.email) // Recipient's email address
    ..subject = "Order Confirmation" // Subject of the email
    ..text = "Dear Customer,\nThank you for shopping with us! We're excited to confirm that your order has been successfully processed.\nBelow are the details of your purchase:\n\nOrder Number: ${commande.ref}\nTotal amount: ${price} dhs\nGood luck!!";


  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ${sendReport}');
  } catch (e) {
    print('Error sending email: $e');
  }
}

void contactsendEmail(String email , String name ,String object ,String body, Function() onSucess) async {
  String username = 'noreplychaching@gmail.com'; // Your email address
  String password = 'xsnm hybm bljm vgcp'; // Your email password

  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Chaching')
    ..recipients.add("app.chaching@gmail.com") // Recipient's email address
    ..subject = object
    ..text = "sender: $email  name: $name\n$body";

  try {
    final sendReport = await send(message, smtpServer);
    onSucess.call();
    print('Message sent: ${sendReport}');
  } catch (e) {
    print('Error sending email: $e');
  }
}