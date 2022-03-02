import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../bottom_navigation/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool animateCafeText = false;

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value >= 0.8688) {
        _coffeeController.stop();
        Navigator.pushReplacement(context, _createRoute());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
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

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Lottie.asset(
            'assets/lottie/coffeesplash.json',
            controller: _coffeeController,
            onLoaded: (composition) {
              _coffeeController
                ..duration = composition.duration
                ..forward();
            },
          ),
        ]));
  }
}
