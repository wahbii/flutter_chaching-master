import 'package:flutter/cupertino.dart';

class RotatedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double angle; // Angle in radians

  const RotatedIcon({
    Key? key,
    required this.icon,
    required this.color,
    required this.angle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}