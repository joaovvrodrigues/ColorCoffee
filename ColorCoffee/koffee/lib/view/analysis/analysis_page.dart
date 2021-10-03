import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/theme.dart';

class AnalysisPage extends StatefulWidget {
  final String? text;
  final String? description;

  const AnalysisPage({
    Key? key,
    this.text,
    this.description,
  }) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final ImagePicker _picker = ImagePicker();
  File? croppedFile;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Image.asset(
            //   'assets/gifs/enquadrarFotoAndroid.gif',
            //   width: 200.0,
            // ),
            if (croppedFile != null) Image.file(croppedFile!),
            ElevatedButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt_rounded),
                  Text('  Capturar imagem'),
                ],
              ),
              style: AppTheme.elevatedButtonStyle,
              onPressed: takePhoto,
            ),
            ElevatedButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.photo_library_rounded),
                  Text('  Selecionar imagem'),
                ],
              ),
              style: AppTheme.elevatedButtonStyle,
              onPressed: pickImage,
            )
          ],
        )));
  }

  void takePhoto() async {
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
      await cropImage(imagePath!);
    }
  }

  void pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await cropImage(image.path);
    }
  }

  Future<void> cropImage(String path) async {
    croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        cropStyle: CropStyle.rectangle,
        maxHeight: 180,
        maxWidth: 180,
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
            dimmedLayerColor: Colors.black.withAlpha(180),
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: 'Enquadre a amostra',
          doneButtonTitle: 'Enviar',
          cancelButtonTitle: 'Cancelar',
          showCancelConfirmationDialog: true,
          minimumAspectRatio: 1.0,
        ));
    setState(() {});
  }
}
