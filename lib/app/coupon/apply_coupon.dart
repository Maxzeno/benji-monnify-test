import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/common_widgets/textformfield/my textformfield.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class ApplyCoupon extends StatefulWidget {
  const ApplyCoupon({super.key});

  @override
  State<ApplyCoupon> createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  //=============================== ALL VARIABLES ======================================\\

  //===================== KEYS =======================\\
  final _formKey = GlobalKey<FormState>();

  //===================== CONTROLLERS =======================\\
  TextEditingController textController = TextEditingController();

  //===================== FOCUS NODES =======================\\
  FocusNode textFocusNode = FocusNode();

  //===================== BOOL VALUES =======================\\
  bool isLoading = false;
  bool isLoaded = false;

  //===================== FUNCTIONS =======================\\
  Future<void> applyCoupon() async {
    setState(() {
      isLoading = true;
      isLoaded = false;
    });

    // Simulating a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 2));

    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      // Navigate to the new page
      Navigator.of(context).pop(context);
    });

    setState(() {
      isLoading = false;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Apply Coupon",
          backgroundColor: kPrimaryColor,
          toolbarHeight: 80,
          actions: const [],
        ),
        body: Container(
          margin: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: const Text(
                      'Coupon Code',
                      style: TextStyle(
                        color: Color(
                          0xFF333333,
                        ),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  kSizedBox,
                  Form(
                    key: _formKey,
                    child: MyTextFormField(
                      hintText: "Enter a coupon code",
                      controller: textController,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: textFocusNode,
                      validator: (value) {
                        if (value == null || value!.isEmpty) {
                          textFocusNode.requestFocus();
                          return "Enter a coupon code";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        textController.text = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: kDefaultPadding * 4,
              ),
              isLoaded
                  ? Center(
                      child: Container(
                        height: 60,
                        width: mediaWidth,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: kAccentColor,
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Coupon applied successfully",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  : isLoading
                      ? Center(
                          child: SpinKitChasingDots(
                            color: kAccentColor,
                            duration: const Duration(seconds: 1),
                          ),
                        )
                      : MyElevatedButton(
                          title: "Apply Coupon",
                          onPressed: (() async {
                            if (_formKey.currentState!.validate()) {
                              applyCoupon();
                            }
                          }),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
