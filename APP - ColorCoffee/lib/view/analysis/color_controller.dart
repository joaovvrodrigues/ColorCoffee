import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/roast.dart';

class ColorControll {
  static const debugUploadUrl = 'http://192.168.1.29:33/';
  static const uploadUrl = 'https://real-color-coffee.herokuapp.com/';
  static const debug = true;

  final ValueNotifier<Roast?> roast = ValueNotifier<Roast?>(null);

  Future<void> uploadImageToServer({required Uint8List cafe, required Uint8List folha}) async {
    EasyLoading.show(status: 'Enviando...');

    String name = DateTime.now().millisecondsSinceEpoch.toString();

    List<int> listCafe = List.from(cafe);
    List<int> listFolha = List.from(folha);

    FormData formData = FormData.fromMap({
      'cafe': MultipartFile.fromBytes(listCafe, filename: name + '_cafe.jpg'),
      'folha': MultipartFile.fromBytes(listFolha, filename: name + '_folha.jpg')
    });

    Response? response;
    // http.StreamedResponse? streamedResponse;

    // Uri postUri = Uri.parse(debug ? debugUploadUrl + 'send' : uploadUrl + 'send');
    // http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    // request.files.add(http.MultipartFile('file', cafe.getBytes(), await cafe.length(),
    //     filename: DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'));

    try {
      response = await Dio().post(debug ? debugUploadUrl + 'send' : uploadUrl + 'send', data: formData);
    } catch (e) {
      await EasyLoading.showError('Erro inesperado! \n ${e.toString()}', duration: const Duration(seconds: 5));
    } finally {
      await Future.delayed(const Duration(seconds: 1)).then((value) => EasyLoading.dismiss());

      await Future.delayed(const Duration(milliseconds: 600));

      if (response != null) {
        switch (response.statusCode) {
          case 200:
            EasyLoading.showSuccess('Enviado!', duration: const Duration(seconds: 2));

            roast.value = Roast.fromMap(response.data);
            break;

          case 400:
            await EasyLoading.showError('Arquivo não encontrado!', duration: const Duration(seconds: 2));
            break;

          case 403:
            await EasyLoading.showError('Arquivo inválido!', duration: const Duration(seconds: 2));
            break;

          default:
            await EasyLoading.showInfo('Algo deu errado.', duration: const Duration(seconds: 2));
        }
      }
    }
  }
}
