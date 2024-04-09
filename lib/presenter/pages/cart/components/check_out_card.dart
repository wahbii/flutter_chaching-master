import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/presenter/pages/cart/components/you_can_pay.dart';
import 'package:pokedex/presenter/themes/extensions.dart';

import '../../../assets.gen.dart';
import '../../../themes/colors.dart';
import 'info_payment.dart';
import 'modal_payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutCard extends StatelessWidget {
  final double total;
  final Function(UserModel) onPaymentDone;

  CheckoutCard({
    Key? key, required this.total ,required this.onPaymentDone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "${AppLocalizations.of(context)?.total}:\n",
                      children: [
                        TextSpan(
                          text: "$total ${AppLocalizations.of(context)?.currency}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                         total == 0.0 ?  AppColors.paarl_lite : AppColors.paarl),

                    ),
                    onPressed: () {
                      if(total!=0.0){
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              InformationPaymentBottomModal (
                           onValidate: (usermdl){
                             Navigator.of(context).pop();
                             showModalBottomSheet(
                               context: context,
                               isScrollControlled: true,
                               backgroundColor: Colors.transparent,
                               builder: (context) => PaymentModalDialog(
                                 userModel: usermdl,
                                 amount: total,
                                 onFailure: (){
                                   Navigator.of(context).pop();
                                 },
                                 onSucess: (){
                                   Navigator.of(context).pop();
                                   onPaymentDone.call(usermdl);
                                 },
                               ),
                             );


                           },mantant: total,
                          ),
                        );
                      }
                    },
                    child:  Text(AppLocalizations.of(context)?.check_out ?? ""),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

