import 'dart:io';
import 'package:color/color.dart';
import 'package:csv/csv.dart';
import 'package:image/image.dart' as img;
import 'package:collection/collection.dart';

Future<Map> getColorSpace(File image, String agtronValue) async {
  List<num> redBucket = [];
  List<num> greenBucket = [];
  List<num> blueBucket = [];

  List<num> hBucket = [];
  List<num> sBucket = [];
  List<num> vBucket = [];

  img.Image? bitmap = img.decodeImage(image.readAsBytesSync());
  if (bitmap != null) {
    for (int y = 0; y < bitmap.height; y++) {
      for (int x = 0; x < bitmap.width; x++) {
        int c = bitmap.getPixel(x, y);
        int redAux = img.getRed(c);
        int greenAux = img.getGreen(c);
        int blueAux = img.getBlue(c);

        redBucket.add(redAux);
        greenBucket.add(greenAux);
        blueBucket.add(blueAux);

        HsvColor hsv = RgbColor(redAux, greenAux, blueAux).toHsvColor();
        hBucket.add(hsv.h);
        sBucket.add(hsv.s);
        vBucket.add(hsv.v);
      }
    }
  }

  RgbColor rgb = RgbColor(redBucket.average.round(),
      greenBucket.average.round(), blueBucket.average.round());
  HsvColor hsv = HsvColor(hBucket.average, sBucket.average, vBucket.average);

  // print('rgb to hsv: ${rgb.toHsvColor()}');
  // print('rgb: $rgb');
  // print('hsv: $hsv');

  num gray = ((0.299 * rgb.r) + (0.587 * rgb.g) + (0.114 * rgb.b));

  Map colorInformation = {
    'r': rgb.r.round(),
    'g': rgb.g.round(),
    'b': rgb.b.round(),
    'h': hsv.h.round(),
    's': hsv.s.round(),
    'v': hsv.v.round(),
    'gray': gray.toStringAsFixed(2)
  };

  if (agtronValue != 'fl') {
    print('${colorInformation} -> $agtronValue');
  }
  return colorInformation;
}

Future<void> createCSV(List<List<dynamic>> listInformation, String name) async {
  String csv = const ListToCsvConverter().convert(listInformation);
  final pathOfTheFileToWrite = ".\\Database\\$name.csv";
  File file = File(pathOfTheFileToWrite);
  file.writeAsString(csv);
}

main() async {
  /// Padrão de nomes XXX_ZZZ_YY.png
  /// XXX Modelo do equipamento
  /// ZZZ Condição de iluminação
  /// YY Valor Agtron

  // Aplicar equalização de histograma
  // 	- Imagem com branco
  // 	- Imagem sem branco

  // Ver se equalização de histograma é igual em com branco e sem branco. (Diferença muito sútil, pode usar o corte exato!)

  // Pegar o melhor, aplicar equalização em todas.

  // Extrair informações

  final dir = Directory('.\\Imagens1111');
  List contents = dir.listSync();
  List<List<dynamic>> grayList = [
    ['Gray-medio', 'Gray-papel', 'Agtron']
  ];
  List<List<dynamic>> hsvList = [
    ['H-medio', 'S-medio', 'V-medio', 'S-papel', 'V-papel', 'Agtron']
  ];
  List<List<dynamic>> rgbList = [
    ['R-medio', 'G-medio', 'B-medio', 'S-papel', 'V-papel', 'Agtron']
  ];

  for (File element in contents) {
    String patternName = element.uri.toString().substring(0, 16);
    String lightingCondition = element.uri.toString().substring(16, 19);
    String sampleNumber = element.uri.toString().substring(23, 24);
    String agtronValue = element.uri.toString().substring(20, 22);

    File img = element;
    File img_paper = contents.firstWhere((element) => element.uri
        .toString()
        .contains('${patternName}${lightingCondition}_fl_${sampleNumber}'));

    if (!img.uri
        .toString()
        .contains('${patternName}${lightingCondition}_fl_${sampleNumber}')) {
      Map colorInformation = await getColorSpace(img, agtronValue);
      Map paperInformation = await getColorSpace(img_paper, 'fl');

      List<dynamic> itemGray = [];
      List<dynamic> itemHSV = [];
      List<dynamic> itemRGB = [];

      itemGray.add(colorInformation['gray']);
      itemGray.add(paperInformation['gray']);

      itemHSV.add(colorInformation['h']);
      itemHSV.add(colorInformation['s']);
      itemHSV.add(colorInformation['v']);

      // itemHSV.add(paperInformation['h']);
      itemHSV.add(paperInformation['s']);
      itemHSV.add(paperInformation['v']);

      itemRGB.add(colorInformation['r']);
      itemRGB.add(colorInformation['g']);
      itemRGB.add(colorInformation['b']);

      // itemRGB.add(paperInformation['r']);
      itemRGB.add(paperInformation['s']);
      itemRGB.add(paperInformation['v']);

      itemGray.add(agtronValue);
      itemHSV.add(agtronValue);
      itemRGB.add(agtronValue);

      grayList.add(itemGray);
      hsvList.add(itemHSV);
      rgbList.add(itemRGB);
    }

    createCSV(grayList, 'grayData');
    createCSV(hsvList, 'hsvData');
    createCSV(rgbList, 'rgbData');
  }
}
