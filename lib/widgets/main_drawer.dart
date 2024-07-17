import 'package:flutter/material.dart';

import '../config/gb_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: LinearBorder.none,
      shadowColor: Colors.black,
      elevation: 15,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () { },
              leading: Image.asset("assets/images/setting.png", width: 30,),
              title: Text('설정', style: semiBold(fontSize2(context)),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () {
                _helpDialog(context);
              },
              leading: Image.asset("assets/images/help.png", width: 30,),
              title: Text('도움말', style: semiBold(fontSize2(context)),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () {
                _infoDialog(context);
              },
              leading: Image.asset("assets/images/info.png", width: 30,),
              title: Text('정보', style: semiBold(fontSize2(context)),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
        ],
      ),
    );
  }

  void _helpDialog (context) {
    showDialog( context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              decoration: gbBox(1),
              height: MediaQuery.of(context).size.height*0.7,
              width: MediaQuery.of(context).size.width*0.7,
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.08),
                        child: helpInfo(context),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.close_rounded,size: 30,),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Column helpInfo(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI 작곡 기능", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("AI 작곡 모델 Muzic을 이용해 사용자가 원하는 스타일의 곡을 작곡합니다.", style: normal(fontSize3(context))),
        Text("사용자는 장르, 리듬, 사용될 악기를 선택할 수 있습니다.", style: normal(fontSize3(context))),
        Text("음원 하나(midi)와 그에 대한 악보(pdf)가 생성되며, 시간은 8~15분 정도가 소요됩니다.", style: normal(fontSize3(context))),
        Text("생성이 다 되면 다이얼로그를 통해 알려드리며, 생성 중간에 취소도 가능합니다.", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.02),
        Text("※ 주의 ※", style: semiBold(fontSize3(context))),
        Text("본 앱으로 생성한 음악을 상업적으로 사용해서는 안되며, 사용해서 생기는 불이익은 저희가 책임지지 않습니다.", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.04),
        Text("악보 확인/재생 기능", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("AI 작곡이나 악보 추출 기능으로 생성된 악보를 확인합니다.", style: normal(fontSize3(context))),
        Text("악보를 확인하기 전, 파일들이 나열된 표에서 미리 들어보는 것도 가능합니다.", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.04),
        Text("악보 추출 기능", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("음원으로부터 악보를 추출합니다.", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.04),
        Text("악기 뮤트 기능", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("음원을 분석해 5가지(보컬, 베이스, 드럼, 피아노, 기타)를 구분합니다.", style: normal(fontSize3(context))),
        Text("사용자는 원하는 파트만 선택해 들어보는 것이 가능합니다.", style: normal(fontSize3(context))),
      ],
    );
  }

  void _infoDialog (context) {
    showDialog( context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: Container(
              decoration: gbBox(1),
              height: MediaQuery.of(context).size.height*0.7,
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.08),
                        child: appInfo(context),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, icon: Icon(Icons.close_rounded,size: 30,),
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      )
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Column appInfo(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("앱 정보", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("버전 - 1.0.0", style: normal(fontSize3(context))),
        Text("출시일 - 2024.07.16", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.04),
        Text("개발자 정보", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("Team. 단컴한 인생", style: semiBold(fontSize3(context)),),
        Text("이철민  -  AI 작곡", style: normal(fontSize3(context))),
        Text("이재영  -  악기 뮤트, 악보 추출 (팀장)", style: normal(fontSize3(context))),
        Text("임세준  -  프론트엔드 w.Flutter", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.04),
        Text("Contact", style: semiBold(fontSize2(context))),
        SizedBox(height: screenHeight*0.02),
        Text("이철민", style: semiBold(fontSize3(context))),
        Text("jongha1257@gmail.com", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.02),
        Text("이재영", style: semiBold(fontSize3(context))),
        Text("leeja042499@gmail.com", style: normal(fontSize3(context))),
        SizedBox(height: screenHeight*0.02),
        Text("임세준", style: semiBold(fontSize3(context))),
        Text("lsj1137jsl@gmail.com", style: normal(fontSize3(context))),
      ],
    );
  }

}
