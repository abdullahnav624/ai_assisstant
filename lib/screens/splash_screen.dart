import 'package:ai_assisstant/screens/home_screen.dart';
import 'package:ai_assisstant/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../helper/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: Card(
          // color: Colors.blue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.all(mq.width * 0.05),
            child: Image.asset("assets/images/logo.png", width: mq.width * 0.4),
          ),
        ),
      ),
    );
  }
}
