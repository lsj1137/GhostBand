import 'package:flutter/material.dart';

BoxDecoration gbBox (double opacity) {
  return BoxDecoration(
    color: const Color(0xFFFFFFFF).withOpacity(opacity),
    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
    border: Border.all(
        color: const Color(0xFFE4E4E4),
        width: 1
    )
  );
}

BoxDecoration questionNum () {
  return BoxDecoration(
      color: const Color(0xFFFFFFFF),
      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      border: Border.all(
          color: const Color(0xFF000000),
          width: 2
      )
  );
}

TextStyle semiBold (double size) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w600,
  );
}