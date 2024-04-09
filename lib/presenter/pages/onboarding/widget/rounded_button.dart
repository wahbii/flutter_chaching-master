import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final double width;
  final bool onlyText;



  const RoundedButton({
    required Key key,
    required this.text,
    required this.onPressed,
    required this.color ,
    required this.width,
    required this.onlyText
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: onlyText? Border.all(
            color: color, // Specify border color here
            width: 2,
            // Specify border width here
          ) : null,
          borderRadius: BorderRadius.circular(20.0),
          color: onlyText ? Colors.white : color,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style:  TextStyle(
            color: onlyText? color : Colors.white,
            fontSize: 16,
            fontFamily: "OpenSans",  // <- Looks up the specified font in pubspec.yaml
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,


          ),
        ),
      ),
    );
  }
}
