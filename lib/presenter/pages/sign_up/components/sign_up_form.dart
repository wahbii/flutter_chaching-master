import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/entities/user_data.dart';
import 'package:pokedex/data/states/providers/user_bloc.dart';
import 'package:pokedex/presenter/navigation/navigation.dart';
import 'package:pokedex/utils/size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/states/providers/auth_bloc.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/enums.dart';
import '../../sign_in/components/custom_surfix_icon.dart';
import '../../sign_in/components/form_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.from});

  final String from;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  RegisterBloc get register => context.read<RegisterBloc>();

  UserBloc get userbloc => context.read<UserBloc>();

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  bool remember = false;
  final List<String?> errors = [];
  var showLoader = false;
  late SharedPreferences prefs;

  Future<void> _initAsyncState() async {
    prefs = await SharedPreferences.getInstance();
    // Any other asynchronous initialization can be added here
  }
  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAsyncState();

  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoadingState) {
                setState(() {
                  showLoader = true;
                });
              } else if (state is RegisterWithEmailState) {
                print("data : ${state.data}");
                userbloc.add(AddUserEvent(
                    user: UserData(
                        id: state.data.user!.uid,
                        isAdmin: false,
                        email: email!!,
                        password: password!)));
              } else if (state is RegisterErrorState) {
                setState(() {
                  showLoader = false;
                });
                addError(error: state.error.toString());
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) async {
              if (state is AddUserLoadingState) {
              } else if (state is AddUserState) {
                setState(() {
                  showLoader = false;
                });
               /* if (widget.from == FromScreen.SPLASH.text) {
                  await context.router.replaceAll([const HomeRoute()]);
                } else {
                  context.router.popForced();

                }*/
                prefs.setString("id", FirebaseAuth.instance.currentUser?.uid ??"");
                prefs.setBool("isAdmin", false);
                await context.router.replaceAll([const MenuHomeRoute()]);

              } else if (state is AddUserErrorState) {
                setState(() {
                  showLoader = false;
                });
                addError(error: state.error.toString());
              }
            },
          ),
        ],
        child: Stack(
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (newValue) => email = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: kEmailNullError);
                        } else if (emailValidatorRegExp.hasMatch(value)) {
                          removeError(error: kInvalidEmailError);
                        }
                        return;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kEmailNullError);
                          return "";
                        } else if (!emailValidatorRegExp.hasMatch(value)) {
                          addError(error: kInvalidEmailError);
                          return "";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        labelText: AppLocalizations.of(context)?.email,
                        hintText: AppLocalizations.of(context)?.sign_email_hint,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon:
                            CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      onSaved: (newValue) => password = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: kPassNullError);
                        } else if (value.length >= 8) {
                          removeError(error: kShortPassError);
                        }
                        password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kPassNullError);
                          return "";
                        } else if (value.length < 8) {
                          addError(error: kShortPassError);
                          return "";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        labelText: AppLocalizations.of(context)?.sign_in_pass,
                        hintText: AppLocalizations.of(context)?.pass_hint,
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon:
                            CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      onSaved: (newValue) => conform_password = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: kPassNullError);
                        } else if (value.isNotEmpty &&
                            password == conform_password) {
                          removeError(error: kMatchPassError);
                        }
                        conform_password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: kPassNullError);
                          return "";
                        } else if ((password != value)) {
                          addError(error: kMatchPassError);
                          return "";
                        }
                        return null;
                      },
                      decoration:  InputDecoration(
                        labelText: AppLocalizations.of(context)?.pass_confirm,
                        hintText: AppLocalizations.of(context)?.pass_confirm_hint,
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon:
                            CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                      ),
                    ),
                    FormError(errors: errors),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // if all are valid then go to success screen
                          // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                          register.add(RegisterWithEmailEvent(
                              userAuth: UserAuth(
                                  email: email!, password: password!)));
                        }
                      },
                      child:  Text(AppLocalizations.of(context)?.btn_continue??""),
                    ),
                  ],
                ),
              ),
            ),
            showLoader
                ? Center(child: CircularProgressIndicator())
                : Container()
          ],
        ));
  }
}

class CompleteProfileScreen {}
