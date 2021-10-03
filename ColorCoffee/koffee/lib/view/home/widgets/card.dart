import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../description/description_page.dart';

@immutable
class CardWithText extends StatelessWidget {
  const CardWithText({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.index,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DescriptionPage())),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.cover),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
