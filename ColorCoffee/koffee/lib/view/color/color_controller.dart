import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:koffee/model/roast.dart';

class ColorControll {
  static const uploadUrl = 'http://192.168.1.29:33/api/send';
  final ImagePicker _picker = ImagePicker();

  Color color = Colors.brown;

  final ValueNotifier<Roast?> roast = ValueNotifier<Roast?>(null);

  Future<void> getRandomColor() async {
    var response = await http.get(
      Uri.parse('http://192.168.1.29:33/api/random'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      roast.value = Roast.fromJson(response.body);
      color = Color.fromARGB(
          255, roast.value!.rgb[0], roast.value!.rgb[1], roast.value!.rgb[2]);
    }
  }

  Future<void> sendImage() async {
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

    if (_image != null) {
      _uploadImageToServer(_image);
    }
  }

  Future<void> _uploadImageToServer(XFile image) async {
    EasyLoading.show(status: 'Enviando...');

    Uri postUri = Uri.parse(uploadUrl);
    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), await image.length(),
        filename: image.name));

    try {
      http.StreamedResponse streamedResponse = await request.send();

      Future.delayed(const Duration(seconds: 1))
          .then((value) => EasyLoading.dismiss());

      await Future.delayed(const Duration(milliseconds: 600));

      switch (streamedResponse.statusCode) {
        case 200:
          EasyLoading.showSuccess('Enviado!');
          http.Response response =
              await http.Response.fromStream(streamedResponse);

          roast.value = Roast.fromJson(response.body);
          color = Color.fromARGB(255, roast.value!.rgb[0], roast.value!.rgb[1],
              roast.value!.rgb[2]);
          break;

        case 400:
          EasyLoading.showError('Arquivo não encontrado!');
          break;

        case 403:
          EasyLoading.showError('Arquivo inválido!');
          break;

        default:
          EasyLoading.showInfo('Algo deu errado.');
      }
    } catch (e) {
      EasyLoading.showError('Erro inesperado!');
    }
  }
}
