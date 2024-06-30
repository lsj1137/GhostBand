import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghost_band/config/gb_theme.dart';
import 'package:ghost_band/screens/ai_compose.dart';
import 'package:ghost_band/widgets/main_drawer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<double> _instOpacities = [1.0, 0.1, 0.1];
  List<double> _noteOpacities = [1.0, 0.0, 0.0, 0.0, 0.0];
  int _currentInstIndex = 0;
  int _currentNoteIndex = 0;
  late Timer _instTimer;
  late Timer _noteTimer;

  @override
  void initState() {
    super.initState();
    _startInstAnimation();
    _startNoteAnimation();
  }

  @override
  void dispose() {
    _instTimer.cancel();
    _noteTimer.cancel();
    super.dispose();
  }

  void _startInstAnimation() {
    _instTimer = Timer.periodic(Duration(milliseconds: 900), (timer) {
      setState(() {
        _instOpacities[_currentInstIndex] = 0.1;
        _currentInstIndex = (_currentInstIndex + 1) % _instOpacities.length;
        _instOpacities[_currentInstIndex] = 1.0;
      });
    });
  }

  void _startNoteAnimation() {
    _noteTimer = Timer.periodic(Duration(milliseconds: 900), (timer) {
      setState(() {
        _currentNoteIndex = (_currentNoteIndex + 1) % _noteOpacities.length;
        _noteOpacities[_currentNoteIndex] = 1.0;
        if (_currentNoteIndex==0) {
          _noteOpacities = [1.0, 0.0, 0.0, 0.0, 0.0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const MainDrawer(),
      drawerScrimColor: Colors.transparent,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ghost Band",style: semiBold(40),),
                    InkWell(
                      onTap: (){
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                      child: Image.asset("assets/images/menu.png",width: screenWidth*0.03),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 100,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AiCompose(),),);
                              },
                              child: Container(
                                decoration: gbBox(0.8),
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("AI 작곡", style: semiBold(30),),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                            child: Stack(
                                                children: [
                                                  AnimatedOpacity(
                                                      opacity: _noteOpacities[0],
                                                      duration: const Duration(milliseconds: 900),
                                                      child: Image.asset("assets/images/compose00.png",height: screenHeight*0.15,)
                                                  ),
                                                  AnimatedOpacity(
                                                      opacity: _noteOpacities[1],
                                                      duration: const Duration(milliseconds: 900),
                                                      child: Image.asset("assets/images/compose01.png",height: screenHeight*0.15,)
                                                  ),
                                                  AnimatedOpacity(
                                                      opacity: _noteOpacities[2],
                                                      duration: const Duration(milliseconds: 900),
                                                      child: Image.asset("assets/images/compose02.png",height: screenHeight*0.15,)
                                                  ),
                                                  AnimatedOpacity(
                                                      opacity: _noteOpacities[3],
                                                      duration: const Duration(milliseconds: 900),
                                                      child: Image.asset("assets/images/compose03.png",height: screenHeight*0.15,)
                                                  ),
                                                  AnimatedOpacity(
                                                      opacity: _noteOpacities[4],
                                                      duration: const Duration(milliseconds: 900),
                                                      child: Image.asset("assets/images/compose04.png",height: screenHeight*0.15,)
                                                  ),
                                                  // AnimatedOpacity(
                                                  //     opacity: _noteOpacities[3],
                                                  //     duration: const Duration(milliseconds: 900),
                                                  //     child: Image.asset("assets/images/compose.png",height: screenHeight*0.15,)
                                                  // ),
                                                ]
                                            )
                                        ),
                                      ),
                                      Text("AI를 활용해 작곡하고 악보를 제공합니다.\n특정 악기의 곡만 생성하는 것도 가능합니다.", style: semiBold(20))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Expanded(
                            flex: 71,
                            child: InkWell(
                              onTap: (){},
                              child: Container(
                                decoration: gbBox(0.8),
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("악보 확인/재생", style: semiBold(30),),
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Image.asset("assets/images/play_score.png",height: screenHeight*0.12,)),
                                      ),
                                      Text("지금까지 만들어진 모든 악보를 확인/재생합니다.", style: semiBold(20))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 18,),
                        ],
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 71,
                              child: InkWell(
                                onTap: (){},
                                child: Container(
                                  width: screenWidth,
                                  decoration: gbBox(0.8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("악보 추출", style: semiBold(30),),
                                        Expanded(
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Image.asset("assets/images/adc_convert.png",height: screenHeight*0.12,)),
                                        ),
                                        Text("음원에서 악보를 추출합니다.", style: semiBold(20))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Expanded(
                              flex: 100,
                              child: InkWell(
                                onTap: (){},
                                child: Container(
                                  decoration: gbBox(0.8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("악기 소리 뮤트", style: semiBold(30),),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              AnimatedOpacity(
                                                  opacity: _instOpacities[0],
                                                  duration: const Duration(milliseconds: 900),
                                                  child: Image.asset("assets/images/guitar_icon.png", height: screenHeight*0.13,)
                                              ),
                                              AnimatedOpacity(
                                                opacity: _instOpacities[1],
                                                duration: const Duration(milliseconds: 900),
                                                child: Image.asset("assets/images/drum_icon.png", height: screenHeight*0.17,),
                                              ),
                                              AnimatedOpacity(
                                                opacity: _instOpacities[2],
                                                duration: const Duration(milliseconds: 900),
                                                child: Image.asset("assets/images/paino_icon.png", height: screenHeight*0.12,),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("음원에서 특정 악기의 소리를 뮤트시킵니다.", style: semiBold(20))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 18,),
                          ],
                        ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
