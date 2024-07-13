// TODO: 진행률 & ETA 계산, 서버로부터 결과물 수신, 다이얼로그 띄우기

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/attribute_controller.dart';
import '../config/gb_theme.dart';

class ComposeIng extends StatefulWidget {
  const ComposeIng({super.key});

  @override
  State<ComposeIng> createState() => _ComposeIngState();
}

class _ComposeIngState extends State<ComposeIng> {
  final AttributeController attributeController = Get.put(AttributeController());

  double progress = 0.5;
  String eta = "20:00";

  List<String> genre = ["rock", "hiphop", "jazz", "rnb", "reggae"];
  List<String> rhythm = ["디스코(DISCO)","고고(GOGO)", "슬로고고(Slow GOGO)", "스윙(SWING)", "락(ROCK)", "슬로락(Slow ROCK)", "탱고(TANGO)", "차차(CHACHA)", "왈츠(WALTZ)", "트롯(TROT)"];
  List<String> instruments = ["guitar", "bass_guitar", "keyboard", "drum", "synth", "classic_guitar", "piano", "trumpet", "sax", "violin", "cello", "organ"];
  List<String> kInstName = ["일렉 기타", "베이스 기타", "키보드", "드럼", "신디사이저", "클래식 기타", "피아노", "트럼펫", "색소폰", "바이올린", "첼로", "오르간"];
  List<String> kGenreName = ["락(Rock)", "힙합(Hiphop)", "재즈(Jazz)", "알앤비(Rnb)", "래게(Reggae)"];

  List<int?> instIndex = [];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    for (int i=0; i<instruments.length; i++) {
      if (attributeController.instruments[i]) {
        instIndex.add(i);
      }
    }
    print(instIndex);

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
                padding: EdgeInsets.symmetric(vertical: titlePaddingSize(screenWidth)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("AI 작곡",style: semiBold(fontSize1(screenWidth)),)
                ),
              ),
              Expanded(
                  child: Container(
                    decoration: gbBox(1),
                    child: Padding(
                      padding: EdgeInsets.only(top: composePaddingSize(screenWidth), left: menuPaddingSize(screenWidth), right: menuPaddingSize(screenWidth)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("원하시는 느낌의 새로운 곡을 만드는 중이에요!",style: semiBold(fontSize2(screenWidth)),),
                          SizedBox(height: screenHeight*0.04,),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("장르",style: semiBold(fontSize3(screenWidth)),),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage("assets/images/genre/${attributeController.genre}.png"),
                                                      fit: BoxFit.fitWidth
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                  border: Border.all(
                                                      color: const Color(0xFFE4E4E4),
                                                      width: 1
                                                  )
                                                )
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("리듬",style: semiBold(fontSize3(screenWidth)),),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                                              child: Container(
                                                width: screenWidth*0.3,
                                                decoration: gbBox(1),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children:[
                                                    Image.asset("assets/images/metronome.png",width: screenWidth*0.12,),
                                                    Text(attributeController.rhythm == "" ? attributeController.signature : attributeController.rhythm, style: semiBold(fontSize3(screenWidth)),),
                                                    Text(attributeController.rhythm == "" ? attributeController.bpm : "", style: semiBold(fontSize3(screenWidth)),),
                                                  ]
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("악기",style: semiBold(fontSize3(screenWidth)),),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  height: instIndex.length*50+90,
                                                  child: Stack(
                                                    children: List.generate(instIndex.length, (index) {
                                                      return Positioned(
                                                        left: index%2 * 50.0,
                                                        top: index * 50.0,
                                                        child: Container(
                                                          height: 140,
                                                          width: 250,
                                                          decoration: BoxDecoration(
                                                              color: const Color(0xFFFFFFFF),
                                                              image: DecorationImage(
                                                                image: AssetImage("assets/images/instruments/${instruments[instIndex[index]!]}.png"),
                                                                fit: BoxFit.cover,
                                                              ),
                                                              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                              border: Border.all(
                                                                  color: const Color(0xFFE4E4E4),
                                                                  width: 1
                                                              )
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                                    color: Color(0xffffffff).withOpacity(0.6)
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: composeGap(MediaQuery.of(context).size.width),
                                                                        vertical: composeGap(MediaQuery.of(context).size.width)
                                                                    ),
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.height*0.02,
                                                                      height: MediaQuery.of(context).size.height*0.02,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                          color: gbBlue
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(kInstName[instIndex[index]!],style: semiBold(fontSize3(MediaQuery.of(context).size.width)),)
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.02,),
                          Text("만들어진 음악 및 악보는 “메인메뉴>악보 확인/재생”에서 확인할 수 있어요!", style: semiBold(fontSize3(screenWidth)),),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: screenWidth*0.85,
                                  height: screenHeight*0.02,
                                  decoration: BoxDecoration(
                                      color: Color(0xffDBDBDB),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: screenWidth*0.85*progress,
                                  height: screenHeight*0.02,
                                  decoration: BoxDecoration(
                                      color: gbBlue,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("생성중...${100*progress}%", style: semiBold(fontSize3(screenWidth)),),
                              Text("예상 시간 $eta", style: semiBold(fontSize3(screenWidth)),)
                            ],
                          ),
                          SizedBox(height: screenHeight*0.03,),
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
