import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghost_band/config/attribute_controller.dart';
import 'package:ghost_band/screens/compose_ing.dart';
import 'package:intl/intl.dart';

import '../config/gb_theme.dart';

class AiCompose extends StatefulWidget {
  const AiCompose({super.key});

  @override
  State<AiCompose> createState() => _AiComposeState();
}

class _AiComposeState extends State<AiCompose> {
  final AttributeController attributeController = Get.put(AttributeController());

  bool composeReady = false;
  late List<double> containerHeight = [MediaQuery.of(context).size.height*0.45, 0, 0];
  int currentQuestion = 0;
  List<String> genre2 = ["new_age", "electronic", "rap", "religious", "international", "easy listening", "avant-garde", "RnB", "Latin", "children", "jazz", "classical", "comedy", "pop", "reggae", "stage", "folk", "blues", "vocal", "holiday", "country", "symphony"];
  List<String> genre = ["rock", "hiphop", "jazz", "rnb", "reggae"];
  List<String> instruments = ["guitar", "bass_guitar", "keyboard", "drum", "synth", "classic_guitar", "piano", "trumpet", "sax", "violin", "cello", "organ"];
  List<String> kInstName = ["일렉 기타", "베이스 기타", "키보드", "드럼", "신디사이저", "클래식 기타", "피아노", "트럼펫", "색소폰", "바이올린", "첼로", "오르간"];
  List<String> kGenreName = ["락(Rock)", "힙합(Hiphop)", "재즈(Jazz)", "알앤비(Rnb)", "래게(Reggae)"];
  List<String> timeSignature = ["4/4", "2/4", "3/4", "1/4", "6/8", "3/8", "other tempos"];
  List<String> bpms = ["천천히(<=76BPM)", "보통 빠르기로(76-120BPM)", "빠르게(>=120BPM)"];

  int selectedGenre = -1;
  List<bool> selectedInst = [false, false, false, false, false, false, false, false, false, false, false, false];
  String selectedGenreString = "";
  String selectedInstString = "";
  String selectedRhythmString = "";
  int selectedTimeSig = -1;
  int selectedBpm = -1;
  bool bpmSet = false;
  Map<String, dynamic> sendingData = {};

  late ScrollController _scrollController;

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

  void _selectGenre (int i) {
    setState(() {
      selectedGenre = i;
      selectedGenreString = "> ${kGenreName[i]}";
      attributeController.genre = genre[i];
    });
    isComposeReady();
    Future.delayed(const Duration(milliseconds: 250), (){
      _expandContainer((currentQuestion+1)%3);
    });
  }

  void _setBpm (int i, int j) {
    if (i==-1 || j==-1) {
      return;
    }
    setState(() {
      attributeController.signature = "${timeSignature[i]} 박자";
      attributeController.bpm = bpms[j];
      selectedRhythmString = "> ${timeSignature[i]} 박자 | ${bpms[j]}";
    });
    bpmSet = true;
    isComposeReady();
    Future.delayed(const Duration(milliseconds: 250), (){
      _expandContainer((currentQuestion + 1) % 3);
    });
  }

  void _selectInst (int i) {
    setState(() {
      selectedInst[i] = !selectedInst[i];
      attributeController.instruments = selectedInst;
      selectedInstString = "> ";
      for (int j=0; j<selectedInst.length; j++) {
        selectedInstString += selectedInst[j] ? "${kInstName[j]} / " : "";
      }
    });
    isComposeReady();
  }

  void isComposeReady() {
    setState(() {
      composeReady = selectedGenre!=-1 && bpmSet && selectedInst.contains(true);
    });
  }

