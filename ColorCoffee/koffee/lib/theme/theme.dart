import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class ThemeChanger extends ChangeNotifier {
//   ThemeData _themeData;
//   ThemeChanger(this._themeData);

//   ThemeData get getTheme => _themeData;
//   void setTheme(ThemeData theme) {
//     _themeData = theme;
//     notifyListeners();
//   }
// }

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFFFDE1D7);

  // static const Color sunset = Color(0xFFF65B4E);
  // static const Color monalisa = Color(0xFFFF9A9A);
  // static const Color twilight = Color(0xFF29319F);
  // static const Color seashell = Color(0xFFFFF3E9);
  // static const Color morning = Color(0xFFFFBA7C);
  // static const Color fog = Color(0xFFFFDEEF);
  // static const Color eclipse = Color(0xFF573353);
  // static const Color dandelion = Color(0xFFFFDE5F);

  // static const Map<int, Color> colorCodes = {
  //   50: Color.fromRGBO(255, 222, 95, .1),
  //   100: Color.fromRGBO(255, 222, 95, .2),
  //   200: Color.fromRGBO(255, 222, 95, .3),
  //   300: Color.fromRGBO(255, 222, 95, .4),
  //   400: Color.fromRGBO(255, 222, 95, .5),
  //   500: Color.fromRGBO(255, 222, 95, .6),
  //   600: Color.fromRGBO(255, 222, 95, .7),
  //   700: Color.fromRGBO(255, 222, 95, .8),
  //   800: Color.fromRGBO(255, 222, 95, .9),
  //   900: Color.fromRGBO(255, 222, 95, 1),
  // };

  // static const MaterialColor dandelionMaterial =
  //     MaterialColor(0xFFFFDE5F, colorCodes);

  static ThemeData koffeTheme = ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
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

  // static ThemeData lightTheme = ThemeData(
  //     brightness: Brightness.light,
  //     primaryColor: seashell,
  //     scaffoldBackgroundColor: seashell,
  //     primarySwatch: dandelionMaterial,
  //     // bottomAppBarColor: MaterialColor(0xFFFFDE5F, colorCodes),
  //     backgroundColor: seashell,
  //     fontFamily: 'Manrope',
  //     primaryColorBrightness: Brightness.light,
  //     canvasColor: seashell,
  //     splashColor: dandelionMaterial.shade300,
  //     errorColor: monalisa,
  //     bottomAppBarColor: Colors.white,
  //     cardColor: Colors.white,
  //     dividerColor: seashell,
  //     focusColor: morning,
  //     buttonTheme: ButtonThemeData(
  //       colorScheme: ColorScheme.fromSwatch(),
  //       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(12)),
  //       ),
  //     ),
  //     pageTransitionsTheme: const PageTransitionsTheme(
  //         builders: <TargetPlatform, PageTransitionsBuilder>{
  //           TargetPlatform.android: ZoomPageTransitionsBuilder()
  //         }));
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ));
}
