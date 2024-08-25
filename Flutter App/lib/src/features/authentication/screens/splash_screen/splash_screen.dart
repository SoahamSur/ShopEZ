import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:my_login_app/src/common_widgets/fade_animations/page_route.dart';
import 'package:my_login_app/src/constants/image_string.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Positioned(
        child: Center(
          child: CircleAvatar(
            backgroundImage:  AssetImage((tSplashImg)),
            radius: 60.0,
          ),
        ),
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    Navigator.pushReplacement(
        context,
        FadeRoute(
          page: LoginPage(),
          duration: Duration(seconds: 1),
        ),
    );
  }
}