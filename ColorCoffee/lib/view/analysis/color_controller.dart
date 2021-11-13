import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:color/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import '../../model/roast.dart';

class ColorControll {
  static const uploadUrl = 'https://real-color-coffee.herokuapp.com/';

  final ValueNotifier<Roast?> roast = ValueNotifier<Roast?>(null);

  Future<void> getRandomColor() async {
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(uploadUrl + 'random'),
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
      }
    }
  }

  Future<RgbColor> getAvarageRGBColor(File image) async {
    // Flutter
    // r: 92, g: 133, b: 184
    // h: 213.2608695652174, s: 50.0%, v: 72.15686274509804%
    // (0.5923913043478262, 0.5, 184)
    // Python
    // r: 92, g: 133, b:  184
    // h: 108, s: 133, v: 184

    int redBucket = 0;
    int greenBucket = 0;
    int blueBucket = 0;
    int pixelCount = 0;

    img.Image? bitmap = img.decodeImage(image.readAsBytesSync());
    if (bitmap != null) {
      for (int y = 0; y < bitmap.height; y++) {
        for (int x = 0; x < bitmap.width; x++) {
          int c = bitmap.getPixel(x, y);

          pixelCount++;
          redBucket += img.getRed(c);
          greenBucket += img.getGreen(c);
          blueBucket += img.getBlue(c);
        }
      }
    }
    RgbColor rgb = RgbColor(redBucket ~/ pixelCount, greenBucket ~/ pixelCount,
        blueBucket ~/ pixelCount);

    return rgb;
  }

  Future<void> uploadColorToServer(File image) async {
    EasyLoading.show(status: 'Enviando...');

    RgbColor rgb = await getAvarageRGBColor(image);

    HsvColor hsv = rgb.toHsvColor();

    http.Response? response;

    try {
      response = await http.post(
        Uri.parse(uploadUrl + 'analisys'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'r': '${rgb.r}',
          'g': '${rgb.g}',
          'b': '${rgb.b}',
          'h': '${hsv.h}',
          's': '${hsv.s}',
          'v': '${hsv.v}'
        }),
      );
    } catch (e) {
      await EasyLoading.showError('Erro inesperado! \n ${e.toString()}',
          duration: const Duration(seconds: 2));
    } finally {
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => EasyLoading.dismiss());

      if (response != null) {
        switch (response.statusCode) {
          case 200:
            EasyLoading.showSuccess('Enviado!',
                duration: const Duration(seconds: 2));

            roast.value = Roast.fromJson(response.body);
            break;

          default:
            await EasyLoading.showInfo('Algo deu errado.',
                duration: const Duration(seconds: 2));
        }
      }
    }
  }

  Future<void> uploadImageToServer(File image) async {
    EasyLoading.show(status: 'Enviando...');

    http.StreamedResponse? streamedResponse;

    Uri postUri = Uri.parse(uploadUrl + 'send');
    http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    request.files.add(http.MultipartFile(
        'file', image.readAsBytes().asStream(), await image.length(),
        filename: DateTime.now().millisecondsSinceEpoch.toString() + '.png'));

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
