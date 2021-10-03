import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../../model/roast.dart';

class ColorControll {
  static const uploadUrl = 'http://192.168.1.29:33/api/send';

  Color color = Colors.brown;
  final ValueNotifier<Roast?> roast = ValueNotifier<Roast?>(null);

  Future<void> getRandomColor() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse('http://192.168.1.29:33/api/random'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      EasyLoading.showInfo(
          'Algo deu errado com nosso servidor. \n ${e.toString()}');
    } finally {
      if (response != null && response.statusCode == 200) {
        roast.value = Roast.fromJson(response.body);
        color = Color.fromARGB(
            255, roast.value!.rgb[0], roast.value!.rgb[1], roast.value!.rgb[2]);
      }
    }
  }

  Future<void> uploadImageToServer(File image) async {
    EasyLoading.show(status: 'Enviando...');

    http.StreamedResponse? streamedResponse;

    Uri postUri = Uri.parse(uploadUrl);
    http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), await image.length(),
        filename: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'));

    try {
      streamedResponse = await request.send();
    } catch (e) {
      await EasyLoading.showError('Erro inesperado! \n ${e.toString()}',
          duration: const Duration(seconds: 2));
    } finally {
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => EasyLoading.dismiss());

      await Future.delayed(const Duration(milliseconds: 600));

      if (streamedResponse != null) {
        switch (streamedResponse.statusCode) {
          case 200:
            EasyLoading.showSuccess('Enviado!',
                duration: const Duration(seconds: 2));
            http.Response response =
                await http.Response.fromStream(streamedResponse);

            roast.value = Roast.fromJson(response.body);
            color = Color.fromARGB(255, roast.value!.rgb[0],
                roast.value!.rgb[1], roast.value!.rgb[2]);
            break;

          case 400:
            await EasyLoading.showError('Arquivo não encontrado!',
                duration: const Duration(seconds: 2));
            break;

          case 403:
            await EasyLoading.showError('Arquivo inválido!',
                duration: const Duration(seconds: 2));
            break;

          default:
            await EasyLoading.showInfo('Algo deu errado.',
                duration: const Duration(seconds: 2));
        }
      }
    }
  }
}
