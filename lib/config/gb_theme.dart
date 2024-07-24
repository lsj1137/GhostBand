import 'package:flutter/material.dart';

double fontSize1(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 40;
  } else {
    return 25;
  }
}

double fontSize2(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 30;
  } else {
    return 18;
  }
}

double fontSize3(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 20;
  } else {
    return 15;
  }
}

double fontSize4(BuildContext context){
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 18;
  } else {
    return 11;
  }
}

double fontSize5(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 500){
    return 16;
  } else {
    return 11;
  }
}


double titlePaddingSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 18;
  } else {
    return 10;
  }
}

double menuPaddingSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 30;
  } else {
    return 15;
  }
}

double menuGap(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 15;
  } else {
    return 7;
  }
}


double composePaddingSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 30;
  } else {
    return 12;
  }
}

double composeButtonPaddingH(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 15;
  } else {
    return 7;
  }
}
double composeButtonPaddingV(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 8;
  } else {
    return 3;
  }
}

double composeGap(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 15;
  } else {
    return 0;
  }
}

double composeQuestionGap(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 1000){
    return 10;
  } else {
    return 3;
  }
}


double scorePageGap(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  if (height > 1000){
    return 19;
  } else {
    return 5.5;
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

Widget startButton (BuildContext context, bool condition, String name) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: condition ? gbBlue : const Color(0xffB3B3B3)
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: composeButtonPaddingV(context),horizontal: composeButtonPaddingH(context)),
      child: Row(
        children: [
          Image.asset("assets/images/start.png", width: fontSize3(context),),
          const SizedBox(width: 10,),
          Text(name, style: TextStyle(
              fontSize: fontSize3(context),
              fontWeight: FontWeight.w600,
              color: Colors.white),
          )
        ],
      ),
    ),
  );
}


// 다이얼로그 디자인 (위쪽)
BoxDecoration dialogContentDeco = const BoxDecoration(
  boxShadow: null,
  border: Border(bottom: BorderSide(
      color: Color(0xffE4E4E4), width: 1)),
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20)),
  color: Colors.white,
);

// 다이얼로그 디자인 (왼쪽 아래)
BoxDecoration dialogActionDeco1 = const BoxDecoration(
  borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),),
  color: Colors.white,
);

// 다이얼로그 디자인 (오른쪽 아래쪽)
BoxDecoration dialogActionDeco2 = BoxDecoration(
  borderRadius: const BorderRadius.only(
      bottomRight: Radius.circular(20)),
  color: gbBlue,
);

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
