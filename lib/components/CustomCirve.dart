import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCurve extends StatefulWidget {
  const CustomCurve({super.key});

  @override
  State<CustomCurve> createState() => _CustomCurveState();
}

class _CustomCurveState extends State<CustomCurve> {
  @override
  Widget build(BuildContext context) {
    return  
      Scaffold(
        body: Center(
        child: ClipPath(
            clipper: CustomCling(),
            child: Container(
              color: Colors.amber,
              height: 600,
              width: 200,
              child: Text('hello'),
            )),
    ),
      );
  }
}

class CustomCling extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double h = size.height;
    double w = size.width;
    final path = Path();

    path.lineTo(w, h);
    path.lineTo( w, h);
    path.lineTo(w, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
