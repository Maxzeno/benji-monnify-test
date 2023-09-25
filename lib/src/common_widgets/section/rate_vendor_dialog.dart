import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import '../../providers/responsive_constant.dart';
import '../snackbar/my_floating_snackbar.dart';
import '../textformfield/message_textformfield.dart';

class RateVendorDialog extends StatefulWidget {
  final VendorModel vendor;

  const RateVendorDialog({super.key, required this.vendor});

  @override
  State<RateVendorDialog> createState() => _RateVendorDialogState();
}

class _RateVendorDialogState extends State<RateVendorDialog> {
//===================================== ALL VARIABLES ======================================\\
  var _starPosition = 250.0;
  final _starPosition2 = 200.0;
  final _starPosition3 = 210.0;
  var _rating = 0.0;

//===================================== BOOL VALUES ======================================\\
  bool _pageChanged = false;
  bool _submittingRequest = false;

//===================================== KEYS ======================================\\
  final _formKey = GlobalKey<FormState>();

//===================================== CONTROLLERS ======================================\\
  final _ratingPageController = PageController();
  final _myMessageEC = TextEditingController();

//===================================== FOCUS NODES ======================================\\
  final _myMessageFN = FocusNode();

//===================================== FUNCTIONS ======================================\\
  Future<bool> rate() async {
    User? user = await getUser();
    final url = Uri.parse('$baseURL/clients/clientRateVendor');

    Map body = {
      'client_id': user!.id.toString(),
      'vendor_id': widget.vendor.id.toString(),
      'rating_value': _rating.toInt().toString(),
      'comment': _myMessageEC.text
    };
    final response =
        await http.post(url, body: body, headers: await authHeader());

    try {
      bool res = response.statusCode == 200;
      return res;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submitRequest() async {
    setState(() {
      _submittingRequest = true;
    });
    await checkAuth(context);

    bool res = await rate();
    if (res) {
      //Display snackBar
      mySnackBar(
        context,
        kSuccessColor,
        "Success",
        "Your review has been submitted successfully",
        const Duration(seconds: 1),
      );
      setState(() {
        _submittingRequest = false;
      });
      //Go back;
      Get.back();
    } else {
      mySnackBar(
        context,
        kAccentColor,
        "Failed",
        "An error occurred",
        const Duration(seconds: 1),
      );
      setState(() {
        _submittingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(kDefaultPadding)),
        child: Stack(
          children: [
            AnimatedContainer(
              height: _pageChanged
                  ? deviceType(mediaWidth) > 3 && deviceType(mediaWidth) < 5
                      ? mediaHeight * 0.75
                      : deviceType(mediaWidth) > 2
                          ? mediaHeight * 0.58
                          : mediaHeight * 0.5
                  : deviceType(mediaWidth) > 3 && deviceType(mediaWidth) < 5
                      ? mediaHeight * 0.35
                      : deviceType(mediaWidth) > 2
                          ? mediaHeight * 0.25
                          : mediaHeight * 0.45,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              padding: const EdgeInsets.all(kDefaultPadding),
              child: PageView(
                controller: _ratingPageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildThanksNote(),
                  _submittingRequest
                      ? SpinKitChasingDots(color: kAccentColor)
                      : _causeOfRating(
                          _myMessageEC,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be left empty";
                            }
                            return null;
                          },
                          _myMessageFN,
                          _formKey,
                        ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: _pageChanged == false ? kGreyColor1 : kAccentColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(kDefaultPadding),
                    bottomRight: Radius.circular(kDefaultPadding),
                  ),
                ),
                child: _pageChanged == false
                    ? MaterialButton(
                        enableFeedback: true,
                        onPressed: null,
                        disabledElevation: 0.0,
                        disabledColor: kGreyColor1,
                        disabledTextColor: kTextBlackColor,
                        mouseCursor: SystemMouseCursors.click,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(kDefaultPadding),
                            bottomRight: Radius.circular(kDefaultPadding),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      )
                    : MaterialButton(
                        enableFeedback: true,
                        onPressed: (() async {
                          if (_formKey.currentState!.validate()) {
                            _submitRequest();
                          }
                        }),
                        mouseCursor: SystemMouseCursors.click,
                        color: kAccentColor,
                        height: 50,
                        focusElevation: kDefaultPadding,
                        focusColor: kAccentColor,
                        hoverElevation: 10.0,
                        hoverColor: kAccentColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(kDefaultPadding),
                            bottomRight: Radius.circular(kDefaultPadding),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
              ),
            ),
            AnimatedPositioned(
              top: deviceType(mediaWidth) > 3 && deviceType(mediaWidth) < 5
                  ? _starPosition3
                  : deviceType(mediaWidth) > 2
                      ? _starPosition2
                      : _starPosition,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    onPressed: () {
                      _ratingPageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );

                      setState(
                        () {
                          _starPosition = deviceType(mediaWidth) > 2 &&
                                  deviceType(mediaWidth) < 5
                              ? 1
                              : 10;
                          _rating = index + 1;
                          _pageChanged = true;
                        },
                      );
                    },
                    color: kStarColor,
                    icon: index < _rating
                        ? const FaIcon(FontAwesomeIcons.solidStar, size: 30)
                        : const FaIcon(FontAwesomeIcons.star, size: 26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_buildThanksNote() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "We'd love to get your feedback",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          color: kAccentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      kHalfSizedBox,
      const Text(
        "Rate this vendor",
      ),
    ],
  );
}

_causeOfRating(
  final TextEditingController controller,
  final FormFieldValidator validator,
  final FocusNode focusNode,
  final Key formKey,
) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Visibility(
        visible: true,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        maintainInteractivity: true,
        maintainSemantics: true,
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              kSizedBox,
              kSizedBox,
              const SizedBox(height: 20, child: Text("What could be better?")),
              kHalfSizedBox,
              SizedBox(
                height: 250,
                child: MyMessageTextFormField(
                  controller: controller,
                  validator: validator,
                  textInputAction: TextInputAction.newline,
                  focusNode: focusNode,
                  hintText: "Enter your review (required)",
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  maxLength: 6000,
                ),
              ),
              kSizedBox,
              kSizedBox,
            ],
          ),
        ),
      ),
    ],
  );
}
