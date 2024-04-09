import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/presenter/themes/colors.dart';

class _CategoryCard extends StatelessWidget {
  const _CategoryCard( {
    required this.icon,
    required this.text,
    required this.press,
  }) : super();

  final String? icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon != null? Image.memory(
              base64Decode(icon!) ,
              fit: BoxFit.cover,
              color: AppColors.paarl,
            ):Icon(Icons.border_all_rounded,color: AppColors.paarl,),
          ),
          const SizedBox(height: 4),
          Text(text, textAlign: TextAlign.center)
        ],
      ),
    );
  }
}