import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../../src/providers/constants.dart';
import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/common_widgets/textformfield/message_textformfield.dart';
import '../../theme/colors.dart';

class ReportProduct extends StatefulWidget {
  final Product product;
  const ReportProduct({
    super.key,
    required this.product,
  });

  @override
  State<ReportProduct> createState() => _ReportProductState();
}

class _ReportProductState extends State<ReportProduct> {
  //============================================ ALL VARIABLES ===========================================\\

  //============================================ BOOL VALUES ===========================================\\
  bool _submittingRequest = false;

  //============================================ CONTROLLERS ===========================================\\
  final TextEditingController _messageEC = TextEditingController();

  //============================================ FOCUS NODES ===========================================\\
  final FocusNode _messageFN = FocusNode();

  //============================================ KEYS ===========================================\\
  final GlobalKey<FormState> _formKey = GlobalKey();

  //============================================ FUNCTIONS ===========================================\\
  Future<bool> report() async {
    User? user = await getUser();
    final url = Uri.parse('$baseURL/products/reportProduct');

    Map body = {
      'client_id': user!.id.toString(),
      'vendor_id': widget.product.vendorId.id.toString(),
      'product_id': widget.product.id.toString(),
      'comment': _messageEC.text.toString(),
    };

    final response =
        await http.post(url, body: body, headers: await authHeader());
    try {
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submitRequest() async {
    setState(() {
      _submittingRequest = true;
    });
    await checkAuth(context);

    bool res = await report();

    if (res) {
      //Display snackBar
      mySnackBar(
        context,
        kSuccessColor,
        "Success",
        "Your report has been submitted successfully",
        const Duration(seconds: 1),
      );

      setState(() {
        _submittingRequest = false;
      });

      //Go back;
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } else {
      setState(() {
        _submittingRequest = false;
      });
      mySnackBar(
        context,
        kAccentColor,
        "Failed",
        "Something went wrong",
        const Duration(seconds: 1),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Help and support",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        bottomSheet: _submittingRequest
            ? SizedBox(
                height: 100,
                child: SpinKitChasingDots(color: kAccentColor),
              )
            : AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                color: kPrimaryColor,
                padding: const EdgeInsets.only(
                  top: kDefaultPadding,
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding,
                ),
                child: MyElevatedButton(
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      _submitRequest();
                    }
                  }),
                  title: "Submit",
                ),
              ),
        body: SafeArea(
          child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(child: SpinKitDoubleBounce(color: kAccentColor));
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(kDefaultPadding),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    width: 292,
                    child: Text(
                      'We will like to hear from you',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  SizedBox(
                    width: 332,
                    child: Text(
                      "What is wrong with this product?",
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyMessageTextFormField(
                          controller: _messageEC,
                          textInputAction: TextInputAction.done,
                          focusNode: _messageFN,
                          hintText: "Enter your message here",
                          maxLines: 10,
                          keyboardType: TextInputType.text,
                          maxLength: 6000,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              _messageFN.requestFocus();
                              return "Field cannot be left empty";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
