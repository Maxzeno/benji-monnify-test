// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../theme/colors.dart';
import '../home/home.dart';

class LoginSplashScreen extends StatefulWidget {
  const LoginSplashScreen({super.key});

  @override
  State<LoginSplashScreen> createState() => _LoginSplashScreenState();
}

class _LoginSplashScreenState extends State<LoginSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () {
        Get.offAll(
          () => const Home(),
          duration: const Duration(seconds: 2),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Home",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.fadeIn,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Center(
              child: Lottie.asset(
                "assets/animations/login/frame_1.json",
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
