import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ghost_band/screens/main_menu.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../config/attribute_controller.dart';
import '../config/gb_theme.dart';
import 'check_score.dart';

class ComposeIng extends StatefulWidget {
  const ComposeIng({super.key});

  @override
  State<ComposeIng> createState() => _ComposeIngState();
}

class _ComposeIngState extends State<ComposeIng> {
  final AttributeController attributeController = Get.put(AttributeController());
  final Dio _dio = Dio();
  CancelToken? cancelToken;
  late Timer _timer1;
  late Timer _timer2;
  double _counter = 0;
  final int _updateIntervalInSeconds = (12 * 60) ~/ 100;

  double progress = 0;
  String eta = "";
  int etaS = 60*12;

  List<String> genre = ["pop", "rnb", "rap", "jazz", "blues", "electronic", "folk", "reggae", "country", "new_age", "latin", "religious", "classic", "children"];
  List<String> rhythm = ["디스코(DISCO)","고고(GOGO)", "슬로고고(Slow GOGO)", "스윙(SWING)", "락(ROCK)", "슬로락(Slow ROCK)", "탱고(TANGO)", "차차(CHACHA)", "왈츠(WALTZ)", "트롯(TROT)"];
  List<String> instruments = ["guitar", "bass_guitar", "keyboard", "drum", "synth", "classic_guitar", "piano", "trumpet", "sax", "violin", "cello", "organ", "ETC"];
  List<String> kInstName = ["일렉 기타", "베이스 기타", "키보드", "드럼", "신디사이저", "클래식 기타", "피아노", "트럼펫", "색소폰", "바이올린", "첼로", "오르간", "그 외"];
  List<String> kGenreName = ["팝", "알앤비", "랩", "재즈", "블루스", "일렉트로닉", "포크", "레게", "컨츄리", "뉴에이지", "라틴", "종교음악", "클래식", "동요" ];

  List<int?> instIndex = [];
  List<dynamic> fileUrls = [];

  Future<void> _sendPostRequest(data) async {
    const String url = 'http://220.149.232.226:5005/run_model';
    // http://220.149.232.224:5005/run_model
    // http://220.149.232.224:5001/test_model
    // http://220.149.232.226:5005/run_model
    // http://220.149.232.226:5001/run_model
    // http://220.149.232.226:5005/stop_process
    // final Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    // };
    cancelToken = CancelToken();

    try {
      if (kDebugMode) {
        print(data);
      }
      final response = await _dio.post(url, data: data,cancelToken: cancelToken);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
      fileUrls = response.data['file_urls'];
      _downloadFile();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (kDebugMode) {
          print("Request canceled: $e");
        }
      } else {
        if (kDebugMode) {
          print("Error uploading file: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected Error: $e");
      }
    }
  }

  void _cancelPost() {
    if (cancelToken != null && !cancelToken!.isCancelled) {
      cancelToken!.cancel("Upload canceled by user");
    }
  }

