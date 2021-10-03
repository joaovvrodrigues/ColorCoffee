import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text('  $text'),
        ],
      ),
      style: AppTheme.elevatedButtonStyle,
      onPressed: onPressed,
    );
  }
}
