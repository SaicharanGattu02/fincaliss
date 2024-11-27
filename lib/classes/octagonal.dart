
import 'dart:ui';

import 'package:flutter/material.dart';

class OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    double width = size.width;
    double height = size.height;

    path.moveTo(width * 0.293, 0);
    path.lineTo(width * 0.707, 0);
    path.lineTo(width, height * 0.293);
    path.lineTo(width, height * 0.707);
    path.lineTo(width * 0.707, height);
    path.lineTo(width * 0.293, height);
    path.lineTo(0, height * 0.707);
    path.lineTo(0, height * 0.293);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
