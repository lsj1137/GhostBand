import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../config/gb_theme.dart';

class MakeScore extends StatefulWidget {
  const MakeScore({super.key});

  @override
  State<MakeScore> createState() => _MakeScoreState();
}

class _MakeScoreState extends State<MakeScore> {
  final Dio _dio = Dio();

  String url = 'http://220.149.232.226:5010';

  double progress = 0;
  double tempProgress = 0;
  double totalProgress = 0;

  String _localFilePath = '';
  String pdfPath = '';

  bool fileReady = false;
  bool analyseStart = false;
  bool analyseDone = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _localFilePath = result.files.single.path!;
        fileReady = true;
        analyseStart = false;
        analyseDone = false;
      });
    }
  }

  Future<void> _uploadFile() async {
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
      if (kDebugMode) {
        print("Upload successful: ${response.data}");
      }
      // fileUrl = response.data['file_url'];
      // print(fileUrl);
      // _downloadFile(fileUrl);
    } catch (e) {
      // 오류 처리
      if (kDebugMode) {
        print("Error uploading file: $e");
      }
    }
  }

  Future<void> _downloadFile(String fileUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    var currentTime = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final filePath = '${directory.path}/compose_results/$currentTime';
    pdfPath = '$filePath/generated_score.pdf';
    final musicFilePath = '$filePath/${_localFilePath.split('/').last}';
    _copyFile(_localFilePath, musicFilePath);
    // 파일 다운로드
    try {
      final response = await _dio.download('$url/download?file_path=$fileUrl', pdfPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
              tempProgress = totalProgress+(progress/5);
            });
            if (kDebugMode) {
              print('Download progress: ${(progress * 100).toStringAsFixed(0)}%');
            }
          }
        },
      );
      setState(() {
        analyseDone = true;
      });
      if (kDebugMode) {
        print('File saved to: $filePath');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error : $e");
      }
    }
  }

  Future<void> _copyFile(String source, String dest) async {

    File sourceFile = File(source);
    if (await sourceFile.exists()) {
      File targetFile = File(dest);
      await targetFile.create(recursive: true);
      await sourceFile.copy(targetFile.path);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('원본 파일을 찾을 수 없습니다!')),
        );
      }
    }

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
                padding: EdgeInsets.symmetric(vertical: titlePaddingSize(context)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("악보 추출",style: semiBold(fontSize1(context)),)
                ),
              ),
              Expanded(
                  child: Container(
                    decoration: gbBox(1),
                    child: Padding(
                      padding: EdgeInsets.only(top: composePaddingSize(context), left: menuPaddingSize(context), right: menuPaddingSize(context)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => _pickFile(),
                                  child: Image.asset("assets/images/browse.png", width: screenWidth*0.039,)),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03),
                                  child: InkWell(
                                    onTap: () => _pickFile(),
                                    child: Container(
                                      decoration: gbBox(1,boxSize: 15),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: composeButtonPaddingV(context),horizontal: composeButtonPaddingH(context)),
                                            child: Text(!fileReady ? "여기를 눌러 음원을 불러오세요!":_localFilePath.split('/').last, style: TextStyle(
                                                fontSize: fontSize3(context),
                                                fontWeight: FontWeight.w400,
                                                color: !fileReady ? const Color(0xffBDBDBD):Colors.black),),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !analyseStart,
                                child: InkWell(
                                  onTap: (){
                                    if (fileReady) {
                                      setState(() {
                                        analyseStart = true;
                                      });
                                      _uploadFile();
                                    }
                                  },
                                  child: startButton(context, fileReady, "분석 시작"),
                                ),
                              )
                            ],
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

