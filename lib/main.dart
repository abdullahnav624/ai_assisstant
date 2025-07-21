import 'package:ai_assisstant/helper/pref.dart';
import 'package:ai_assisstant/screens/splash_screen.dart';
import 'package:flutter/material.dart';

// Future<void> main() async {
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  Pref.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
