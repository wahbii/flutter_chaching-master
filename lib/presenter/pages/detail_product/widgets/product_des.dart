import 'package:flutter/material.dart';
import 'package:pokedex/presenter/themes/colors.dart';
import 'package:pokedex/presenter/themes/extensions.dart';

import '../../../../data/entities/product.dart';
import '../../../../utils/size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app.dart';


class ProductDescription extends StatelessWidget {
  const ProductDescription(
      {Key? key,
      required this.product,
      required this.add,
      required this.minus,
      required this.quantite})
      : super(key: key);

  final Product? product;
  final GestureTapCallback add;
  final GestureTapCallback minus;
  final int quantite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            PokedexApp.of(context)?.local == Locale("ar")
                ? product?.nameAr ?? ""
                : (PokedexApp.of(context)?.local == Locale("fr")
                ? product?.nameFr ?? ""
                : product?.nameEng ?? ""),

            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            PokedexApp.of(context)?.local == Locale("ar")
                ? product?.descAr ?? ""
                : (PokedexApp.of(context)?.local == Locale("fr")
                ? product?.descAr ?? ""
                : product?.descEng ?? ""),
            maxLines: 3,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(16),
            width: 100,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE6E6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Text(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: AppColors.paarl),
                " ${product?.units} ${AppLocalizations.of(context)?.units}"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                 Text(
                  "${AppLocalizations.of(context)?.price} : ",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                const SizedBox(width: 5),
                Text(
                  "${product?.price ?? 0 * quantite} ${AppLocalizations.of(context)?.currency}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: AppColors.paarl),
                )
              ],
            ),
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
                  Container(
                    margin: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                         Text("${AppLocalizations.of(context)?.quantite} : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.black)),
                        AnimatedContainer(
                            duration: Duration(seconds: 2),
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(8),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.paarl_lite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              "$quantite",
                              style: context.typographies.bodyLarge
                                  .withColor(AppColors.white),
                            ))),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: getFullWigth(context) * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                add.call();
                              },
                              child: AnimatedContainer(
                                  duration: Duration(seconds: 2),
                                  margin: const EdgeInsets.only(right: 16),
                                  padding: const EdgeInsets.all(8),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.paarl_lite,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                  ))),
                          InkWell(
                            onTap: () {
                              minus.call();
                            },
                            child: AnimatedContainer(
                                duration: Duration(seconds: 2),
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(8),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.paarl_lite,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.remove,
                                    color: AppColors.white)),
                          )
                        ],
                      )),
                ],
              ),
            )),
      ],
    );
  }
}
