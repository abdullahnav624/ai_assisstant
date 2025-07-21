import 'package:ai_assisstant/helper/global.dart';
import 'package:ai_assisstant/model/onboard.dart';
import 'package:ai_assisstant/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final list = [
      Onboard(
        title: 'Meet Your Smart Companion',
        subtitle:
            'Get instant answers, helpful suggestions, and personalized support—right when you need it.',
        lottie: 'assets/lottie/ai_ask_me.json',
      ),
      Onboard(
        title: 'Your Assistant, Always Ready',
        subtitle:
            'From setting reminders to solving complex tasks—let AI simplify your day.',
        lottie: 'assets/lottie/ai_play.json',
      ),
    ];
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Lottie.asset(
                  list[index].lottie,
                  height: mq.height * .65,
                  width: index == list.length - 1 ? mq.width * .7 : null,
                ),
                Text(
                  list[index].title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: mq.height * 0.02),
                SizedBox(
                  width: mq.width * .7,
                  child: Text(
                    list[index].subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.03),

                Wrap(
                  spacing: 10,
                  children: List.generate(
                    list.length,
                    (i) => Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        color: i == index ? Colors.blue : Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.03),
                ElevatedButton(
                  onPressed: () {
                    if (index == list.length - 1) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    } else {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.ease,
                      );
                    }
                  },

                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all<double>(9),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.blue,
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                      Size(mq.width * 0.45, mq.width * 0.12),
                    ),
                  ),
                  child: Text(
                    index == list.length - 1 ? "Get Started" : "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mq.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ), // Set text color here
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
