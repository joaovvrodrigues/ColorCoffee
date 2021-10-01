import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../test/teste_page.dart';
import '../central/central_page.dart';
import '../color/color_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItemPosition = 0;
  PageController pageController = PageController();

  final colorizeTextStyle = GoogleFonts.sourceSansPro(
      color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: RichText(
          text: TextSpan(
            text: 'Color',
            style: colorizeTextStyle,
            children: const <TextSpan>[
              TextSpan(
                  text: 'coffee',
                  style: TextStyle(color: Color(0xFFD4A056))) //Colors.brown)),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: const <Widget>[PagerPageWidget(), CentralPage(), ColorPage()],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.all(10),
        snakeViewColor: Colors.brown[900],
        unselectedItemColor: Colors.brown[200],
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() {
          _selectedItemPosition = index;

          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.camera_enhance)),
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _selectedItemPosition = page;
    });
  }
}
