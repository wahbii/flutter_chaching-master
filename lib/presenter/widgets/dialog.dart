import 'package:flutter/material.dart';
import 'package:pokedex/presenter/themes/extensions.dart';

import '../../utils/size.dart';
import '../pages/onboarding/widget/rounded_button.dart';
import '../themes/colors.dart';

class CustomDialog extends StatelessWidget {
  final String message;

  final Function() onComfirme;
  final Function() onCancel;

  CustomDialog({required this.message, required this.onComfirme ,required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          height: getFullHeight(context) * 0.2,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
      child: Column(children: [
        SizedBox(height: 20,),
        Text(message ,style: context.typographies.body,),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoundedButton(
                onlyText: false,
                key: Key("next"),
                text:  "Confirme",
                width: getFullWigth(context) * 0.3,
                onPressed: () {
                  onComfirme.call();
                },
                color: AppColors.paarl_lite),
            RoundedButton(
                onlyText: true,
                key: Key("Sign In "),
                text: "cancel",
                width: getFullWigth(context) * 0.3,
                onPressed: () {

                 onCancel.call();
                },
                color: AppColors.paarl)
          ],
        )

      ],),


      ),
    );
  }
}
