import 'dart:convert';
import 'dart:ui';

class Roast {
  Color color = const Color(0xFFFFF9F2);
  String prediction;
  String confidence;
  List<int> rgb;

  Roast({
    required this.color,
    required this.prediction,
    required this.confidence,
    required this.rgb,
  });

  Roast copyWith({
    Color? color,
    String? prediction,
    String? confidence,
    List<int>? rgb,
  }) {
    return Roast(
      color: color ?? this.color,
      prediction: prediction ?? this.prediction,
      confidence: confidence ?? this.confidence,
      rgb: rgb ?? this.rgb,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'color': color.value,
      'prediction': prediction,
      'confidence': confidence,
      'rgb': rgb,
    };
  }

  factory Roast.fromMap(Map<String, dynamic> map) {
    return Roast(
      color: Color.fromARGB(255, map['rgb'][0], map['rgb'][1], map['rgb'][2]),
      prediction: map['prediction'],
      confidence: map['confidence'],
      rgb: List<int>.from(map['rgb']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Roast.fromJson(String source) => Roast.fromMap(json.decode(source));
}
