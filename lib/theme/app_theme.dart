//app_theme.dart defines the theme of the app. It is a good practice to define the theme in a separate file so that it can be easily changed and maintained.

import 'package:driver_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      appBarTheme: AppBarTheme(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 85, 10, 0), // Your deep red
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Makes back arrows white
        titleTextStyle: const TextStyle(
          fontFamily: 'Satoshi', // Your primary project font
          fontSize: 25,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      // Set as the default font for the entire app
      fontFamily: 'Satoshi',

      primaryColor: AppColors.maroon,
      scaffoldBackgroundColor: AppColors.background,

      // Different text styles for various text elements in the app
      textTheme: const TextTheme(
        //Display Large is used for the main headers in the app
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),

        //Display Medium is used for subheaders in the app
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),

        //Body Small is used for the body text in the app
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textMain,
        ),

        //Body Medium is used for the body text in the app
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color.fromARGB(255, 55, 8, 8),
        ),

        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textMain,
        ),

        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textGrey,
        ),
      ),
    );
  }
}
