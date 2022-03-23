import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/theme.dart';
import '../analysis/analysis_page.dart';
import 'camera.dart';
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
  late CameraController controller;

  final ImagePicker _picker = ImagePicker();
  File? cropCafe;
  File? cropFolha;
  Uint8List? cafe;
  Uint8List? folha;

  @override
  void initState() {
    super.initState();
  }

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
            // if (cafe != null)
            //   Image.memory(
            //     cafe!,
            //     width: 300,
            //     height: 300,
            //     fit: BoxFit.fill,
            //   ),
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

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    await Navigator.push(context, MaterialPageRoute(builder: (_) => TakePictureScreen(camera: firstCamera)));

    if (imagePath != null) {
      Random _rnd = Random();
      await cropImage(imagePath, _rnd.nextInt(10).toString(), 'cropCafe');
    }
  }

  void pickImage() async {
    await Fluttertoast.showToast(
      msg: 'Selecione a foto da amostra de café',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    XFile? cafeFile = await _picker.pickImage(source: ImageSource.gallery);

    await Fluttertoast.showToast(
      msg: 'Selecione a foto da folha de papel',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    XFile? papelFile = await _picker.pickImage(source: ImageSource.gallery);

    if (cafeFile != null) {
      await cropImage(cafeFile.path, cafeFile.name, 'cafe');
    }

    if (papelFile != null) {
      await cropImage(papelFile.path, papelFile.name, 'folha');
    }

    if (cropCafe != null && cropFolha != null) {
      cafe = resizeImage(cropCafe!.readAsBytesSync());
      folha = resizeImage(cropFolha!.readAsBytesSync());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnalysisPage(cafe: cafe!, folha: folha!)));
    }

    setState(() {});
  }

  Uint8List resizeImage(Uint8List data) {
    Uint8List resizedData = data;
    img.Image? bitmap = img.decodeImage(data);
    img.Image? resized = img.copyResize(bitmap!, width: 512, height: 512);
    resizedData = Uint8List.fromList(img.encodeJpg(resized));
    return resizedData;
  }

  Future<File?> imagemCortada(String path) async {
    return await ImageCropper().cropImage(
        sourcePath: path,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            activeControlsWidgetColor: Colors.brown,
            hideBottomControls: true,
            showCropGrid: true,
            toolbarTitle: 'Enquadre a cafe',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            cropGridRowCount: 0,
            cropGridColumnCount: 0,
            dimmedLayerColor: AppTheme.black.withAlpha(180),
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings(
          title: 'Enquadre a cafe',
          doneButtonTitle: 'Enviar',
          cancelButtonTitle: 'Cancelar',
          showCancelConfirmationDialog: true,
          minimumAspectRatio: 1.0,
        ));
  }

  Future<void> cropImage(String path, String name, String? img) async {
    bool? according = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const TutorialDialog();
        });
    if (according != null) {
      if (img == 'cafe') {
        cropCafe = await imagemCortada(path);
      } else {
        cropFolha = await imagemCortada(path);
      }
    }
  }
}
