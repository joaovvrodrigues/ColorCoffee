import 'package:flutter/material.dart';
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
                    ? const Text(
                        'Envie foto',
                      )
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
            await controller.getRandomColor();
            changeTheme();
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
