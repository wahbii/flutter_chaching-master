import 'package:flutter/material.dart';
import 'package:pokedex/presenter/pages/cart/components/you_can_pay.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/size.dart';

import '../../../themes/colors.dart';
import '../../../widgets/modal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PaymentModalDialog extends StatefulWidget {
  final UserModel userModel;
  final Function() onSucess;
  final double amount;
  final Function() onFailure;

  PaymentModalDialog(
      {required this.userModel,
      required this.amount,
      required this.onSucess,
      required this.onFailure});

  @override
  State<StatefulWidget> createState() {
    return _PaymentModalDialogState();
  }
}

class _PaymentModalDialogState extends State<PaymentModalDialog> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController thirdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late YouCanPay youCanPay;

  bool showLoader = false;

  String messgError = "";

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Modal(
        child: Padding(
            padding: EdgeInsets.all(20)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${AppLocalizations.of(context)?.card_info_title}",
                        style: context.typographies.bodyLarge,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: firstController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "${AppLocalizations.of(context)?.card_num}"),
                        maxLength: 16,
                        validator: (value) {
                          if (value?.length != 16) {
                            return "${AppLocalizations.of(context)?.card_num_err}";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: secondController,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: "${AppLocalizations.of(context)?.ex_date}"),
                        maxLength: 4,
                        validator: (value) {
                          if (value?.length != 4) {
                            return '${AppLocalizations.of(context)?.ex_date_err}';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: thirdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: '${AppLocalizations.of(context)?.cvc}'),
                        maxLength: 3,
                        validator: (value) {
                          if (value?.length != 3) {
                            return '${AppLocalizations.of(context)?.cvc_err}';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                          width: getFullWigth(context) * 0.82,
                          child: Text(
                            "$messgError",
                            style: context.typographies.body
                                .withColor(AppColors.red),
                          )),
                      SizedBox(height: 20),
                      Container(
                          width: getFullWigth(context) * 0.9,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  _formKey.currentState?.validate() == true
                                      ? AppColors.paarl
                                      : AppColors.paarl_lite),
                            ),
                            onPressed: () {
                              // Handle form submission here
                              // Navigator.pop(context);
                               // Example four-digit number as a string
                              int fourDigits = int.parse(secondController.text); // Convert string to integer

                              int firstTwoDigits = fourDigits ~/ 100; // Integer division by 100 to get first two digits
                              int lastTwoDigits = fourDigits % 100;

                              if (_formKey.currentState?.validate() == true) {
                                setState(() {
                                  showLoader = true;
                                });
                                YouCanPay(onFailure: (error) {
                                  setState(() {
                                    messgError = error;
                                  });
                                }, onSuccess: () {
                                  widget.onSucess.call();
                                 // Navigator.of(context).pop();
                                }).makePayment(
                                    CardModel(
                                        creditCardNumber: firstController.text,
                                        cardHolderName: widget.userModel.name,
                                        cvv: thirdController.text,
                                        expireDate: "$firstTwoDigits/$lastTwoDigits"),
                                    widget.amount.toInt(),
                                    widget.userModel,
                                    context);
                              }
                            },
                            child: Text('${AppLocalizations.of(context)?.pay}'),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
