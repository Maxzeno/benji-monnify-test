// ignore_for_file: use_build_context_synchronously, file_names

import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/section/reusable_authentication_first_half.dart';
import '../../src/common_widgets/snackbar/my_fixed_snackBar.dart';
import '../../src/common_widgets/textformfield/email_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import 'otp_reset_password.dart';

class ForgotPassword extends StatefulWidget {
  final String? title;
  final String? subTitle;
  const ForgotPassword({super.key, this.title, this.subTitle});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //=========================== ALL VARIABBLES ====================================\\

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;
  bool _validAuthCredentials = false;
  // bool _invalidAuthCredentials = false;

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== CONTROLLERS ====================================\\

  final TextEditingController _emailController = TextEditingController();

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _emailFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\
  Future<bool> forgotPassword() async {
    final url = Uri.parse(
        '$baseURL/auth/requestForgotPassword/${_emailController.text}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    final body = {};
    final response = await http.post(url, body: body);

    return response.statusCode == 200 && response.body == '"Email Sent"';
  }

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    bool resp = await forgotPassword();

    setState(() {
      _validAuthCredentials = resp;
    });

    if (resp) {
      myFixedSnackBar(
        context,
        "An OTP code has been sent to your email".toUpperCase(),
        kSuccessColor,
        const Duration(
          seconds: 2,
        ),
      );

      Get.to(
        () => const OTPResetPassword(),
        routeName: 'OTPResetPassword',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    } else {
      myFixedSnackBar(
        context,
        "Something went wrong".toUpperCase(),
        kAccentColor,
        const Duration(
          seconds: 2,
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: const MyAppBar(
          title: "",
          elevation: 0.0,
          actions: [],
          backgroundColor: kTransparentColor,
          toolbarHeight: kToolbarHeight,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: LayoutGrid(
            columnSizes: breakPointDynamic(
              media.size.width,
              [1.fr],
              [1.fr],
              [1.fr, 1.fr],
              [1.fr, 1.fr],
            ),
            rowSizes: breakPointDynamic(
              media.size.width,
              [auto, 1.fr],
              [auto, 1.fr],
              [1.fr],
              [1.fr],
            ),
            children: [
              Column(
                children: [
                  Expanded(
                    child: () {
                      if (_validAuthCredentials) {
                        return ReusableAuthenticationFirstHalf(
                          title: widget.title != null
                              ? widget.title!
                              : "Forgot your password?",
                          subtitle: widget.subTitle != null
                              ? widget.subTitle!
                              : "Simply enter your email below and we will send you a code via which you need to reset your password",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: kSuccessColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: const OvalBorder(),
                          ),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      } else {
                        return ReusableAuthenticationFirstHalf(
                          title: widget.title != null
                              ? widget.title!
                              : "Forgot your password?",
                          subtitle: widget.subTitle != null
                              ? widget.subTitle!
                              : "Simply enter your email below and we will send you a code via which you need to reset your password",
                          curves: Curves.easeInOut,
                          duration: const Duration(),
                          containerChild: Center(
                            child: FaIcon(
                              FontAwesomeIcons.question,
                              color: kSecondaryColor,
                              size: 80,
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: const OvalBorder(),
                          ),
                          imageContainerHeight:
                              deviceType(media.size.width) > 2 ? 200 : 100,
                        );
                      }
                    }(),
                  ),
                ],
              ),
              Container(
                height: media.size.height,
                width: media.size.width,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        breakPoint(media.size.width, 24, 24, 0, 0)),
                    topRight: Radius.circular(
                        breakPoint(media.size.width, 24, 24, 0, 0)),
                  ),
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Email',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(
                                  0xFF31343D,
                                ),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          EmailTextFormField(
                            controller: _emailController,
                            emailFocusNode: _emailFocusNode,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              RegExp emailPattern = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                              );
                              if (value == null || value!.isEmpty) {
                                _emailFocusNode.requestFocus();
                                return "Enter your email address";
                              } else if (!emailPattern.hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _emailController.text = value;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          _isLoading
                              ? Center(
                                  child: SpinKitChasingDots(
                                    color: kAccentColor,
                                    duration: const Duration(seconds: 2),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: (() async {
                                    if (_formKey.currentState!.validate()) {
                                      loadData();
                                    }
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor: kAccentColor,
                                    fixedSize: Size(media.size.width, 50),
                                  ),
                                  child: Text(
                                    'Send Code'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
