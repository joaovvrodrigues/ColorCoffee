import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koffee/view/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
  ];
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((__) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomePage())));
    super.initState();
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
              AnimatedTextKit(
                animatedTexts: [
                  for (var coffee in cafe)
                    ColorizeAnimatedText(coffee,
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                        speed: const Duration(milliseconds: 200)),
                ],
                pause: const Duration(milliseconds: 150),
                isRepeatingAnimation: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}
