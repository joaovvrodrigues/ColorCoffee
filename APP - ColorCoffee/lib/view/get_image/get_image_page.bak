import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';
import 'package:path_provider/path_provider.dart';

import '../../theme/theme.dart';
import 'widgets/elevated_button.dart';
import 'widgets/tutorial_dialog.dart';

class GetImagePage extends StatefulWidget {
  const GetImagePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GetImagePage> createState() => _GetImagePageState();
}

class _GetImagePageState extends State<GetImagePage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _byte;
  File? croppedFile;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (_byte != null)
              Image.memory(
                _byte!,
                width: 300,
                height: 300,
                fit: BoxFit.fill,
              ),
            CustomButton(
                icon: Icons.ac_unit,
                text: 'Test',
                onPressed: () async {
                  EasyLoading.show(status: 'Processando...', dismissOnTap: true);

                  await Future.delayed(const Duration(seconds: 2));

                  await Future.microtask(() async {
                    _byte = await Cv2.pyrMeanShiftFiltering(
                      pathFrom: CVPathFrom.GALLERY_CAMERA,
                      pathString: croppedFile!.path,
                      spatialWindowRadius: 70,
                      colorWindowRadius: 29,
                    );
                  });
                  EasyLoading.dismiss();
                  // _byte = await Cv2.medianBlur(
                  //   pathFrom: CVPathFrom.GALLERY_CAMERA,
                  //   pathString: croppedFile!.path,
                  //   kernelSize: 29,
                  // );
                  setState(() {
                    _byte;
                  });
                }),
            CustomButton(
                icon: Icons.nat,
                text: 'Get Mean HSV',
                onPressed: () async {
                  List<num> hBucket = [];
                  List<num> sBucket = [];
                  List<num> vBucket = [];

                  Uint8List imageInUnit8List = _byte!;
                  final tempDir = await getTemporaryDirectory();
                  File file = await File('${tempDir.path}/image.png').create();
                  file.writeAsBytesSync(imageInUnit8List);

                  img.Image? bitmap = img.decodeImage(file.readAsBytesSync());
                  if (bitmap != null) {
                    for (int y = 0; y < bitmap.height; y++) {
                      for (int x = 0; x < bitmap.width; x++) {
                        int c = bitmap.getPixel(x, y);

                        int hAux = img.getBlue(c);
                        int vAux = img.getRed(c);
                        int sAux = img.getGreen(c);

                        hBucket.add(hAux);
                        sBucket.add(sAux);
                        vBucket.add(vAux);
                      }
                    }
                    print('${hBucket.average.round()}, ${sBucket.average.round()}, ${vBucket.average.round()}');
                  }
                }),
            // () => Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => const AnalysisPage()))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(icon: Icons.camera_alt_rounded, text: 'Capturar imagem', onPressed: takePhoto),
            ),
            CustomButton(icon: Icons.photo_library_rounded, text: 'Selecionar imagem', onPressed: pickImage)
          ],
        )));
  }

  void takePhoto() async {
    String? imagePath;

    // TODO: Mudar camera
    // await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) => CameraCamera(
    //               onFile: (file) {
    //                 imagePath = file.path;
    //                 Navigator.pop(context);
    //                 setState(() {});
    //               },
    //             )));

    if (imagePath != null) {
      Random _rnd = Random();
      await cropImage(imagePath, _rnd.nextInt(10).toString());
    }
  }

  void pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await cropImage(image.path, image.name);
    }
  }

  Future<void> cropImage(String path, String name) async {
    bool? according = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const TutorialDialog();
        });
    if (according != null) {
      croppedFile = await ImageCropper().cropImage(
          sourcePath: path,
          cropStyle: CropStyle.rectangle,
          // maxHeight: 128,
          // maxWidth: 128,
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              activeControlsWidgetColor: Colors.brown,
              hideBottomControls: true,
              showCropGrid: true,
              toolbarTitle: 'Enquadre a amostra',
              toolbarColor: Colors.brown,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              cropGridRowCount: 0,
              cropGridColumnCount: 0,
              dimmedLayerColor: AppTheme.black.withAlpha(180),
              lockAspectRatio: true),
          iosUiSettings: const IOSUiSettings(
            title: 'Enquadre a amostra',
            doneButtonTitle: 'Enviar',
            cancelButtonTitle: 'Cancelar',
            showCancelConfirmationDialog: true,
            minimumAspectRatio: 1.0,
          ));

      if (croppedFile != null) {
        _byte = await Cv2.cvtColor(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: croppedFile!.path,
          outputType: Cv2.COLOR_RGB2HSV,
        );

        setState(() {
          _byte;
        });

        // Directory tempDir = await getTemporaryDirectory();

        // EasyLoading.show(status: 'Processando...');
        // // Sem o Isolate o app trava enquanto o processamento não for finalizado,
        // // Criação de uma porta para comunicação com isolamento e argumentos para ponto de entrada
        // final port = ReceivePort();
        // final args = ProcessImageArguments(
        //     croppedFile.path, '${tempDir.path}/$name.jpg');

        // // Chamando o Isolate
        // Isolate.spawn<ProcessImageArguments>(
        //   processImage,
        //   args,
        //   onError: port.sendPort,
        //   onExit: port.sendPort,
        // );

        // // Criando uma variável para armazenar uma assinatura da minha Stream
        // late StreamSubscription sub;

        // // Ouvindo mensagens na porta
        // sub = port.listen((_) async {
        //   // Cancelar uma assinatura após o recebimento da mensagem (Processamento finalizado)
        //   await sub.cancel();

        //   await EasyLoading.dismiss();

        //   File processedImage = File('${tempDir.path}/$name.jpg');

        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => AnalysisPage(image: processedImage)));
        // });
      }
    }
    setState(() {});
  }
}
