import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../model/roast.dart';
import 'color_controller.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    Key? key,
    this.image,
  }) : super(key: key);
  final File? image;
  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  ColorControll controller = ColorControll();
  Color? containerColor = const Color(0xFFFFF9F2);
  Random rng = Random();

  @override
  void initState() {
    if (widget.image != null) {
      controller.uploadImageToServer(widget.image!);
    }

    // Future.delayed(const Duration(seconds: 2)).then((value) {
    //   controller.roast.value = Roast(
    //       color: 'Color',
    //       prediction: rng.nextInt(100).toString(),
    //       confidence: rng.nextInt(100).toString(),
    //       rgb: [rng.nextInt(255), rng.nextInt(255), rng.nextInt(255)]);

    //   controller.color = Color.fromARGB(255, controller.roast.value!.rgb[0],
    //       controller.roast.value!.rgb[1], controller.roast.value!.rgb[2]);

    //   changeTheme();
    // });

    super.initState();
  }

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
                    ? const SizedBox()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Amostra',
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: controller.color),
                            ),
                          ),
                          const Text('Agtron', style: TextStyle(fontSize: 22)),
                          Text(value.prediction,
                              style: const TextStyle(fontSize: 60)),
                          const SizedBox(height: 10),
                          const Text('confiança'),
                          Text('${value.confidence}%'),
                        ],
                      ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.getRandomColor();
          changeTheme();
        },
        tooltip: 'Send Image',
        child: const Icon(Icons.camera_enhance_rounded),
      ),
    );
  }

  void changeTheme() {
    setState(() {
      containerColor = controller.color.withAlpha(210);
    });
  }
}
