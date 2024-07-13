import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../config/gb_theme.dart';

class MakeScore extends StatefulWidget {
  const MakeScore({super.key});

  @override
  State<MakeScore> createState() => _MakeScoreState();
}

class _MakeScoreState extends State<MakeScore> {
  bool fileReady = false;

  String _localFilePath = '';

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
                    child: Text("악보 확인/재생",style: semiBold(fontSize1(screenWidth)),)
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
                                  child: Image.asset("assets/images/browse.png", width: 50,)),
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

