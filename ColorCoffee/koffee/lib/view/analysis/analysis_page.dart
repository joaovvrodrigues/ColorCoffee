import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/elevated_button.dart';
import 'widgets/tutorial_dialog.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    Key? key,
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (croppedFile != null) Image.file(croppedFile!),
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
    bool? according = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const TutorialDialog();
        });
    if (according != null) {
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
    }
    setState(() {});
  }
}