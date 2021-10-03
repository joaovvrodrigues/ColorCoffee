import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../model/roast.dart';
import 'color_controller.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({Key? key}) : super(key: key);

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  ColorControll controller = ColorControll();
  Color? containerColor = const Color(0xFFFFF9F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: AnimatedContainer(
        color: containerColor,
        duration: const Duration(seconds: 1),
        child: ValueListenableBuilder<Roast?>(
            valueListenable: controller.roast,
            builder: (BuildContext context, Roast? value, __) {
              return Center(
                child: value == null
                    ? SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Amostra',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: controller.color),
                            ),
                          ),
                          const Text('Agtron', style: TextStyle(fontSize: 22)),
                          Text(value.prediction,
                              style: const TextStyle(fontSize: 60)),
                          const SizedBox(height: 20),
                          const Text('confiança'),
                          Text('${value.confidence}%'),
                        ],
                      ),
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 62),
        child: FloatingActionButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AtencaoDialog();
                });

            // await controller.getRandomColor();
            // changeTheme();
          },
          tooltip: 'Send Image',
          child: const Icon(Icons.camera_enhance_rounded),
        ),
      ),
    );
  }

  void changeTheme() {
    setState(() {
      containerColor = controller.color.withAlpha(210);
    });
  }
}

class AtencaoDialog extends StatefulWidget {
  const AtencaoDialog({Key? key}) : super(key: key);

  @override
  _AtencaoDialogState createState() => _AtencaoDialogState();
}

class _AtencaoDialogState extends State<AtencaoDialog> {
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
