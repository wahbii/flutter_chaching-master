import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:pokedex/utils/size.dart';

import '../../../widgets/modal.dart';

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  void resetPassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Un e-mail de réinitialisation a été envoyé.'),
          ),
        );
        Navigator.pop(context); // Ferme la boîte de dialogue après envoi
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Modal(
        child: Padding(
      padding: EdgeInsets.all(20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: getFullHeight(context)*0.25,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Reset Password",style: context.typographies.bodyLarge,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir une adresse e-mail';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez saisir une adresse e-mail valide';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size.fromWidth(getFullWigth(context)*0.9)),
                  ),
                onPressed: () => resetPassword(context),
                child: Text('Réinitialiser'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
