import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../model/roast.dart';
import 'color_controller.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key, required this.cafe, required this.folha}) : super(key: key);
  final Uint8List cafe;
  final Uint8List folha;
  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  ColorControll controller = ColorControll();

  @override
  void initState() {
    controller.uploadImageToServer(cafe: widget.cafe, folha: widget.folha);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Roast?>(
        valueListenable: controller.roast,
        builder: (BuildContext context, Roast? value, __) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: value != null ? value.color : Colors.brown,
            ),
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            extendBody: true,
            body: AnimatedContainer(
                color: value != null ? value.color.withAlpha(200) : const Color(0xFFFFF9F2).withAlpha(210),
                duration: const Duration(seconds: 1),
                child: Center(
                  child: value == null
                      ? SizedBox(child: Image.memory(widget.cafe))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(child: Image.memory(widget.cafe)),
                            const SizedBox(height: 12),
                            const Text(
                              'Amostra',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: value.color),
                              ),
                            ),
                            const Text('Agtron', style: TextStyle(fontSize: 22)),
                            Text(value.prediction, style: const TextStyle(fontSize: 60)),
                            // const SizedBox(height: 10),
                            // const Text('confiança'),
                            // Text('${value.confidence}%'),
                          ],
                        ),
                )),
            floatingActionButton: FloatingActionButton(
              backgroundColor: value != null ? value.color : Colors.brown,
              onPressed: () async {
                // await controller.getRandomColor();

                // setState(() {
                //   controller.teste(widget.cafe!);
                // });
              },
              tooltip: 'Random Color',
              child: const Icon(Icons.repeat_on_rounded),
            ),
          );
        });
  }
}
