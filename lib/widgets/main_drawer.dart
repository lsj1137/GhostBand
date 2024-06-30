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
              title: Text('설정', style: semiBold(20),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () { },
              leading: Image.asset("assets/images/help.png", width: 30,),
              title: Text('도움말', style: semiBold(20),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () { },
              leading: Image.asset("assets/images/info.png", width: 30,),
              title: Text('정보', style: semiBold(20),),
            ),
          ),
          Divider(height: 2,color: Color(0xff848484),thickness: 1.5,indent: 15,endIndent: 15,),
        ],
      ),
    );
  }
}
