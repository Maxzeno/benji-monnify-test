// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../src/common_widgets/section/reusable_authentication_first_half.dart';
import '../../src/common_widgets/snackbar/my_fixed_snackBar.dart';
import '../../src/common_widgets/textformfield/email_textformfield.dart';
import '../../src/common_widgets/textformfield/password_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/utils/base_url.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';
import '../splash_screens/login_splash_screen.dart';
import 'forgot_password.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  final bool logout;
  const Login({super.key, this.logout = false});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //=========================== INITIAL STATE ====================================\\
  @override
  void initState() {
    super.initState();
    if (widget.logout) {
      deleteUser();
    }
    _isObscured = true;
  }

  //=========================== ALL VARIABBLES ====================================\\

  //=========================== CONTROLLERS ====================================\\

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //=========================== KEYS ====================================\\

  final _formKey = GlobalKey<FormState>();

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;
  bool _validAuthCredentials = false;
  bool _invalidAuthCredentials = false;

  var _isObscured;

  //=========================== STYLE ====================================\\

  //=========================== FOCUS NODES ====================================\\
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  //=========================== FUNCTIONS ====================================\\

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    await sendPostRequest(_emailController.text, _passwordController.text);

    setState(() {
      _isLoading = false;
    });
  }

  //=========================== REQUEST ====================================\\
  Future<bool> saveUserAndToken(String token) async {
    try {
      final someUserData = await http.get(Uri.parse('$baseURL/auth/'),
          headers: await authHeader(token));
      int userId = jsonDecode(someUserData.body)['id'];

      final userData = await http.get(
          Uri.parse('$baseURL/clients/getClient/$userId'),
          headers: await authHeader(token));

      await saveUser(userData.body, token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendPostRequest(String username, String password) async {
    final url = Uri.parse('$baseURL/auth/token');
    final body = {'username': username, 'password': password};

    final response = await http.post(url, body: body);

    dynamic token = jsonDecode(response.body)['token'];

    if (response.statusCode == 200 &&
        token.toString() != false.toString() &&
        await saveUserAndToken(token.toString())) {
      setState(() {
        _validAuthCredentials = true;
      });

      myFixedSnackBar(
        context,
        "Login Successful".toUpperCase(),
        kSuccessColor,
        const Duration(seconds: 2),
      );

      //Simulating a delay
      await Future.delayed(const Duration(seconds: 2));

      Get.offAll(
        () => const LoginSplashScreen(),
        routeName: 'LoginSplashScreen',
        predicate: (route) => false,
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.fadeIn,
      );
    } else {
      setState(() {
        _invalidAuthCredentials = true;
      });

      myFixedSnackBar(
        context,
        "Invalid email or password".toUpperCase(),
        kAccentColor,
        const Duration(seconds: 2),
      );
    }
  }

  //=========================== Navigation ====================================\\
  void _toSignUpPage() => Get.offAll(
        () => const SignUp(),
        routeName: 'SignUp',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        predicate: (routes) => false,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toForgotPasswordPage() => Get.to(
        () => const ForgotPassword(),
        routeName: 'ForgotPassword',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: LayoutGrid(
            columnSizes: breakPointDynamic(
              media.width,
              [1.fr],
              [1.fr],
              [1.fr, 1.fr],
              [1.fr, 1.fr],
            ),
            rowSizes: breakPointDynamic(
              media.width,
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
                          title: "Log In",
                          subtitle: "Please log in to your existing account",
                          curves: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          containerChild: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.unlockKeyhole,
                              color: kSuccessColor,
                              size: 80,
                              semanticLabel: "login__success_icon",
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: const OvalBorder(),
                          ),
                          imageContainerHeight:
                              deviceType(media.width) > 2 ? 200 : 120,
                        );
                      } else {
                        if (_invalidAuthCredentials) {
                          return ReusableAuthenticationFirstHalf(
                            title: "Log In",
                            subtitle: "Please log in to your existing account",
                            curves: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            containerChild: Center(
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                color: kAccentColor,
                                size: 80,
                                semanticLabel: "invalid_icon",
                              ),
                            ),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: const OvalBorder(),
                            ),
                            imageContainerHeight:
                                deviceType(media.width) > 2 ? 200 : 120,
                          );
                        } else {
                          return ReusableAuthenticationFirstHalf(
                            title: "Log In",
                            subtitle: "Please log in to your existing account",
                            curves: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            containerChild: Center(
                              child: FaIcon(
                                FontAwesomeIcons.lock,
                                color: kSecondaryColor,
                                size: 80,
                                semanticLabel: "lock_icon",
                              ),
                            ),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: const OvalBorder(),
                            ),
                            imageContainerHeight:
                                deviceType(media.width) > 2 ? 200 : 120,
                          );
                        }
                      }
                    }(),
                  ),
                ],
              ),
              Container(
                height: media.height,
                width: media.width,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding / 2,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(breakPoint(media.width, 24, 24, 0, 0)),
                    topRight:
                        Radius.circular(breakPoint(media.width, 24, 24, 0, 0)),
                  ),
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
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
                                color: kTextBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          EmailTextFormField(
                            controller: _emailController,
                            emailFocusNode: _emailFocusNode,
                            textInputAction: TextInputAction.next,
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
                          kSizedBox,
                          const SizedBox(
                            child: Text(
                              'Password',
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          PasswordTextFormField(
                            controller: _passwordController,
                            passwordFocusNode: _passwordFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _isObscured,
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              RegExp passwordPattern = RegExp(
                                r'^.{8,}$',
                              );
                              if (value == null || value!.isEmpty) {
                                _passwordFocusNode.requestFocus();
                                return "Enter your password";
                              } else if (!passwordPattern.hasMatch(value)) {
                                return "Password must be at least 8 characters";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _passwordController.text = value;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: _isObscured
                                  ? const Icon(Icons.visibility_off_rounded)
                                  : Icon(
                                      Icons.visibility,
                                      color: kSecondaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    kHalfSizedBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _validAuthCredentials
                            ? null
                            : _toForgotPasswordPage,
                        child: Text(
                          "Forgot Password",
                          style: _validAuthCredentials
                              ? TextStyle(color: kTextGreyColor)
                              : TextStyle(color: kAccentColor),
                        ),
                      ),
                    ),
                    kSizedBox,
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
                                await loadData();
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              maximumSize:
                                  Size(MediaQuery.of(context).size.width, 62),
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 10,
                              shadowColor: kDarkGreyColor,
                            ),
                            child: Text(
                              "Log in".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                    kHalfSizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF646982),
                          ),
                        ),
                        TextButton(
                          onPressed: _toSignUpPage,
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: kAccentColor),
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    // Center(
                    //   child: Column(
                    //     children: [
                    //       const Text(
                    //         "Or log in with ",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           color: Color(0xFF646982),
                    //         ),
                    //       ),
                    //       kSizedBox,
                    //       InkWell(
                    //         borderRadius: BorderRadius.circular(10),
                    //         onTap: () {},
                    //         child: Container(
                    //           width: MediaQuery.of(context).size.width / 2,
                    //           height: 60,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             border: Border.all(color: kGreyColor1),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Container(
                    //                 height: 50,
                    //                 width: 50,
                    //                 decoration: const BoxDecoration(
                    //                   image: DecorationImage(
                    //                     image: AssetImage(
                    //                       "assets/icons/google-signup-icon.png",
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               const Text(
                    //                 "Google",
                    //                 style: TextStyle(
                    //                   color: kTextBlackColor,
                    //                   fontSize: 18,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       kSizedBox,
                    //     ],
                    //   ),
                    // ),
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
