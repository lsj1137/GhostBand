import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghost_band/screens/score_detail.dart';
import 'package:ghost_band/screens/score_detail2.dart';
import 'package:path_provider/path_provider.dart';

import '../config/gb_theme.dart';

class CheckScore extends StatefulWidget {
  const CheckScore({super.key});

  @override
  State<CheckScore> createState() => _CheckScoreState();
}

class _CheckScoreState extends State<CheckScore> {
  List<FileSystemEntity> _files = [];
  List<String> midiFilePaths = [];
  List<String> pdfFilePaths = [];
  List<List<dynamic>> audioPlayerInstances = []; // 0: isPlaying, 1: duration, 2:position, 3: instance
  List<DataRow> rows = [];

  List<String> kInstName = ["일렉 기타", "베이스 기타", "키보드", "드럼", "신디사이저", "클래식 기타", "피아노", "트럼펫", "색소폰", "바이올린", "첼로", "오르간"];

  Future<void> _loadLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/compose_results/');
    _files = dir.listSync();
    if (kDebugMode) {
      print(_files);
    }
  }

  void _readData() {
    setState(() {
      rows = List<DataRow>.generate(_files.length<9 ? 9 : _files.length, (index) {
        if (index<_files.length) {
          final fileDir = _files[index].path;
          makeAudioPlayerInstance(index);
          var fileName = '';
          Directory(fileDir).listSync().forEach((file) {
            if (file.path.split('.').last=='mid') {
              midiFilePaths.add(file.path);
              fileName = file.path.split('/').last;
            } else if (file.path.split('.').last=='pdf') {
              pdfFilePaths.add(file.path);
            }
          });
          var genDate = changeDateFormat(fileDir.split('/').last);
          return DataRow(
              cells: [
                DataCell(Center(child: Text('${index + 1}'))),
                DataCell(fileLink(fileName, pdfFilePaths[index], midiFilePaths[index])),
                DataCell(loadMetaData(fileDir)),
                DataCell(Center(child: Text(genDate))),
                DataCell(player(index)),
                DataCell(options(index)),
              ]
          );
        } else {
          return DataRow(
              cells: [
                DataCell(Container()),
                DataCell(Container()),
                DataCell(Container()),
                DataCell(Container()),
                DataCell(Container()),
                DataCell(Container()),
              ]
          );
        }
      });
    });
  }

  void makeAudioPlayerInstance(int index) {
    bool isPlaying = false;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayerInstances.add([isPlaying, duration, position, audioPlayer]);
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => audioPlayerInstances[index][1] = d);
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => audioPlayerInstances[index][2] = p);
    });
  }

  Widget fileLink(String fileName, String pdfPath, String midiPath) {
    return Center(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScoreDetail2(pdfPath: pdfPath, midiPath: midiPath,),),);
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MidiProExample(),),);
          },
          child: Text(fileName,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        )
    );
  }

  Widget loadMetaData(dir) {
    return FutureBuilder(
      future: File('$dir/meta.txt').readAsString(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data');
        } else {
          var data = snapshot.data!.split(',');
          if (kDebugMode) {
            print(data);
          }
          var instList = [];
          for (var index in data) {
            instList.add(kInstName[int.parse(index)]);
          }
          return SingleChildScrollView(
            child: Align(alignment:Alignment.centerLeft ,child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(instList.join(', ')),
            )),
          );
        }
      },
    );
  }

  String changeDateFormat(String s) {
    var origin = s.split('_');
    var ymd = '${origin[0].substring(0,2)}.${origin[0].substring(2,4)}.${origin[0].substring(4,6)}';
    var hm = '${origin[1].substring(0,2)}:${origin[1].substring(2,4)}';
    return '$ymd $hm';
  }

  void _playPause(int index) {
    if (audioPlayerInstances[index][0]) {
      audioPlayerInstances[index][3].pause();
    } else {
      audioPlayerInstances[index][3].play(DeviceFileSource(midiFilePaths[index]));
    }
    setState(() => audioPlayerInstances[index][0] = !audioPlayerInstances[index][0]);
  }

  void _seek(int index, double seconds) {
    audioPlayerInstances[index][3].seek(Duration(seconds: seconds.toInt()));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  void updateCell () {
    for (int i=0; i<_files.length; i++) {
      rows[i].cells[4] = DataCell(player(i));
      rows[i].cells[5] = DataCell(options(i));
    }
  }

  Future<void> _copyFile(int index) async {
    var midiPath = midiFilePaths[index];
    var pdfPath = pdfFilePaths[index];

    // Download 폴더 경로 가져오기
    Directory? downloadDir = await getExternalStorageDirectory();
    var defaultPath = downloadDir?.path.split('/').sublist(0,4).join('/');
    String midiDownloadPath = '$defaultPath/Download/${midiPath.split('/').last}';
    String pdfDownloadPath = '$defaultPath/Download/${pdfPath.split('/').last}';

    // 파일 복사
    File sourceFile = File(midiPath);
    if (await sourceFile.exists()) {
      File targetFile = File(midiDownloadPath);
      await targetFile.create(recursive: true);
      await sourceFile.copy(targetFile.path);

      // 파일 복사 완료 메시지 출력
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download 폴더에 저장되었습니다!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('원본 파일을 찾을 수 없습니다!')),
        );
      }
    }
    File sourceFile2 = File(pdfPath);
    if (await sourceFile2.exists()) {
      File targetFile2 = File(pdfDownloadPath);
      await targetFile2.create(recursive: true);
      await sourceFile2.copy(targetFile2.path);

      // 파일 복사 완료 메시지 출력
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download 폴더에 저장되었습니다!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('원본 파일을 찾을 수 없습니다!')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadLocalFile();
      _readData();
    });
  }

  @override
  void dispose() {
    for (var audios in audioPlayerInstances) {
      audios[3].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    updateCell();
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
                padding: EdgeInsets.symmetric(vertical: titlePaddingSize(context)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("악보 확인/재생",style: semiBold(fontSize1(context)),)
                ),
              ),
              Expanded(
                  child: Container(
                    decoration: gbBox(1),
                    child: Padding(
                      padding: EdgeInsets.only(top: composePaddingSize(context), left: menuPaddingSize(context), right: menuPaddingSize(context)),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                              child: Text("※ 곡 이름을 눌러 악보를 확인할 수 있습니다.",style: semiBold(fontSize3(context)),)),
                          Expanded(
                            child: Scrollbar(
                              radius: const Radius.circular(2),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: fontSize3(context)),
                                child: DataTable(
                                  horizontalMargin: 0,
                                    headingTextStyle: semiBold(fontSize3(context)),
                                    dataTextStyle: semiBold(fontSize4(context)),
                                    columnSpacing: composeQuestionGap(context),
                                    dataRowMinHeight: screenHeight*0.04,
                                    dataRowMaxHeight: screenHeight*0.075,
                                    border: const TableBorder.symmetric(inside: BorderSide(color: Color(0xffdbdbdb)),),
                                    showBottomBorder: true,
                                    columns: [
                                      DataColumn(label: SizedBox(width: screenWidth*0.05, child: const Center(child: Text('순서')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.15, child: const Center(child: Text('곡 이름')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.215, child: const Center(child: Text('악기 종류')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.11, child: const Center(child: Text('생성일시')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.18, child: const Center(child: Text('재생바')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.11, child: const Center(child: Text('옵션')))),
                                    ],
                                    rows: rows
                                ),
                              ),
                            ),
                          )
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

  Widget player(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width*0.14,
          child: SliderTheme(
            data: SliderThemeData(
                trackHeight: 3.0,
                trackShape: const RectangularSliderTrackShape(),
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)
            ),
            child: Slider(
              thumbColor: Colors.black,
              activeColor: Colors.grey, // 재생 된 부분
              inactiveColor: Colors.grey, // 재생 안된 부분
              value: audioPlayerInstances[index][2].inSeconds.toDouble(),
              max: audioPlayerInstances[index][1].inSeconds.toDouble(),
              onChanged: (value) {
                _seek(index, value);
              },
            ),
          ),
        ),
        Text(_formatDuration(audioPlayerInstances[index][2]),style: semiBold(fontSize3(context)-5),)
      ],
    );
  }

  Widget options(int index) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              _copyFile(index);
            },
            child: Image.asset("assets/images/download.png",width: menuPaddingSize(context),),
          ),
          InkWell(
            onTap: () {
              _playPause(index);
            },
            child: Image.asset(audioPlayerInstances[index][0]?"assets/images/pause.png":"assets/images/play.png",width: fontSize3(context),),
          ),
        ],
      );
  }



}
