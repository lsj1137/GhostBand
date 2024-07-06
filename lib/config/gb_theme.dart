import 'package:flutter/material.dart';

double fontSize1(double width){
  if (width > 1000){
    return 40;
  } else {
    return 25;
  }
}

double fontSize2(double width){
  if (width > 1000){
    return 30;
  } else {
    return 18;
  }
}

double fontSize3(double width){
  if (width > 1000){
    return 20;
  } else {
    return 15;
  }
}

double fontSize4(double width){
  if (width > 1000){
    return 20;
  } else {
    return 10;
  }
}
double titlePaddingSize(double width) {
  if (width > 1000){
    return 18;
  } else {
    return 10;
  }
}

double menuPaddingSize(double width) {
  if (width > 1000){
    return 30;
  } else {
    return 15;
  }
}

double menuGap(double width) {
  if (width > 1000){
    return 15;
  } else {
    return 7;
  }
}


double composePaddingSize(double width) {
  if (width > 1000){
    return 30;
  } else {
    return 12;
  }
}

double composeButtonPaddingH(double width) {
  if (width > 1000){
    return 15;
  } else {
    return 7;
  }
}
double composeButtonPaddingV(double width) {
  if (width > 1000){
    return 8;
  } else {
    return 3;
  }
}

double composeGap(double width) {
  if (width > 1000){
    return 15;
  } else {
    return 0;
  }
}

double composeQuestionGap(double width) {
  if (width > 1000){
    return 10;
  } else {
    return 3;
  }
}

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