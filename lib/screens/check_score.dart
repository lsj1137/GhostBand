import 'package:flutter/material.dart';

import '../config/gb_theme.dart';

class CheckScore extends StatefulWidget {
  const CheckScore({super.key});

  @override
  State<CheckScore> createState() => _CheckScoreState();
}

class _CheckScoreState extends State<CheckScore> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final List<DataRow> rows = List<DataRow>.generate(11,
          (index) => DataRow(cells: [
            DataCell(Center(child: Text('${index+1}'))),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]),
    );

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
                          Align(
                            alignment: Alignment.centerLeft,
                              child: Text("※ 곡 이름을 눌러 악보를 확인할 수 있습니다.",style: semiBold(fontSize3(screenWidth)),)),
                          Expanded(
                            child: Scrollbar(
                              radius: const Radius.circular(2),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: DataTable(
                                    headingTextStyle: semiBold(22),
                                    dataTextStyle: normal(fontSize3(screenWidth)),
                                    border: const TableBorder.symmetric(inside: BorderSide(color: Color(0xffdbdbdb)),),
                                    showBottomBorder: true,
                                    columns: [
                                      DataColumn(label: SizedBox(width: screenWidth*0.03, child: Center(child: Text('순서')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.12, child: Center(child: Text('곡 이름')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.14, child: Center(child: Text('악기 종류')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.08, child: Center(child: Text('생성일시')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.14, child: Center(child: Text('재생바')))),
                                      DataColumn(label: SizedBox(width: screenWidth*0.1, child: Center(child: Text('메뉴')))),
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
}
