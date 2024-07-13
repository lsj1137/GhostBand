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

BoxDecoration gbBox (double opacity, {double boxSize = -1}) {
  return BoxDecoration(
    color: const Color(0xFFFFFFFF).withOpacity(opacity),
    borderRadius: BorderRadius.all(Radius.circular(boxSize==-1 ? 30.0 : boxSize)),
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

Widget startButton (double screenWidth, bool condition, String name) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: condition ? gbBlue : Color(0xffB3B3B3)
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: composeButtonPaddingV(screenWidth),horizontal: composeButtonPaddingH(screenWidth)),
      child: Row(
        children: [
          Image.asset("assets/images/start.png", width: fontSize3(screenWidth),),
          const SizedBox(width: 10,),
          Text(name, style: TextStyle(
              fontSize: fontSize3(screenWidth),
              fontWeight: FontWeight.w600,
              color: Colors.white),
          )
        ],
      ),
    ),
  );
}

TextStyle semiBold (double size) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w600,
  );
}


TextStyle normal (double size) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.w400,
  );
}

Color gbBlue = const Color(0xff0085D0);
