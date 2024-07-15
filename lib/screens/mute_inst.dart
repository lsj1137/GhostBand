import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import '../config/custom_switch.dart';
import '../config/gb_theme.dart';

class MuteInst extends StatefulWidget {
  const MuteInst({super.key});

  @override
  State<MuteInst> createState() => _MuteInstState();
}

class _MuteInstState extends State<MuteInst> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<AudioPlayer> players = [AudioPlayer(), AudioPlayer(), AudioPlayer(), AudioPlayer(), AudioPlayer()];
  // 0:bass, 1:drum, 2:piano, 3:vocal, 4:others
  late AnimationController _animationController;
  final Dio _dio = Dio();

  String url = 'http://220.149.232.226:5010';
  List<dynamic> fileUrls = [];
  double progress = 0;
  double tempProgress = 0;
  double totalProgress = 0;

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String _localFilePath = '';
  List<String> filePaths = [];

  bool fileReady = false;
  bool analyseStart = false;
  bool analyseDone = false;
  List<bool> instChecked = [true, true, true, true, true];

  Future<String> _uploadFile() async {
    String fileName = _localFilePath.split('/').last; // 파일 이름 추출
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        _localFilePath,
        filename: fileName,
      ),
    });

    try {
      Response response = await _dio.post('$url/separator', data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      // 업로드 성공 시 처리
      print("Upload successful: ${response.data}");
      fileUrls = response.data['file_urls'];
      print(fileUrls);
      analyseFile();
      return response.statusCode.toString();
    } catch (e) {
      // 오류 처리
      print("Error uploading file: $e");
      return e.toString();
    }
  }

  Future<void> analyseFile() async {
    final String vocalUrl = fileUrls[0]; // 다운로드할 파일의 URL
    final String pianoUrl = fileUrls[1];
    final String drumsUrl = fileUrls[2];
    final String otherUrl = fileUrls[3];
    final String bassUrl = fileUrls[4];
    const String vocalFileName = 'vocal.wav';
    const String pianoFileName = 'piano.wav';
    const String drumFileName = 'drum.wav';
    const String otherFileName = 'other.wav';
    const String bassFileName = 'bass.wav';

    try {
      // 로컬 저장소 경로 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final vocalFilePath = '${directory.path}/mute_analysis/$vocalFileName';
      final pianoFilePath = '${directory.path}/mute_analysis/$pianoFileName';
      final drumFilePath = '${directory.path}/mute_analysis/$drumFileName';
      final otherFilePath = '${directory.path}/mute_analysis/$otherFileName';
      final bassFilePath = '${directory.path}/mute_analysis/$bassFileName';

      filePaths.add(bassFilePath);
      filePaths.add(drumFilePath);
      filePaths.add(pianoFilePath);
      filePaths.add(vocalFilePath);
      filePaths.add(otherFilePath);

      final response1 = await downloadFile(vocalUrl, vocalFilePath);
      setState(() {totalProgress += 0.2;});
      final response2 = await downloadFile(pianoUrl, pianoFilePath);
      setState(() {totalProgress += 0.2;});
      final response3 = await downloadFile(drumsUrl, drumFilePath);
      setState(() {totalProgress += 0.2;});
      final response4 = await downloadFile(otherUrl, otherFilePath);
      setState(() {totalProgress += 0.2;});
      final response5 = await downloadFile(bassUrl, bassFilePath);

      if (response1.statusCode==200 && response2.statusCode==200 && response3.statusCode==200 && response4.statusCode==200 && response5.statusCode==200) {
        setState(() {
          analyseDone = true;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Response> downloadFile(String fileUrl, String path) async {
    print(path);
    // 파일 다운로드
    final response = await _dio.download('$url/download?file_path=$fileUrl', path,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            progress = received / total;
            tempProgress = totalProgress+(progress/5);
          });
          print('${path.split('/').last} Download progress: ${(progress * 100).toStringAsFixed(0)}%');
        }
      },
    );
    print('File saved to: $path');
    return response;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _localFilePath = result.files.single.path!;
        _audioPlayer.setSource(DeviceFileSource(_localFilePath));
        _audioPlayer.stop();
        fileReady = true;
        analyseStart = false;
        analyseDone = false;
        tempProgress = 0;
        totalProgress = 0;
      });
    }
  }

  void _playPause() {
    if (!fileReady) {
      return;
    }
    if (!analyseDone || !instChecked.contains(false)) {
      for (int i=0; i<5; i++) {
        players[i].pause();
      }
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play(DeviceFileSource(_localFilePath));
        _seek(_position.inMilliseconds.toDouble()+300);
      }
    } else if (!instChecked.contains(true)) {
      for (int i = 0; i < 5; i++) {
        players[i].pause();
      }
      _audioPlayer.setVolume(0);
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play(DeviceFileSource(_localFilePath));
        _seek(_position.inMilliseconds.toDouble()+300);
      }
    } else {
      _audioPlayer.pause();
      for (int i=0; i<5; i++) {
        if (_isPlaying) {
          players[i].pause();
        } else {
          if (instChecked[i]) {
            players[i].play(DeviceFileSource(filePaths[i]));
            _seek(_position.inMilliseconds.toDouble()+300);
          }
        }
      }
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _applyInst() {
    if (!_isPlaying) return;
    if (!instChecked.contains(false)) {
      for (int i = 0; i < 5; i++) {
        players[i].pause();
      }
      _audioPlayer.setVolume(1);
      _audioPlayer.play(DeviceFileSource(_localFilePath));
      _seek(_position.inMilliseconds.toDouble()+300);
    } else if(!instChecked.contains(true)) {
      for (int i = 0; i < 5; i++) {
        players[i].pause();
      }
      _audioPlayer.setVolume(0);
      _audioPlayer.play(DeviceFileSource(_localFilePath));
      _seek(_position.inMilliseconds.toDouble()+300);
    } else {
      _audioPlayer.pause();
      for (int i = 0; i < 5; i++) {
        if (instChecked[i]) {
          players[i].play(DeviceFileSource(filePaths[i]));
          _seek(_position.inMilliseconds.toDouble()+300);
        } else {
          players[i].pause();
        }
      }
    }
  }

  void _seek(double milliseconds) {
    if (!analyseDone || !instChecked.contains(false) || !instChecked.contains(true)) {
      _audioPlayer.seek(Duration(milliseconds: milliseconds.toInt()));
    } else {
      for (int i = 0; i < 5; i++) {
        if (instChecked[i]) {
          players[i].seek(Duration(milliseconds: milliseconds.toInt()));
        }
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    for (int i=0; i<5; i++) {
      players[i].onDurationChanged.listen((Duration d) {
        setState(() => _duration = d);
      });
      players[i].onPositionChanged.listen((Duration p) {
        setState(() => _position = p);
      });
    }
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    for (int i=0; i<5; i++) {
      players[i].dispose();
    }
    _animationController.dispose();
    super.dispose();
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
                padding: EdgeInsets.symmetric(vertical: titlePaddingSize(screenWidth)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("악기 소리 뮤트",style: semiBold(fontSize1(screenWidth)),)
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
                              InkWell(
                                onTap: () => _pickFile(),
                                  child: Image.asset("assets/images/browse.png", width: 50,)
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                                  child: InkWell(
                                    onTap: () =>_pickFile(),
                                    child: Container(
                                      decoration: gbBox(1,boxSize: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: composeButtonPaddingV(screenWidth),horizontal: composeButtonPaddingH(screenWidth)),
                                            child: Text(!fileReady ? "여기를 눌러 음원을 불러오세요!":_localFilePath.split('/').last, style: TextStyle(
                                                fontSize: fontSize3(screenWidth),
                                                fontWeight: FontWeight.w400,
                                                color: !fileReady ? Color(0xffBDBDBD):Colors.black),),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !analyseDone,
                                child: InkWell(
                                  onTap: (){
                                    if (fileReady) {
                                      _uploadFile();
                                      setState(() {
                                        analyseStart = true;
                                      });
                                    }
                                  },
                                  child: startButton(screenWidth, fileReady, "분석 시작"),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight*0.05, bottom: screenHeight*0.03, left: screenHeight*0.43, right: screenHeight*0.43),
                            child: SizedBox(
                              height: screenHeight*0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: InkWell(
                                      onTap: () {_seek(_position.inMilliseconds.toDouble()-5000);},
                                      child: Image.asset("assets/images/5s_forward.png"),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {_playPause();},
                                    child: Image.asset(_isPlaying?"assets/images/pause.png":"assets/images/play.png"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: InkWell(
                                      onTap: () {_seek(_position.inMilliseconds.toDouble()+5000);},
                                      child: Image.asset("assets/images/5s_back.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                              child: Text("${_formatDuration(_position)} / ${_formatDuration(_duration)}", style: normal(fontSize3(screenWidth)-5),)
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                                trackHeight: 3.0,
                                trackShape: RectangularSliderTrackShape(),
                              overlayShape: SliderComponentShape.noOverlay
                            ),
                            child: Slider(
                              thumbColor: Colors.black,
                              activeColor: Colors.grey, // 재생 된 부분
                              inactiveColor: Colors.grey, // 재생 안된 부분
                              value: _position.inMilliseconds.toDouble(),
                              max: _duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                _seek(value);
                              },
                            ),
                          ),
                          analyseStart && !analyseDone ?
                          loading() : menus()
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

  Widget loading() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _animationController,
            child: Image.asset("assets/images/loading.png", width: 100,),
          ),
          Text("음원을 분석중이에요...${(tempProgress*100).toStringAsFixed(0)}%",style: semiBold(fontSize3(MediaQuery.of(context).size.width)),textAlign: TextAlign.center,)
        ],
      ),
    );
  }
  
  Widget menus() {
    var screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: menuPaddingSize(screenWidth)),
          child: Row(
            children: [
              Expanded(
                child: Visibility(
                  visible: analyseDone,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              decoration:gbBox(1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: menuPaddingSize(screenWidth)+10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("베이스 기타", style: semiBold(fontSize2(screenWidth)-5),),
                                    CustomSwitch(onCheckChange: (bool isShow) {
                                      setState(() {
                                        instChecked[0] = isShow;
                                      });
                                      _applyInst();
                                    },)
                                  ],
                                ),
                              )
                          )
                      ),
                      SizedBox(height: menuGap(screenWidth),),
                      Expanded(
                          child: Container(
                              decoration:gbBox(1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: menuPaddingSize(screenWidth)+10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("드럼", style: semiBold(fontSize2(screenWidth)-5),),
                                    CustomSwitch(
                                        onCheckChange: (bool isShow) {
                                          setState(() {
                                            instChecked[1] = isShow;
                                          });
                                          _applyInst();
                                        }
                                    )
                                  ],
                                ),
                              )
                          )
                      ),
                      SizedBox(height: menuGap(screenWidth),),
                      Expanded(
                          child: Container(
                              decoration:gbBox(1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: menuPaddingSize(screenWidth)+10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("피아노", style: semiBold(fontSize2(screenWidth)-5),),
                                    CustomSwitch(
                                        onCheckChange: (bool isShow) {
                                          setState(() {
                                            instChecked[2] = isShow;
                                          });
                                          _applyInst();
                                        }
                                    )
                                  ],
                                ),
                              )
                          )
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(width: menuGap(screenWidth)*2,),
              Expanded(
                child: Visibility(
                  visible: analyseDone,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                              decoration:gbBox(1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: menuPaddingSize(screenWidth)+10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("보컬", style: semiBold(fontSize2(screenWidth)-5),),
                                    CustomSwitch(
                                        onCheckChange: (bool isShow) {
                                          setState(() {
                                            instChecked[3] = isShow;
                                          });
                                          _applyInst();
                                        }
                                    )
                                  ],
                                ),
                              )
                          )
                      ),
                      SizedBox(height: menuGap(screenWidth),),
                      Expanded(
                          child: Container(
                              decoration:gbBox(1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: menuPaddingSize(screenWidth)+10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("기타 등등", style: semiBold(fontSize2(screenWidth)-5),),
                                    CustomSwitch(
                                        onCheckChange: (bool isShow) {
                                          setState(() {
                                            instChecked[4] = isShow;
                                          });
                                          _applyInst();
                                        }
                                    )
                                  ],
                                ),
                              )
                          )
                      ),
                      SizedBox(height: menuGap(screenWidth),),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
