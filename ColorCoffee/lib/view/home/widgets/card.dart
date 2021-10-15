import 'package:flutter/material.dart';
import '../../../model/card_info.dart';
import '../../../theme/theme.dart';
import '../../description/description_page.dart';

@immutable
class CardWithText extends StatelessWidget {
  const CardWithText({
    Key? key,
    required this.cardInfo
  }) : super(key: key);
  final CardInfo cardInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  DescriptionPage(cardInfo: cardInfo))),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(cardInfo.imagePath), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            child: Stack(
              children: [
                _buildGradient(),
                _buildTitleAndSubtitle(),
              ],
            ),
          ),
        ));
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Hero(
        tag: 'teste',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardInfo.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
             cardInfo.subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
