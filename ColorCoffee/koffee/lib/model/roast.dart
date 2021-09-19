import 'dart:convert';

import 'package:flutter/foundation.dart';

class Roast {
  String color;
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
    String? color,
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
      'color': color,
      'prediction': prediction,
      'confidence': confidence,
      'rgb': rgb,
    };
  }

  factory Roast.fromMap(Map<String, dynamic> map) {
    return Roast(
      color: map['color'],
      prediction: map['prediction'],
      confidence: map['confidence'],
      rgb: List<int>.from(map['rgb']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Roast.fromJson(String source) => Roast.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Roast(color: $color, prediction: $prediction, confidence: $confidence, rgb: $rgb)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Roast &&
      other.color == color &&
      other.prediction == prediction &&
      other.confidence == confidence &&
      listEquals(other.rgb, rgb);
  }

  @override
  int get hashCode {
    return color.hashCode ^
      prediction.hashCode ^
      confidence.hashCode ^
      rgb.hashCode;
  }
}
