//app_colors.dart defines the colors that will be used in the app. It is a good practice to define the colors in a separate file so that they can be easily changed and maintained.

import 'package:flutter/material.dart';

class AppColors {
  // Your primary Maroon brand color
  static const Color maroon = Color(0xFF800000);
  static const Color lightmaroon = Color.fromARGB(255, 130, 50, 50);

  // Neutral colors for backgrounds and text
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Colors.white;
  static const Color textMain = Color.fromARGB(255, 35, 5, 5);
  static const Color textGrey = Color(0xFF757575);
}
