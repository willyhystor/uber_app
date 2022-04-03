import 'package:flutter/material.dart';

class MaterialStateUtility {
  // Border State
  static OutlinedBorder getOutlinedBorder(Set<MaterialState> states) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    );
  }

  static Color getButtonColor(Set<MaterialState> states) {
    return Colors.yellow.withOpacity(0.8);
  }
}
