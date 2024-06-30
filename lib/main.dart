import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghost_band/screens/main_menu.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const GhostBand());
}

class GhostBand extends StatelessWidget {
  const GhostBand({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Pretendard",
          textSelectionTheme: const TextSelectionThemeData(
              selectionHandleColor: Colors.black
          )
      ),
      home: MainMenu(),
    );
  }
}

