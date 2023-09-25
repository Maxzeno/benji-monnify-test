import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class CallPage extends StatefulWidget {
  final String userName;
  final String userImage;
  final String userPhoneNumber;
  const CallPage(
      {Key? key,
      required this.userName,
      required this.userImage,
      required this.userPhoneNumber})
      : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
//============================================= INITIAL STATE AND DISPOSE =========================================\\
  @override
  void initState() {
    _phoneConnecting = true;
    _phoneRinging = false;
    _callConnected = false;
    _callDropped = false;

    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callConnected) {
        setState(() {
          _callDuration++;
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _phoneConnecting = false;
        _phoneRinging = true;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _phoneRinging = false;
        _callConnected = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _callTimer.cancel();
    super.dispose();
  }

//============================================= ALL VARAIBLES =========================================\\
  int _callDuration = 0;
  late Timer _callTimer;

//============================================= BOOL VALUES =========================================\\
  late bool _phoneConnecting;
  late bool _phoneRinging;
  late bool _callConnected;
  late bool _callDropped;
  // bool _bluetoothIconIsVisible = false;
  bool _phoneSpeakerOn = false;
  bool _phoneBluetoothOn = false;
  bool _phoneMicOn = true;

//============================================= CONTROLLERS =========================================\\

//============================================= FUNCTIONS =========================================\\

  String _formatDuration() {
    int minutes = _callDuration ~/ 60;
    int seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _totalCallDuration() {
    int minutes = _callDuration ~/ 60;
    int seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _phoneSpeakerFunc() {
    setState(() {
      _phoneSpeakerOn = !_phoneSpeakerOn;
      _phoneBluetoothOn = false;
    });
  }

  void _bluetoothFunc() {
    setState(() {
      _phoneBluetoothOn = !_phoneBluetoothOn;
      _phoneSpeakerOn = false;
    });
  }

  void _microphoneFunc() {
    setState(() {
      _phoneMicOn = !_phoneMicOn;
    });
  }

  Future<void> _endCallFunc() async {
    setState(() {
      _callConnected = false;
      _callDropped = true;
    });

    //Cause a delay before popping context
    await Future.delayed(const Duration(milliseconds: 300));
    //Pop context
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "",
        elevation: 0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(kDefaultPadding),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: ShapeDecoration(
                      color: kPageSkeletonColor,
                      image: DecorationImage(
                        image: AssetImage("assets/images/${widget.userImage}"),
                        fit: BoxFit.cover,
                      ),
                      shape: const OvalBorder(),
                    ),
                  ),
                  kSizedBox,
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  kSizedBox,
                  Text(
                    widget.userPhoneNumber,
                    style: const TextStyle(
                      color: kTextBlackColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 1,
                    ),
                  ),
                  kSizedBox,
                  if (_phoneConnecting)
                    Text(
                      "Connecting...",
                      style: TextStyle(
                        color: kLoadingColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  if (_phoneRinging)
                    Text(
                      "Ringing...",
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  if (_callConnected)
                    Column(
                      children: [
                        const Text(
                          "Call connected",
                          style: TextStyle(
                            color: kSuccessColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.32,
                          ),
                        ),
                        kSizedBox,
                        Text(_formatDuration()),
                      ],
                    ),
                  if (_callDropped)
                    Text(
                      "Call ended",
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.32,
                      ),
                    ),
                  kSizedBox,
                  if (_callDropped)
                    Text(
                      _totalCallDuration(),
                      style: TextStyle(color: kAccentColor),
                    ),
                  const SizedBox(height: kDefaultPadding * 6),
                  if (_phoneConnecting)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFDD5D5),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFD4DAF0)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: IconButton(
                        splashRadius: 40,
                        onPressed: _endCallFunc,
                        icon: FaIcon(
                          Icons.call_end,
                          size: 36,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  if (_phoneRinging)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFDD5D5),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.40, color: Color(0xFFD4DAF0)),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: IconButton(
                        splashRadius: 40,
                        onPressed: _endCallFunc,
                        icon: FaIcon(
                          Icons.call_end,
                          size: 36,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  if (_callConnected)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 40,
                            onPressed: _phoneSpeakerFunc,
                            icon: _phoneSpeakerOn
                                ? FaIcon(
                                    FontAwesomeIcons.phoneVolume,
                                    color: kSecondaryColor,
                                  )
                                : FaIcon(
                                    FontAwesomeIcons.phoneVolume,
                                    color: kGreyColor,
                                  ),
                          ),
                        ),
                        kWidthSizedBox,
                        Container(
                          height: 60,
                          width: 60,
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 40,
                            onPressed: _bluetoothFunc,
                            icon: _phoneBluetoothOn
                                ? FaIcon(
                                    Icons.phone_bluetooth_speaker,
                                    color: kSecondaryColor,
                                    size: 32,
                                  )
                                : FaIcon(
                                    Icons.phone_bluetooth_speaker,
                                    color: kGreyColor,
                                    size: 32,
                                  ),
                          ),
                        ),
                        kWidthSizedBox,
                        Container(
                          height: 60,
                          width: 60,
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 40,
                            onPressed: _microphoneFunc,
                            icon: _phoneMicOn
                                ? FaIcon(
                                    FontAwesomeIcons.microphone,
                                    color: kSecondaryColor,
                                    size: 32,
                                  )
                                : FaIcon(
                                    FontAwesomeIcons.microphoneSlash,
                                    color: kGreyColor,
                                    size: 32,
                                  ),
                          ),
                        ),
                        kWidthSizedBox,
                        Container(
                          height: 60,
                          width: 60,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFDD5D5),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFD4DAF0)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: IconButton(
                            splashRadius: 40,
                            onPressed: _endCallFunc,
                            icon: FaIcon(
                              Icons.call_end,
                              size: 36,
                              color: kAccentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_callDropped) kSizedBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
