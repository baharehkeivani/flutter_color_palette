import 'package:flutter/material.dart';

class GradientStyle {
  AlignmentGeometry start;
  AlignmentGeometry end;

  GradientStyle(this.start, this.end);
}

List<GradientStyle> gradientStyles = [
  GradientStyle(Alignment.topCenter, Alignment.bottomCenter), //transverse |
  GradientStyle(Alignment.topLeft, Alignment.bottomRight), // diagonal \
  GradientStyle(Alignment.centerLeft, Alignment.centerRight), // longitudinal --
];

