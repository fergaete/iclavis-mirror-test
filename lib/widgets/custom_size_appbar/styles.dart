import 'package:flutter/material.dart';

class CustomSizeAppbarStyles {
  BoxDecoration containerDecoration(Color? backgroundColor) => BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 0,
          )
        ],
        color: backgroundColor ?? Colors.white,
      );
}
