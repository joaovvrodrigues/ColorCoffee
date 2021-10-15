import 'package:flutter/material.dart';
import '../../constants/home_constants.dart';
import 'widgets/card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) => CardWithText(
          cardInfo: homeConstants[index],
        ),
      ),
    );
  }
}
