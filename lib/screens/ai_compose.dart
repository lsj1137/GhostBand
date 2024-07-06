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
  List<String> genre = ["rock", "hiphop", "jazz", "rnb", "reggae"];
  List<String> rhythm = ["디스코(DISCO)","고고(GOGO)", "슬로고고(Slow GOGO)", "스윙(SWING)", "락(ROCK)", "슬로락(Slow ROCK)", "탱고(TANGO)", "차차(CHACHA)", "왈츠(WALTZ)", "트롯(TROT)"];
  List<String> instruments = ["guitar", "bass_guitar", "keyboard", "drum", "synth", "classic_guitar", "piano", "trumpet", "sax", "violin", "cello", "organ"];
  List<String> kInstName = ["일렉 기타", "베이스 기타", "키보드", "드럼", "신디사이저", "클래식 기타", "피아노", "트럼펫", "색소폰", "바이올린", "첼로", "오르간"];

  int selectedGenre = -1;
  String selectedGenreString = "";
  List<bool> selectedInst = [false, false, false, false, false, false, false, false, false, false, false, false];
  String selectedInstString = "";
  int selectedRhythm = -1;
  String selectedRhythmString = "";
  bool bpmSet = false;
  int timeSignature1 = 0;
  int timeSignature2 = 0;
  int bpm = 0;

  late ScrollController _scrollController;
  late TextEditingController _rhythmController1;
  late TextEditingController _rhythmController2;
  late TextEditingController _rhythmController3;

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
    List<String> genreKorean = ["락(Rock)", "힙합(Hiphop)", "재즈(Jazz)", "알앤비(Rnb)", "래게(Reggae)"];
    setState(() {
      selectedGenre = i;
      selectedGenreString = "> ${genreKorean[i]}";
    });
    isComposeReady();
    Future.delayed(const Duration(milliseconds: 250), (){
      _expandContainer((currentQuestion+1)%3);
    });
  }

  void _selectRhythm (int i) {
    setState(() {
      selectedRhythm = i;
      _rhythmController1.text="";
      _rhythmController2.text="";
      _rhythmController3.text="";
      timeSignature1 = 0;
      timeSignature2 = 0;
      bpm = 0;
      bpmSet = false;
      selectedRhythmString = "> ${rhythm[i]}";
    });
    isComposeReady();
    Future.delayed(const Duration(milliseconds: 250), (){
      _expandContainer((currentQuestion+1)%3);
    });
  }

  void _setBpm () {
    setState(() {
      timeSignature1 = int.parse(_rhythmController1.text);
      timeSignature2 = int.parse(_rhythmController2.text);
      bpm = int.parse(_rhythmController3.text);
      selectedRhythm = -1;
      selectedRhythmString = "> ${timeSignature2} 분에 ${timeSignature1} 박자 / $bpm BPM";
    });
    if (timeSignature1!=0 && timeSignature2!=0 && bpm!=0) {
      bpmSet = true;
      isComposeReady();
      Future.delayed(const Duration(milliseconds: 250), (){
        _expandContainer((currentQuestion + 1) % 3);
      });
    }
  }

  void _selectInst (int i) {
    setState(() {
      selectedInst[i] = !selectedInst[i];
      selectedInstString = "> ";
      for (int j=0; j<selectedInst.length; j++) {
        selectedInstString += selectedInst[j] ? "${kInstName[j]} / " : "";
      }
    });
    isComposeReady();
  }

  void isComposeReady() {
    setState(() {
      composeReady = selectedGenre!=-1 && (selectedRhythm!=-1 || bpmSet) && selectedInst.contains(true);
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _rhythmController1 = TextEditingController();
    _rhythmController2 = TextEditingController();
    _rhythmController3 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _rhythmController1.dispose();
    _rhythmController2.dispose();
    _rhythmController3.dispose();
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

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: composeReady ? Color(0xff0085D0) : Color(0xffB3B3B3)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: composeButtonPaddingV(screenWidth),horizontal: composeButtonPaddingH(screenWidth)),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/images/start.png", width: fontSize3(screenWidth),),
                                          const SizedBox(width: 10,),
                                          Text("작곡 시작", style: TextStyle(
                                            fontSize: fontSize3(screenWidth),
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
                                              qNum(2, selectedRhythm==-1 && !bpmSet),
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
                                              Expanded(
                                                flex: 1,
                                                child: Text("·  리듬 선택하기", style: semiBold(fontSize3(screenWidth)),)
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Container(
                                                  decoration: gbBox(1),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(composeButtonPaddingH(screenWidth)),
                                                    child: MediaQuery.removePadding(
                                                      context: context,
                                                      removeTop: true,
                                                      child: Scrollbar(
                                                        controller: _scrollController,
                                                        thumbVisibility: true,
                                                        radius: const Radius.circular(2),
                                                        child: ListView.builder(
                                                          controller: _scrollController,
                                                          padding: EdgeInsets.zero,
                                                          itemCount: rhythm.length,
                                                          itemBuilder: (context, index){
                                                            return Padding(
                                                              padding: const EdgeInsets.all(3.0),
                                                              child: InkWell(
                                                                onTap: (){
                                                                  _selectRhythm(index);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: screenHeight*0.02,
                                                                      height: screenHeight*0.02,
                                                                      decoration: selectedRhythm!=index ? questionNum():
                                                                        const BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                                          color: Color(0xff0085D0)
                                                                        ),
                                                                    ),
                                                                    const SizedBox(width: 10,),
                                                                    Text(rhythm[index],style: semiBold(fontSize3(screenWidth)),)
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                        }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: screenWidth*0.035,),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Text("·  박자와 BPM 선택하기", style: semiBold(fontSize3(screenWidth)),)
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        children: [
                                                          rhythmField(screenHeight*0.1, screenHeight*0.1, _rhythmController1,2),
                                                          Text(" / ",style:TextStyle(fontSize: fontSize3(screenWidth)*2),),
                                                          rhythmField(screenHeight*0.1, screenHeight*0.1, _rhythmController2,2),
                                                          Text(" 박자",style:semiBold(fontSize3(screenWidth)),),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Flexible(
                                                      child: Row(
                                                        children: [
                                                          rhythmField(screenHeight*0.24, screenHeight*0.11, _rhythmController3,3),
                                                          Text(" BPM",style: semiBold(fontSize3(screenWidth)),),
                                                        ],
                                                      ),
                                                    ),
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
        color: Color(0xff0085D0),
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
                                const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                    color: Color(0xff0085D0)
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

  Widget rhythmField (w, h, controller, maxLen) {
    return Container(
      width: w,
      height: h,
      decoration: gbBox(1),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,
          maxLength: maxLen,
          decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: ''
          ),
          style: TextStyle(
              fontSize: fontSize2(MediaQuery.of(context).size.width)
          ),
          textAlign: TextAlign.center,
          onSubmitted: (value) {
            _setBpm();
          }
        ),
      ),
    );
  }

}