  Map<String, dynamic> optionsToJson() {
    var insts = [];
    for (int i = 0; i<instruments.length; i++) {
      if(selectedInst[i]) {
        insts.add(instruments[i]);
      }
    }
    var bpm = selectedBpm==0 ? "slow" : selectedBpm==1 ? "moderate" : "fast";
    var currentTime = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    return {"selected_instruments": insts,
    "genre": genre[selectedGenre],
    "time_signature": timeSignature[selectedTimeSig],
    "playtime": "60",
    "bars": "16",
    "pitch_range": "5",
    "key": "C major",
    "tempo": bpm,
    "current_time": currentTime};
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("원하시는 느낌의 새로운 곡을 만들어볼게요!",style: semiBold(fontSize2(screenWidth)),),
                                InkWell(
                                  onTap: (){
                                    if (composeReady) {
                                      sendingData = optionsToJson();
                                      attributeController.sendingData = sendingData;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (
                                            context) => const ComposeIng(),),);
                                    }
                                  },
                                  child: startButton(screenWidth, composeReady, "작곡 시작"),
                                )
                              ],
                            ),
                            SizedBox(height: composeGap(screenWidth),),
                            SingleChildScrollView(
                              child: Column(
                                children: [

                                  // 1번 질문
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: composeQuestionGap(screenWidth)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            _expandContainer(0);
                                          },
                                          child: Row(
                                            children: [
                                              qNum(1, selectedGenre==-1),
                                              SizedBox(width: 15,),
                                              Text("어떤 장르의 곡을 원하시나요?", style: semiBold(fontSize3(screenWidth)),)
                                            ],
                                          ),
                                        ),
                                        Text(selectedGenreString, style: semiBold(fontSize3(screenWidth)),)
                                      ],
                                    ),
                                  ),

                                  // 1번 질문 내용
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: containerHeight[0],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: composeQuestionGap(screenWidth)),
                                      child: Row(
                                        children: [
                                          SizedBox(width: screenHeight*0.025,),
                                          VerticalDivider(width: 0,color: Colors.black,thickness: 2,),
                                          SizedBox(width: screenHeight*0.025+10,),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: genre.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(right: 4, top: selectedGenre!=index? 4:0, bottom: 6),
                                                  child: InkWell(
                                                    onTap: (){ _selectGenre(index); },
                                                    child: Container(
                                                        width: screenWidth*0.2,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage("assets/images/genre/${genre[index]}.png"),
                                                            fit: BoxFit.fitWidth
                                                          ),
                                                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                          border: selectedGenre==index ? Border.all(
                                                              color: const Color(0xFFFFFFFF),
                                                              width: 4
                                                          ) : Border.all(
                                                              color: const Color(0xFFE4E4E4),
                                                              width: 1
                                                          ),
                                                        boxShadow: selectedGenre==index ? [
                                                          BoxShadow(offset: Offset(1, 3),blurRadius: 2,color: Colors.black45)
                                                        ] : null,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // 2번 질문
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: composeQuestionGap(screenWidth)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            _expandContainer(1);
                                          },
                                          child: Row(
                                            children: [
                                              qNum(2, !bpmSet),
                                              SizedBox(width: 15,),
                                              Text("어떤 리듬을 원하시나요? (박자, BPM)", style: semiBold(fontSize3(screenWidth)),)
                                            ],
                                          ),
                                        ),
                                        Text(selectedRhythmString, style: semiBold(fontSize3(screenWidth)),)
                                      ],
                                    ),
                                  ),

                                  // 2번 질문 내용
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    height: containerHeight[1],
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenHeight*0.025,),
                                        const VerticalDivider(width: 0,color: Colors.black,thickness: 2,),
                                        SizedBox(width: screenHeight*0.025+10,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(child: Text("·  박자", style: semiBold(fontSize3(screenWidth)),)),
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 60,
                                                      child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: timeSignature.length,
                                                          itemBuilder: (context, index) {
                                                            return SizedBox(
                                                              width: screenWidth*0.11,
                                                              child: InkWell(
                                                                onTap: (){
                                                                  setState(() {
                                                                    selectedTimeSig = index;
                                                                  });
                                                                  _setBpm(selectedTimeSig, selectedBpm);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: composeGap(MediaQuery.of(context).size.width),
                                                                          vertical: composeGap(MediaQuery.of(context).size.width)
                                                                      ),
                                                                      child: Container(
                                                                        width: MediaQuery.of(context).size.height*0.02,
                                                                        height: MediaQuery.of(context).size.height*0.02,
                                                                        decoration: selectedTimeSig!=index ? questionNum() :
                                                                        BoxDecoration(
                                                                            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                                                            color: gbBlue
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(index!=6 ? "${timeSignature[index]}박자" : "그 외",style: semiBold(fontSize3(MediaQuery.of(context).size.width)),)
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Flexible(child: Text("·  BPM", style: semiBold(fontSize3(screenWidth)),)),
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 60,
                                                      child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: bpms.length,
                                                          itemBuilder: (context, index) {
                                                            return InkWell(
                                                              onTap: (){
                                                                setState(() {
                                                                  selectedBpm = index;
                                                                });
                                                                _setBpm(selectedTimeSig, selectedBpm);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: composeGap(MediaQuery.of(context).size.width),
                                                                        vertical: composeGap(MediaQuery.of(context).size.width)
                                                                    ),
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.height*0.02,
                                                                      height: MediaQuery.of(context).size.height*0.02,
                                                                      decoration: selectedBpm!=index ? questionNum() :
                                                                      BoxDecoration(
                                                                          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                                                          color: gbBlue
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(bpms[index],style: semiBold(fontSize3(MediaQuery.of(context).size.width)),)
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  // 3번 질문
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: composeQuestionGap(screenWidth)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            _expandContainer(2);
                                          },
                                          child: Row(
                                            children: [
                                              qNum(3, !selectedInst.contains(true)),
                                              SizedBox(width: 15,),
                                              Text("어떤 악기로 만들까요?", style: semiBold(fontSize3(screenWidth)),)
                                            ],
                                          ),
                                        ),
                                        Text(selectedInstString, style: semiBold(fontSize3(screenWidth)),)
                                      ],
                                    ),
                                  ),

                                  // 3번 질문 내용
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: containerHeight[2],
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenHeight*0.025,),
                                        VerticalDivider(width: 0,color: Colors.black,thickness: 2,),
                                        SizedBox(width: screenHeight*0.025+10,),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              instList(0),
                                              instList(1)
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
                SizedBox(height: menuPaddingSize(screenWidth),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget qNum (int i, bool notSelected) {
    return Container(
      width: MediaQuery.of(context).size.height*0.05,
      height: MediaQuery.of(context).size.height*0.05,
      decoration:
      notSelected ?
      questionNum() :
      BoxDecoration(
        color: gbBlue,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Align(
          alignment: Alignment.center,
          child: Text(notSelected ? "$i" : "√",
            style:notSelected ? semiBold(fontSize4(MediaQuery.of(context).size.width)) : TextStyle(color: Colors.white),
          )
      ),
    );
  }

  Widget instList(int startInd) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: instruments.length~/2,
            itemBuilder: (context, ind) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    _selectInst(ind*2+startInd);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        image: DecorationImage(
                          image: AssetImage("assets/images/instruments/${instruments[ind*2+startInd]}.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        border: Border.all(
                            color: const Color(0xFFE4E4E4),
                            width: 1
                        )
                    ),
                    width: 300,
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
                                decoration: !selectedInst[ind*2+startInd] ? questionNum() :
                                BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    color: gbBlue
                                ),
                              ),
                            ),
                            Text(kInstName[ind*2+startInd],style: semiBold(fontSize3(MediaQuery.of(context).size.width)),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }


}