import 'package:flutter/material.dart';
import 'package:ghost_band/config/gb_theme.dart';

typedef OnCheckChange = void Function(bool isShow);

// ignore: must_be_immutable
class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    super.key,
    required this.onCheckChange,
  });

  OnCheckChange onCheckChange;
  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  final duration = Duration(milliseconds: 100);
  final width = 70.0, height = 39.0;
  final ballSize = 35.0, ballPadding = 2.0;

  bool isChecked = true;
  Color switchColor = gbBlue;
  double switchLeft = 70-35-2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: duration,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: switchColor,
          borderRadius: BorderRadius.all(Radius.circular(height/2)),
        ),
        child: renderSwitchBall(),
      ),
      onTap: () {
        isChecked = !isChecked;

        if (isChecked) {
          switchColor = gbBlue;
          switchLeft = (width - ballSize) - ballPadding;
        } else {
          switchColor = Color(0xffe2e2e2);
          switchLeft = ballPadding;
        }

        widget.onCheckChange(isChecked);

        setState(() {});
      },
    );
  }

  renderSwitchBall() {
    final ballRadius = ballSize / 2;

    return Stack(
      children: [
        AnimatedPositioned(
          duration: duration,
          top: 2,
          left: switchLeft,
          child: Container(
            width: ballSize,
            height: ballSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(ballRadius),
              ),
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}