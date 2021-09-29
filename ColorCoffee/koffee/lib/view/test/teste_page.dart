import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PagerPageWidget extends StatefulWidget {
  final String? text;
  final String? description;

  const PagerPageWidget({
    Key? key,
    this.text,
    this.description,
  }) : super(key: key);

  @override
  State<PagerPageWidget> createState() => _PagerPageWidgetState();
}

class _PagerPageWidgetState extends State<PagerPageWidget> {
  final ImagePicker _picker = ImagePicker();
  File? croppedFile;
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SafeArea(child: _portraitWidget()),
    );
  }

  Widget _portraitWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const FlutterLogo(),
        if (croppedFile != null) Image.file(croppedFile!),
        ElevatedButton(
          child: const Text('take image'),
          onPressed: () async {
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
          },
        ),
        ElevatedButton(
          child: const Text('pick image'),
          onPressed: () async {
            XFile? image = await _picker.pickImage(source: ImageSource.gallery);

            if (image != null) {
              await cropImage(image.path);
            }
          },
        )
      ],
    );
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