  void _cancelGenerating() async {
    const String url = 'http://220.149.232.226:5005/stop_process';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await _dio.post(url, data: {}, options: Options(headers: headers,));
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (kDebugMode) {
          print("Request canceled: $e");
        }
      } else {
        if (kDebugMode) {
          print("Error uploading file: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected Error: $e");
      }
    }
  }

  Future<void> _downloadFile() async {
    final String midiUrl = fileUrls[0]; // 다운로드할 파일의 URL
    final String scoreUrl = fileUrls[1]; // 다운로드할 파일의 URL
    final String midiFileName = midiUrl.split('/').last; // 로컬 저장소에 저장할 파일 이름
    final String scoreFileName = scoreUrl.split('/').last;

    try {
      // 로컬 저장소 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final metadataPath = '${directory.path}/compose_results/${attributeController.sendingData['current_time']}/meta.txt';
      final midiFilePath = '${directory.path}/compose_results/${attributeController.sendingData['current_time']}/$midiFileName';
      final scoreFilePath = '${directory.path}/compose_results/${attributeController.sendingData['current_time']}/$scoreFileName';
      double tempProgress = 0;

      final metaFile = File(metadataPath);
      if (!(await metaFile.parent.exists())) {
        await metaFile.parent.create(recursive: true);
      }
      await metaFile.writeAsString(instIndex.join(','));

      // 파일 다운로드
      final response1 = await _dio.download(midiUrl, midiFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              tempProgress = received / total / 2;
              progress = max(_counter, tempProgress);
            });
            if (kDebugMode) {
              print('Midi Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
            }
          }
        },
      );
      if (kDebugMode) {
        print('Midi File saved to: $midiFilePath');
      }

      setState(() {
        progress = max(_counter, tempProgress);
      });

      final response2 = await _dio.download(scoreUrl, scoreFilePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              tempProgress = 0.5 + received / total / 2;
              progress = max(_counter, tempProgress);
            });
            if (kDebugMode) {
              print('Score Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
            }
          }
        },
      );
      if (kDebugMode) {
        print('Score File saved to: $scoreFilePath');
      }

      if (response1.statusCode==200 && response2.statusCode==200) {
        setState(() {
          etaS = 0;
          eta = '0:0';
        });
        _completeAlert();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _completeAlert () {
    showDialog( context: context,
        // 다이얼로그 바깥영역 터치 설정
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              decoration: dialogContentDeco,
              height: MediaQuery.of(context).size.height*0.33,
              width: MediaQuery.of(context).size.width*0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("곡이 완성되었어요!", style: semiBold(fontSize2(context))),
                  SizedBox(height: MediaQuery.of(context).size.height*0.04),
                  Text("지금 바로 확인하러 가볼까요?", style: semiBold(fontSize2(context))),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.zero,
            actions: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainMenu(),), (route) => false);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.13,
                        decoration: dialogActionDeco1,
                        child: Center(
                          child: Text("취소(홈으로)", style: semiBold(fontSize2(context))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CheckScore(),));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.13,
                        decoration: dialogActionDeco2,
                        child: Center(
                          child: Text("확인", style: semiBold(fontSize2(context)).apply(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  void _cancelAlert () {
    showDialog( context: context,
        // 다이얼로그 바깥영역 터치 설정
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              decoration: dialogContentDeco,
              height: MediaQuery.of(context).size.height*0.33,
              width: MediaQuery.of(context).size.width*0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("곡이 생성중이에요!", style: semiBold(fontSize2(context))),
                  SizedBox(height: MediaQuery.of(context).size.height*0.04),
                  Text("취소하고 돌아갈까요?", style: semiBold(fontSize2(context))),
                ],
              ),
            ),
            actionsPadding: EdgeInsets.zero,
            actions: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.13,
                        decoration: dialogActionDeco1,
                        child: Center(
                          child: Text("계속 생성", style: semiBold(fontSize2(context))),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _cancelPost();
                        _cancelGenerating();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const MainMenu(),),(route)=> false);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.13,
                        decoration: dialogActionDeco2,
                        child: Center(
                          child: Text("생성 취소", style: semiBold(fontSize2(context)).apply(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    WakelockPlus.enable();

    _timer1 = Timer.periodic(Duration(seconds: _updateIntervalInSeconds), (timer){
      setState(() {
        if (_counter < 0.99) {
          _counter += 0.01;
          progress = max(progress, _counter);
        } else {
          timer.cancel();
        }
      });
    });


    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer){
      setState(() {
        if (etaS>0) {
          etaS -= 1;
          eta = '${etaS~/60}:${etaS%60}';
        } else {
          timer.cancel();
        }
      });
    });

    for (int i=0; i<attributeController.instruments.length; i++) {
      if (attributeController.instruments[i]) {
        instIndex.add(i);
      }
    }
    if (kDebugMode) {
      print(instIndex);
    }

    // 만들기 요청 전송
    _sendPostRequest(attributeController.sendingData);

    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();

    if (_timer1.isActive) {
      _timer1.cancel();
    }
    if (_timer2.isActive) {
      _timer2.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          _cancelAlert();
        },
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
                  padding: EdgeInsets.symmetric(vertical: titlePaddingSize(context)),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("AI 작곡",style: semiBold(fontSize1(context)),)
                  ),
                ),
                Expanded(
                    child: Container(
                      decoration: gbBox(1),
                      child: Padding(
                        padding: EdgeInsets.only(top: composePaddingSize(context), left: menuPaddingSize(context), right: menuPaddingSize(context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("원하시는 느낌의 새로운 곡을 만드는 중이에요!",style: semiBold(fontSize2(context)),),
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
                                            Text("장르",style: semiBold(fontSize3(context)),),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
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
                                            Text("리듬",style: semiBold(fontSize3(context)),),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
                                                child: Container(
                                                  width: screenWidth*0.3,
                                                  decoration: gbBox(1),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children:[
                                                      Image.asset("assets/images/metronome.png",height: screenHeight*0.13,),
                                                      Text(attributeController.signature, style: semiBold(fontSize4(context)),),
                                                      Text(attributeController.bpm, style: semiBold(fontSize4(context)),),
                                                      Text(attributeController.key, style: semiBold(fontSize4(context)),),
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
                                            Text("악기",style: semiBold(fontSize3(context)),),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: screenHeight*0.02),
                                                child: SingleChildScrollView(
                                                  child: SizedBox(
                                                    height: (instIndex.length-1)*(screenHeight*0.07)+(screenHeight*0.18),
                                                    child: Stack(
                                                      children: List.generate(instIndex.length, (index) {
                                                        return Positioned(
                                                          left: index%2 * (screenHeight*0.1),
                                                          top: index * (screenHeight*0.07),
                                                          child: Container(
                                                            height: screenHeight*0.18,
                                                            width: screenWidth*0.17,
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
                                                                      color: const Color(0xffffffff).withOpacity(0.6)
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: composeButtonPaddingH(context),
                                                                          vertical: composeButtonPaddingH(context)
                                                                      ),
                                                                      child: Container(
                                                                        width: MediaQuery.of(context).size.height*0.02,
                                                                        height: MediaQuery.of(context).size.height*0.02,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                                                            color: gbBlue
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(kInstName[instIndex[index]!],style: semiBold(fontSize3(context)),)
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
                            Text("만들어진 음악 및 악보는 “메인메뉴>악보 확인/재생”에서 확인할 수 있어요!", style: semiBold(fontSize3(context)),),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: screenWidth*0.85,
                                    height: screenHeight*0.02,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffDBDBDB),
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
                                Text("생성중...${(100*progress).toStringAsFixed(0)}%", style: semiBold(fontSize3(context)),),
                                Text("예상 시간 $eta", style: semiBold(fontSize3(context)),)
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
      ),
    );
  }
}
