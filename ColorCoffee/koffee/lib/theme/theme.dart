import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const double radius = 16.0;

  static const Color background = Color(0xFFFDE1D7);

  static ThemeData koffeTheme = ThemeData(
      floatingActionButtonTheme:  FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius)),
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(
          0xFFFFF9F2), //const Color(0xFFE6CCB2), //Colors.brown[300],
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white)),
      primarySwatch: Colors.brown,
      pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder()
          }));

 static final  appBarText = GoogleFonts.sourceSansPro(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600);

      
  InputDecoration inputDecoration(IconData icon) {
    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefix: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ));
  }

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      elevation: 0,
      primary: Colors.brown,
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      minimumSize: const Size(120, 50),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius)
      ));
}
