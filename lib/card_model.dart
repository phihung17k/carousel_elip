import 'dart:typed_data';

import 'package:flutter/material.dart';

class CardModel {
  double? x;
  double? y;
  double? z;
  double? angle;
  double? rotateYAngle;
  Color? color;
  String? imagePath;
  Uint8List? imageByte;

  CardModel(
      {this.x,
      this.y,
      this.z,
      this.angle,
      this.rotateYAngle,
      this.color,
      this.imagePath,
      this.imageByte});
}
