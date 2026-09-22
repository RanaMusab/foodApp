import 'package:flutter/material.dart';

class GradientConstants {
  static const linearGradient = LinearGradient(
    colors: [
      Color(0xFFEBEFED),
      Color(0xFFFFFFFF), // primaryColor with alpha 0.3
      Color(0xFFEBEFED),
    ],

    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
