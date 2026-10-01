import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:engineers_workshop/screens/workshop_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const EngineerWorkshopApp());
}

class EngineerWorkshopApp extends StatelessWidget {
  const EngineerWorkshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Engineer\'s Workshop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5C4033),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const WorkshopScreen(),
    );
  }
}
