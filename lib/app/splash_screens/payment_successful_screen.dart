// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../orders/track_order.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  void _toTrackOrder() => Get.off(
        () => const TrackOrder(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Home",
        preventDuplicates: true,
        popGesture: false,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: MyElevatedButton(title: "Done", onPressed: _toTrackOrder),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          margin: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/payment/frame_1.json",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    height: mediaHeight / 2,
                    width: mediaWidth / 2,
                  ),
                  Text(
                    "Payment Successful",
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
