import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/presenter/themes/colors.dart';

import '../../../../data/entities/product.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product? product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.memory(
              base64Decode(widget.product?.images??""),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             SmallProductImage(
                isSelected: true,
                image: widget.product?.images??"", press: () {  },
              ),

          ],
        )
      ],
    );
  }
}

class SmallProductImage extends StatefulWidget {
  const SmallProductImage(
      {super.key,
        required this.isSelected,
        required this.press,
        required this.image});

  final bool isSelected;
  final VoidCallback press;
  final String image;

  @override
  State<SmallProductImage> createState() => _SmallProductImageState();
}

class _SmallProductImageState extends State<SmallProductImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: AppColors.paarl.withOpacity(widget.isSelected ? 1 : 0)),
        ),
        child: Image.memory(
          base64Decode(widget.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}