
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/presenter/pages/cart/cart_screen.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../utils/size.dart';
import '../../../themes/colors.dart';
import '../../../widgets/modal.dart';

class ContactModalDialog extends StatefulWidget {

  final Function() onSucess;

  ContactModalDialog(
      {required this.onSucess,
      });

  @override
  State<StatefulWidget> createState() {
    return _ContactModalDialogState();
  }
}

class _ContactModalDialogState extends State<ContactModalDialog> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController thirdController = TextEditingController();
  final TextEditingController fourthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                        AppLocalizations.of(context)?.contact_us ??"",
                        style: context.typographies.bodyLarge,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: firstController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)?.fullname ??""),
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return AppLocalizations.of(context)?.fullname_err ??"";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: fourthController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)?.email ??""),
                        validator: (value) {
                          if (value?.isEmpty == true) {
                            return AppLocalizations.of(context)?.email_err ??"";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: secondController,
                        decoration:
                        InputDecoration(labelText: AppLocalizations.of(context)?.object??""),
                        validator: (value) {
                          if (value?.length == 0) {
                            return AppLocalizations.of(context)?.object_err;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: thirdController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)?.message ??""),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value?.length == 0) {
                            return AppLocalizations.of(context)?.message_err;
                          }
                          return null;
                        },
                      ),

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

                              if (_formKey.currentState?.validate() == true) {
                                setState(() {
                                  showLoader = true;
                                });
                                contactsendEmail(fourthController.text, firstController.text, secondController.text, thirdController.text,(){
                                      Navigator.of(context).pop();
                                });

                              }
                            },
                            child: Text(AppLocalizations.of(context)?.send ??""),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}
