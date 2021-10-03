import 'package:flutter/material.dart';
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
        itemCount: 6,
        itemBuilder: (context, index) => CardWithText(
          imageUrl:
              'https://cdn.shopify.com/s/files/1/0017/8585/6070/files/Color-changes_1024x1024.jpg?v=1552090641',
          title: 'Escala',
          subtitle: 'Agtron',
          index: index,
        ),
      ),
    );
  }
}
