import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokedex/data/entities/user_auth.dart';
import 'package:pokedex/data/usecases/user/update_user_usecase.dart';
import 'package:pokedex/presenter/pages/sign_in/components/reset_password.dart';
import 'package:pokedex/presenter/pages/sign_in/components/socal_card.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/entities/user_data.dart';
import '../../../../data/states/providers/auth_bloc.dart';
import '../../../../data/states/providers/user_bloc.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/enums.dart';
import '../../../app.dart';
import '../../../navigation/navigation.dart';
import 'custom_surfix_icon.dart';
import 'form_error.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignForm extends StatefulWidget {
  final String from;

  const SignForm({super.key, required this.from});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool? remember = true;
  final List<String?> errors = [];

  @override
  void initState() {
    super.initState();
    _initAsyncState();
  }

  late SharedPreferences prefs;

  Future<void> _initAsyncState() async {
    prefs = await SharedPreferences.getInstance();
    // Check if email and password controllers are not null before setting their text
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showLoader = false;
      });
    });
    if (email != null && password != null) {
      email.text = prefs.getString("email") ?? "";
      password.text = prefs.getString("password") ?? "";
      remember = prefs.getBool("remember")??false;

    }



    // Any other asynchronous initialization can be added here
  }


  RegisterBloc get registerbloc => context.read<RegisterBloc>();

  UserBloc get userbloc => context.read<UserBloc>();
  bool showLoader = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
  Widget build(BuildContext context) {

    return MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterLoadingState) {
                setState(() {
                  showLoader = true;
                });
              } else if (state is LoginState) {
                userbloc.add(LoadUsersEvent());
              } else if (state is RegisterErrorState) {
                setState(() {
                  showLoader = false;
                });
                addError(error:  AppLocalizations.of(context)?.sign_in_err ??"");
              }
            },
          ),
          BlocListener<UserBloc, UserState>(listener: (context, state) async {
            if (state is AddUserLoadingState) {
              setState(() {
                showLoader = true;
              });
            } else if (state is LoadUsersState) {
              var user = state.userdata
                  .where((element) => element.email == email.text)
                  .first;
              print(user);
              if (user != null) {
                if (user.password != password) {
                  userbloc.add(UpdateUserEvent(
                      user: UserUpdated(
                          userData: user,
                          password: password.text,
                          email: email.text,
                          isAdmin: null),
                      action: ApiActions.UPDATE));
                }
                prefs.setString("id", user.id);
                prefs.setBool("isAdmin", user.isAdmin);
                if (user.isAdmin) {
                  PokedexApp.of(context)?.changeLang(Locale("eng"));
                  await context.router.replaceAll([const MainAdminRoute()]);
                } else {
                  if (widget.from == FromScreen.SPLASH.text) {
                    await context.router.replaceAll([const MenuHomeRoute()]);
                  } else {
                    //  context.router.popUntilRouteWithPath("/MenuHome");
                    await context.router.replaceAll([const MenuHomeRoute()]);
                  }
                }
              }

              //userbloc.add(LoadUsersEvent());
            } else if (state is AddUserState) {
              setState(() {
                showLoader = false;
              });
              await context.router.replaceAll([const MenuHomeRoute()]);
            } else if (state is RegisterErrorState) {
              setState(() {
                showLoader = false;
              });
              addError(error: state.error.toString());
            }
          })
        ],
        child:  Stack(children: [
          Container(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
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
                    labelText: AppLocalizations.of(context)?.email??"",
                    hintText: AppLocalizations.of(context)?.sign_email_hint??"",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      removeError(error: kPassNullError);
                    } else if (value.length >= 8) {
                      removeError(error: kShortPassError);
                    }
                    return;
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
                    labelText:AppLocalizations.of(context)?.sign_in_pass ??"",
                    hintText: AppLocalizations.of(context)?.pass_hint ??"",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon:
                        CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [

                    Checkbox(
                      value: remember,
                      activeColor: AppColors.paarl,
                      onChanged: (value) {
                        setState(() {
                          remember = value;
                        });
                      },
                    ),
                     Text(AppLocalizations.of(context)?.rembre ??""),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ResetPasswordDialog())
                      },
                      child: Text(
                        AppLocalizations.of(context)?.forgotpw ??"",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
                FormError(errors: errors),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (remember == true) {
                        prefs.setString("email", email.text ?? "");
                        prefs.setString("password", password.text ?? "");
                        prefs.setBool("remember", true);
                      }else{
                        prefs.remove("remember");
                        prefs.remove("email");
                        prefs.remove("password");
                      }
                      // if all are valid then go to success screen
                      // KeyboardUtil.hideKeyboard(context);

                      registerbloc.add(LoginEvent(
                          userAuth: UserAuth(
                              email: email.text ?? "", password: password.text ?? "")));
                    }
                  },
                  child:  Text(AppLocalizations.of(context)?.btn_continue ??""),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/images/google-icon.svg",
                      press: () {
                        _signInWithGoogle();
                      },
                    ),
                  ],
                ),
              ],
            ),
          )),
          Visibility(
            visible: showLoader,
            child: const Center(child: CircularProgressIndicator()),
          )
        ]));
  }

  Future<UserCredential?> _signInWithGoogle() async {
    setState(() {
      showLoader = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user = await _auth.signInWithCredential(credential);
      print("error : ${user.user?.email} ${user.user?.uid} ");
      prefs.setString("id", user.user?.uid ?? "");
      prefs.setBool("isAdmin", false);
      userbloc.add(AddUserEvent(
          user: UserData(
              id: user.user?.uid ?? "",
              isAdmin: false,
              email: user.user?.email ?? "",
              password: "")));
      return user;
    } catch (e) {
      print("error : ${e.toString()}");
      return null;
    }
  }
}
