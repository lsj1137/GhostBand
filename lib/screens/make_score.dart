import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../config/gb_theme.dart';

class MakeScore extends StatefulWidget {
  const MakeScore({super.key});

  @override
  State<MakeScore> createState() => _MakeScoreState();
}

class _MakeScoreState extends State<MakeScore> with SingleTickerProviderStateMixin {
  final Dio _dio = Dio();
  late AnimationController _animationController;
  late PdfController pdfController;

  String url = 'http://220.149.232.226:5010';

  double progress = 0;
  double tempProgress = 0;
  double totalProgress = 0;

  String _localFilePath = '';
  String pdfPath = '';

  bool fileReady = false;
  bool analyseStart = false;
  bool analyseDone = false;

  final int initialPage = 1;

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
      Response response = await _dio.post('$url/sheet', data: formData,
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
      var fileUrl = response.data['file_urls'];
      await _downloadFile(fileUrl);
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
      downloadToast();
      pdfController = PdfController(
          document: PdfDocument.openData(File(pdfPath).readAsBytesSync()).whenComplete(() {
            setState(() {
              pdfController.pagesCount;
            });
          }),
          initialPage: initialPage
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

  void downloadToast() {
    Fluttertoast.showToast(
        msg: "악보가 저장되었습니다.\n악보 확인/재생 메뉴에서 확인 가능합니다.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
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
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
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
                                  padding: !analyseStart ? EdgeInsets.symmetric(horizontal: screenWidth*0.03) : EdgeInsets.only(left: screenWidth*0.03),
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
                                  onTap: () async {
                                    if (fileReady) {
                                      setState(() {
                                        analyseStart = true;
                                      });
                                      await _uploadFile();
                                    }
                                  },
                                  child: startButton(context, fileReady, "분석 시작"),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: !analyseStart ? Container() : !analyseDone ?
                          loading() : pdfViewer())
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
          turns: _animationController,
          child: Image.asset("assets/images/loading.png", width: 100,),
        ),
        Text("음원을 분석중이에요...${(tempProgress*100).toStringAsFixed(0)}%",style: semiBold(fontSize3(context)),textAlign: TextAlign.center,)
      ],
    );
  }

  Widget pdfViewer() {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: menuPaddingSize(context)),
      child: Container(
        width: screenWidth,
        decoration: gbBox(1),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: PdfView(
                  onPageChanged: (page) {setState(() {});},
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
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth*0.045,
                  height: screenWidth*0.045,
                  child: Center(child: Text(pdfController.page.toString(), style: TextStyle(fontSize: fontSize3(context),color: Colors.black54))),
                ),
                Text('/',style: TextStyle(fontSize: fontSize2(context), fontWeight: FontWeight.w200, color: Colors.black54),),
                SizedBox(
                  width: screenWidth*0.045,
                  height: screenWidth*0.045,
                  child: Center(child: Text(pdfController.pagesCount.toString(), style: TextStyle(fontSize: fontSize3(context),color: Colors.black54),)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

