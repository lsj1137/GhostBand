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
  late List<double> containerHeight = [MediaQuery.of(context).size.height*0.45, 0, 0];
  int currentQuestion = 0;

  void _expandContainer (int i) {
    setState(() {
      currentQuestion = i;
      for (var j=0; j<containerHeight.length; j++) {
        if (j==i) {
          containerHeight[j] = MediaQuery.of(context).size.height*0.45;
        } else {
          containerHeight[j] = 0;
        }
      }
    });
  }

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
                      padding: const EdgeInsets.only(top: 25.0, left: 25, right: 25.0),
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
                          SizedBox(height: 15,),
                          // 1번 질문
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: (){
                                _expandContainer(0);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: screenHeight*0.05,
                                    height: screenHeight*0.05,
                                    decoration: questionNum(),
                                    child: Align(
                                      alignment: Alignment.center,
                                        child: Text("1", style: semiBold(20),)
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("어떤 장르의 곡을 원하시나요?", style: semiBold(20),)
                                ],
                              ),
                            ),
                          ),
                          // 1번 질문 내용
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: containerHeight[0],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(width: screenHeight*0.025,),
                                  VerticalDivider(width: 0,color: Colors.black,thickness: 2,),
                                  SizedBox(width: screenHeight*0.025+10,),
                                  Visibility(
                                    visible: currentQuestion==0,
                                    child: Expanded(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          InkWell(
                                            onTap: (){},
                                            child: Image.asset("assets/images/genre/rock.png",width: screenWidth*0.2,),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: Image.asset("assets/images/genre/hiphop.png",width: screenWidth*0.2,),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: Image.asset("assets/images/genre/jazz.png",width: screenWidth*0.2,),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: Image.asset("assets/images/genre/rnb.png",width: screenWidth*0.2,),
                                          ),
                                          InkWell(
                                            onTap: (){},
                                            child: Image.asset("assets/images/genre/reggae.png",width: screenWidth*0.2,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 2번 질문
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: (){
                                _expandContainer(1);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: screenHeight*0.05,
                                    height: screenHeight*0.05,
                                    decoration: questionNum(),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("2", style: semiBold(20),)
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("어떤 리듬을 원하시나요? (박자, BPM)", style: semiBold(20),)
                                ],
                              ),
                            ),
                          ),
                          // 2번 질문 내용
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: containerHeight[1],
                            child: Row(
                              children: [
                                SizedBox(width: screenHeight*0.025,),
                                VerticalDivider(width: 0,color: Colors.black,thickness: 2,)
                              ],
                            ),
                          ),
                          // 3번 질문
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: (){
                                _expandContainer(2);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: screenHeight*0.05,
                                    height: screenHeight*0.05,
                                    decoration: questionNum(),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("3", style: semiBold(20),)
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("어떤 악기로 만들까요?", style: semiBold(20),)
                                ],
                              ),
                            ),
                          ),
                          // 3번 질문 내용
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: containerHeight[2],
                            child: Row(
                              children: [
                                SizedBox(width: screenHeight*0.025,),
                                VerticalDivider(width: 0,color: Colors.black,thickness: 2,)
                              ],
                            ),
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
