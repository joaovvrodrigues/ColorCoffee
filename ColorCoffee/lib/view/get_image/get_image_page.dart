import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../openCV/native_opencv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/theme.dart';
import '../analysis/analysis_page.dart';
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
            // if (croppedFile != null) Image.file(croppedFile!),
            CustomButton(
                icon: Icons.nat,
                text: 'Navegar',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnalysisPage()))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomButton(
                  icon: Icons.camera_alt_rounded,
                  text: 'Capturar imagem',
                  onPressed: takePhoto),
            ),
            CustomButton(
                icon: Icons.photo_library_rounded,
                text: 'Selecionar imagem',
                onPressed: pickImage)
          ],
        )));
  }

  void takePhoto() async {
    String? imagePath;

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraCamera(
                  onFile: (file) {
                    imagePath = file.path;
                    Navigator.pop(context);
                    setState(() {});
                  },
                )));

    if (imagePath != null) {
      Random _rnd = Random();
      await cropImage(imagePath!, _rnd.nextInt(10).toString());
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
      File? croppedFile;

      croppedFile = await ImageCropper.cropImage(
          sourcePath: path,
          cropStyle: CropStyle.rectangle,
          maxHeight: 128,
          maxWidth: 128,
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
        Directory tempDir = await getTemporaryDirectory();

        EasyLoading.show(status: 'Processando...');

        final port = ReceivePort();
        final args = ProcessImageArguments(
            croppedFile.path, '${tempDir.path}/$name.jpg');

        // Spawning an isolate
        Isolate.spawn<ProcessImageArguments>(
          processImage,
          args,
          onError: port.sendPort,
          onExit: port.sendPort,
        );

        // Making a variable to store a subscription in
        late StreamSubscription sub;

        // Listening for messages on port
        sub = port.listen((_) async {
          // Cancel a subscription after message received called
          await sub.cancel();

          await EasyLoading.dismiss();

          File processedImage = File('${tempDir.path}/$name.jpg');

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AnalysisPage(image: processedImage)));
        });
      }
    }
    setState(() {});
  }
}
