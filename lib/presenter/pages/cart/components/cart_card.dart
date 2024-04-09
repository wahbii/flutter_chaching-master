import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/data/entities/card_item.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../utils/size.dart';
import '../../../app.dart';

class CartCard extends StatelessWidget {

  final Function() onPlus ;
  final Function() onMinus ;
  final bool showIcon  ;

   CartCard({
    Key? key,
    required this.cart,
    required this.onPlus,
    required this.onMinus,
    required this.showIcon

  }) : super(key: key);

  final CardItem cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 90,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.memory(base64Decode(cart.images),fit: BoxFit.contain,),
              ),
            ),
          ),
         Container(
           height: 90,
           child:  Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             Text(
               PokedexApp.of(context)?.local == Locale("ar")
                   ? cart?.nameAr ?? ""
                   : (PokedexApp.of(context)?.local == Locale("fr")
                   ? cart?.nameFr ?? ""
                   : cart?.nameEng ?? ""),
               style:context.typographies.body,
               maxLines: 2,
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text.rich(
                   TextSpan(
                     text: "\ ${cart.price} ${AppLocalizations.of(context)?.currency}",
                     style: const TextStyle(
                         fontWeight: FontWeight.w900, color: AppColors.paarl),
                     children: [
                       TextSpan(
                           text: " x${cart.quantite}",
                           style: Theme.of(context).textTheme.bodyLarge),
                     ],
                   ),
                 ),
                 Padding(
                     padding: const EdgeInsets.symmetric(
                       horizontal: 20,
                       vertical: 12,
                     ),
                     child: Container(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           SizedBox(
                               width: getFullWigth(context) * 0.2,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   InkWell(
                                       onTap: () {
                                         // add.call();
                                         onPlus.call();
                                       },
                                       child: Container(
                                           height: 30,
                                           width: 30,
                                           decoration: showIcon? BoxDecoration(
                                             color: AppColors.paarl_lite,
                                             borderRadius:
                                             BorderRadius.circular(20),
                                           ) : null,
                                           child: showIcon? const Center(
                                               child: Icon(
                                                 Icons.add,
                                                 color: AppColors.white,
                                               )):SizedBox())),
                                   InkWell(
                                     onTap: () {
                                       //minus.call();
                                       onMinus.call();
                                     },
                                     child: Container(
                                         margin:
                                         const EdgeInsets.only(left: 16),
                                         height: 30,
                                         width: 30,
                                         decoration:showIcon? BoxDecoration(
                                           color: AppColors.paarl_lite,
                                           borderRadius:
                                           BorderRadius.circular(20),
                                         ):null,
                                         child: showIcon? const Icon(Icons.remove,
                                             color: AppColors.white):SizedBox()),
                                   )
                                 ],
                               ))
                         ],
                       ),
                     ))
               ],
             )
           ],
         ),)
        ],
      ),
    );
  }
}
