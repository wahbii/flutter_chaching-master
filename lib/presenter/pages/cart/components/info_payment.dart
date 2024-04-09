import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pokedex/presenter/pages/cart/components/you_can_pay.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/size.dart';

import '../../../widgets/modal.dart';

class InformationPaymentBottomModal extends StatefulWidget {
  final double mantant;

  const InformationPaymentBottomModal(
      {required this.onValidate, required this.mantant});

  final Function(UserModel usermodel) onValidate;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _InformationPaymentBottomModal();
  }
}

class _InformationPaymentBottomModal
    extends State<InformationPaymentBottomModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool showLoader = false;

  Placemark? place;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = FirebaseAuth.instance.currentUser?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final safeAreaBottom = MediaQuery.paddingOf(context).bottom;

    return Modal(
        child: Stack(children: [
      Padding(
        padding: EdgeInsets.all(20)
            .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)?.payment_user_info_title ?? "",
                style: context.typographies.bodyLarge,
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                focusNode: FocusNode(),
                controller: nameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.fullname ??
                          "",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.fullname_err ?? "";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.email ?? "",

                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.email_err ?? "";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              SizedBox(height: 20),
              TextFormField(
                focusNode: FocusNode(),
                controller: adressController,
                decoration: InputDecoration(
                  labelText:AppLocalizations.of(context)?.adress ?? "",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Handle map icon click here
                      setState(() {
                        showLoader = true;
                      });
                      _getCurrentAddress(context);
                      // You can navigate to a map screen or perform any other action
                    },
                    child: Icon(Icons.map),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)?.adress_err ?? "";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              SizedBox(height: 20),
              TextFormField(
                focusNode: FocusNode(),
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.phone ?? "",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 10) {
                    return AppLocalizations.of(context)?.phone_err ?? "";
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: getFullWigth(context),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: getFullWigth(context) * 0.3,
                      child: Center(
                          child: Text(
                        "${widget.mantant} ${AppLocalizations.of(context)?.currency ?? ""}",
                        textAlign: TextAlign.center,
                        style: context.typographies.body
                            .withColor(AppColors.paarl)
                            .withWeight(FontWeight.bold),
                      )),
                    ),
                    InkWell(
                        onTap: () {
                          if (_formKey.currentState?.validate() == true) {
                            var user = UserModel(
                                uid: generateRandomString(10),
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                state: place?.subAdministrativeArea ?? "",
                                address:
                                    "${place?.street} ${place?.postalCode} ${place?.name}");
                            widget.onValidate.call(user);
                          }
                        },
                        child: Container(
                            height: 50,
                            width: getFullWigth(context) * 0.5,
                            decoration: BoxDecoration(
                              color: _formKey.currentState?.validate() == true
                                  ? AppColors.paarl
                                  : AppColors.paarl_lite,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              "${AppLocalizations.of(context)?.pay}",
                              style: context.typographies.body
                                  .withColor(Color(0xFFF5F6F9)),
                            ))))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      if (showLoader)
        Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
    ]));
  }

  Future<void> _getCurrentAddress(BuildContext context) async {
    try {
      // Request permission to access device location
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle case when location permission is denied
        print('Location permission denied');
        return;
      }

      // Get the current position of the device
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch the address using geocoding
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      place = placemarks[0];
      setState(() {
        adressController.text = "${place?.street} ${place?.postalCode}";
        showLoader = false;
      });

      // Display the address
    } catch (e) {
      print('Error getting current address: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error getting current address'),
      ));
    }
  }
}

String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
