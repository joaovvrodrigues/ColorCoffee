import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bottom_navigation/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  final List<String> cafe = [
    'café',
    'кофе',
    'coffee',
  ];

  final colorizeTextStyle = GoogleFonts.sourceSansPro(
      color: Colors.black, fontSize: 42, fontWeight: FontWeight.w600);

  final colorizeColors = const [
    Color(0xFF9C6644),
    Color(0xFF7F5539),
    Color(0xFFB08968),
    Color(0xFFDDB892),
    Color(0xFFE6CCB2),
    Color(0xFFEDE0D4),
    Color(0xFFFFF9F2)
  ];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((__) => setState(() {
          opacity = 1.0;
        }));
    Future.delayed(const Duration(seconds: 2, milliseconds: 500))
        .then((__) => Navigator.pushReplacement(context, _createRoute()));
    super.initState();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 1, milliseconds: 300),
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) => const BottomNavigation(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF9F2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/logo.png',
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.25,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Color', style: colorizeTextStyle),
              AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: opacity,
                  child: Text('coffee',
                      style: colorizeTextStyle.copyWith(
                          color: const Color(0xFF9C6644)))),
            ],
          )
        ],
      ),
    );
  }
}
