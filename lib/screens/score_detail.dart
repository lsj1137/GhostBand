import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

import '../config/gb_theme.dart';

class ScoreDetail extends StatefulWidget {
  const ScoreDetail({super.key, required this.pdfPath, required this.midiPath});
  final String pdfPath;
  final String midiPath;

  @override
  State<ScoreDetail> createState() => _ScoreDetailState();
}

class _ScoreDetailState extends State<ScoreDetail> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final int initialPage = 1;
  late PdfController pdfController;

  final TextEditingController _textEditingController = TextEditingController();

  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 0.5;

  bool autoTurnPage = true;


  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(DeviceFileSource(widget.midiPath));
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


  void _checkPage() {
    if (_duration.inSeconds==0 || pdfController.pagesCount==0) {
      return;
    }
    var partition = _duration.inSeconds / pdfController.pagesCount!;
    var page = _position.inSeconds ~/ partition + 1;
    if (page > pdfController.pagesCount!) {return;}
    pdfController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pdfController = PdfController(
        document: PdfDocument.openData(File(widget.pdfPath).readAsBytes()),
        initialPage: initialPage
    );
    _textEditingController.text = initialPage.toString();
    _audioPlayer.setVolume(_volume);
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    pdfController.dispose();
    _audioPlayer.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    if (autoTurnPage) {
      _checkPage();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.all(screenWidth*0.011),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/images/back.png",height: 20,),
                          const SizedBox(width: 10,),
                          Text("뒤로", style: semiBold(fontSize3(context)),),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {_playPause();},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(_isPlaying?"assets/images/pause.png":"assets/images/play.png",height: 20,),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: screenWidth*0.33,
                          child: SliderTheme(
                            data: SliderThemeData(
                                trackHeight: 3.0,
                                trackShape: const RectangularSliderTrackShape(),
                                overlayShape: SliderComponentShape.noOverlay,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)
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
                        ),
                        Text(_formatDuration(_position),style: normal(fontSize3(context)),)
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("assets/images/volume.png",height: screenWidth*0.035,),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: screenWidth*0.15,
                          child: SliderTheme(
                            data: SliderThemeData(
                                trackHeight: 3.0,
                                trackShape: const RectangularSliderTrackShape(),
                                overlayShape: SliderComponentShape.noOverlay,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)
                            ),
                            child: Slider(
                              thumbColor: Colors.black,
                              activeColor: Colors.grey, // 재생 된 부분
                              inactiveColor: Colors.grey, // 재생 안된 부분
                              value: _volume,
                              min: 0,
                              max: 1,
                              divisions: 20,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value;
                                  _audioPlayer.setVolume(_volume);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: screenHeight*0.85,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: PdfView(
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                    pageLoaderBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                  ),
                  controller: pdfController,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: screenHeight*0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              autoTurnPage = !autoTurnPage;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: composeGap(context),
                                    vertical: composeGap(context)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.height*0.015,
                                  height: MediaQuery.of(context).size.height*0.015,
                                  decoration: !autoTurnPage ? questionNum() :
                                  BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                      color: gbBlue
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text("악보 자동 넘기기",style: semiBold(fontSize5(context)),)
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigate_before,),
                        onPressed: () {
                          pdfController.previousPage(
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 100),
                          );
                        },
                      ),
                      Center(
                        child: PdfPageNumber(
                          controller: pdfController,
                          builder: (_, loadingState, page, pagesCount) {
                            _textEditingController.text = page.toString();
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: screenWidth*0.05,
                                    height: screenWidth*0.1,
                                    decoration: const BoxDecoration(
                                      border:BorderDirectional(bottom: BorderSide()),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: scorePageGap(context)),
                                      child: TextField(
                                        controller: _textEditingController,
                                        style: TextStyle(fontSize: fontSize3(context)),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero
                                        ),
                                        textAlign: TextAlign.center,
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.number,
                                        onSubmitted: (value) {
                                          pdfController.jumpToPage(int.parse(value));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Text('/',style: TextStyle(fontSize: fontSize1(context), fontWeight: FontWeight.w200),),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: screenWidth*0.05,
                                    height: screenWidth*0.1,
                                    decoration: const BoxDecoration(
                                      border:BorderDirectional(bottom: BorderSide()),
                                    ),
                                    child: Center(child: Text(pagesCount.toString(), style: TextStyle(fontSize: fontSize3(context)),)),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigate_next),
                        onPressed: () {
                          pdfController.nextPage(
                            curve: Curves.ease,
                            duration: const Duration(milliseconds: 100),
                          );
                        },
                      ),
                      Expanded(child: Container(),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
