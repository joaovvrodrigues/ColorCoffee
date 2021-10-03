import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../get_image/get_image_page.dart';
import '../home/home_page.dart';
import '../../theme/theme.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedItemPosition = 0;
  PageController pageController = PageController();

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
            style: AppTheme.appBarText,
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
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: const <Widget>[HomePage(), GetImagePage()],
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
