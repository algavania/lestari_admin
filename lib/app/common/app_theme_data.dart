import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'color_values.dart';

class AppThemeData {
  static ThemeData getTheme(BuildContext context) {
    const Color primaryColor = ColorValues.primaryYellow;
    final Map<int, Color> primaryColorMap = {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
    final MaterialColor primaryMaterialColor =
    MaterialColor(primaryColor.value, primaryColorMap);

    return ThemeData(
      useMaterial3: false,
      primaryColor: primaryColor,
      primarySwatch: primaryMaterialColor,
      scaffoldBackgroundColor: ColorValues.white,
      canvasColor: ColorValues.white,
      brightness: Brightness.light,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: ColorValues.onyx, displayColor: ColorValues.onyx),
      iconTheme: IconThemeData(size: 6.w),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorValues.primaryYellow
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorValues.onyx,
            backgroundColor: primaryColor,
            elevation: 0.0,
            minimumSize: const Size(double.infinity, 45.0),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            splashFactory: NoSplash.splashFactory,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 45.0),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: ColorValues.lightGrey),
              borderRadius: BorderRadius.circular(10),
            ),
          )
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: ColorValues.accentGreen,
        unselectedItemColor: ColorValues.grey,
      ),
      appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(color: ColorValues.grey),
        elevation: 1.5,
        backgroundColor: ColorValues.white,
        actionsIconTheme: const IconThemeData(color: ColorValues.grey),
        titleSpacing: 0.0,
        titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorValues.onyx
        ),
        toolbarTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorValues.grey),
      ),
    );
  }
}
