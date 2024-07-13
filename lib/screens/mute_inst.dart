import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../config/custom_switch.dart';
import '../config/gb_theme.dart';

class MuteInst extends StatefulWidget {
  const MuteInst({super.key});

  @override
  State<MuteInst> createState() => _MuteInstState();
}

class _MuteInstState extends State<MuteInst> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _bassPlayer = AudioPlayer();
  final AudioPlayer _drumPlayer = AudioPlayer();
  final AudioPlayer _pianoPlayer = AudioPlayer();
  final AudioPlayer _vocalPlayer = AudioPlayer();
  final AudioPlayer _othersPlayer = AudioPlayer();

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  String _localFilePath = '';

  bool fileReady = false;
  bool analyseDone = false;
  bool _bassChecked = true;
  bool _drumChecked = true;
  bool _pianoChecked = true;
  bool _vocalChecked = true;
  bool _othersChecked = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _bassPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _bassPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _drumPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _drumPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _pianoPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _pianoPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _vocalPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _vocalPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _othersPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _othersPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bassPlayer.dispose();
    _drumPlayer.dispose();
    _pianoPlayer.dispose();
    _vocalPlayer.dispose();
    _othersPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _localFilePath = result.files.single.path!;
        fileReady = true;
      });
    }
  }

  void _playPause() {
    if (_localFilePath=='') {
      return;
    }
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(DeviceFileSource(_localFilePath));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _seek(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
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
                              InkWell(
                                onTap: (){
                                  if (fileReady) {

                                  }
                                },
                                child: startButton(screenWidth, fileReady, "분석 시작"),
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
                                      onTap: () {_seek(_position.inSeconds.toDouble()-5);},
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
                                      onTap: () {_seek(_position.inSeconds.toDouble()+5);},
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
                              overlayShape: SliderComponentShape.noOverlay
                            ),
                            child: Slider(
                              thumbColor: Colors.black,
                              activeColor: Colors.grey, // 재생 된 부분
                              inactiveColor: Colors.grey, // 재생 안된 부분
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _seek(value);
                              },
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: menuPaddingSize(screenWidth)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Visibility(
                                        visible: !analyseDone,
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
                                                          _bassChecked = isShow;
                                                        });
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
                                                              onCheckChange: (bool? value) {
                                                                setState(() {
                                                                  _drumChecked = value ?? false;
                                                                });
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
                                                              onCheckChange: (bool? value) {
                                                                setState(() {
                                                                  _pianoChecked = value ?? false;
                                                                });
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
                                        visible: !analyseDone,
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
                                                              onCheckChange: (bool? value) {
                                                                setState(() {
                                                                  _vocalChecked = value ?? false;
                                                                });
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
                                                              onCheckChange: (bool? value) {
                                                                setState(() {
                                                                  _othersChecked = value ?? false;
                                                                });
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
                          ),
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
