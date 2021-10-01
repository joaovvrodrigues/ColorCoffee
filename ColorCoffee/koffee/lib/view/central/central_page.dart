import 'package:flutter/material.dart';
import '../../widgets/card.dart';

class CentralPage extends StatefulWidget {
  const CentralPage({Key? key}) : super(key: key);

  @override
  _CentralPageState createState() => _CentralPageState();
}

class _CentralPageState extends State<CentralPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CardWithText(
          imageUrl:
              'https://cdn.shopify.com/s/files/1/0017/8585/6070/files/Color-changes_1024x1024.jpg?v=1552090641',
          title: 'Escala',
          subtitle: 'Agtron',
        ),
        CardWithText(
          imageUrl:
              'https://coffeetranslator.com/wp-content/uploads/2018/03/types-of-roasting-coffee-1-1024x768-394x330.jpg',
          title: 'Escala',
          subtitle: 'Agtron',
        ),
      ],
    );
  }
}
