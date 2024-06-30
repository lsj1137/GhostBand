import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/gb_theme.dart';

class AiCompose extends StatefulWidget {
  const AiCompose({super.key});

  @override
  State<AiCompose> createState() => _AiComposeState();
}

class _AiComposeState extends State<AiCompose> {
  bool composeReady = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/background_image.png"),fit: BoxFit.fitWidth,alignment: Alignment.topCenter),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: screenWidth*0.05,
            right: screenWidth*0.05
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("AI 작곡",style: semiBold(40),)
                ),
              ),
              Flexible(
                  child: Container(
                    decoration: gbBox(1),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("원하시는 느낌의 새로운 곡을 만들어볼게요!",style: semiBold(30),),
                              InkWell(
                                onTap: (){},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: composeReady ? Color(0xff0085D0) : Color(0xffB3B3B3)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/start.png", width: 20,),
                                        const SizedBox(width: 10,),
                                        const Text("작곡 시작", style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
