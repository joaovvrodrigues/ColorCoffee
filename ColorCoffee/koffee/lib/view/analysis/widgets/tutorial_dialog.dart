import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({Key? key}) : super(key: key);

  @override
  _TutorialDialogState createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)), //this right here
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          showTrackOnHover: true,
          child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            children: [
              const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Atenção',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  )),
              const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                      'Para que haja um bom reconhecimento da amostra de café, recorte a imagem preenchendo o quadrado com a amostra.',
                      style: TextStyle(color: Colors.black, fontSize: 14.0))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/gifs/enqFotoAndroid.gif',
                  height: 300,
                ),
              ),
              ElevatedButton(
                child: const Text('Continuar'),
                style: AppTheme.elevatedButtonStyle,
                onPressed: () => Navigator.of(context).pop(true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
