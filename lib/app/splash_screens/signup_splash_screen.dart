// ignore_for_file: camel_case_types, file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../theme/colors.dart';
import '../home/home.dart';

class SignUpSplashScreen extends StatefulWidget {
  const SignUpSplashScreen({super.key});

  @override
  State<SignUpSplashScreen> createState() => _SignUpSplashScreenState();
}

class _SignUpSplashScreenState extends State<SignUpSplashScreen> {
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
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Center(
              child: Lottie.asset(
                "assets/animations/signup/frame_1.json",
                height: 300,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
