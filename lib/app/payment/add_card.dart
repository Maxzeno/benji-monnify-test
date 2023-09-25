import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/common_widgets/textformfield/card_expiry_textformfield.dart';
import '../../src/common_widgets/textformfield/flex_textfield.dart';
import '../../src/common_widgets/textformfield/name_textformfield.dart';
import '../../src/common_widgets/textformfield/number_textformfield.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/credit_card/credit_card.dart';
import '../../src/repo/models/user/user_model.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  //=========================== CONTROLLER ====================================\\
  final _scrollController = ScrollController();

  //=========================== KEYS ====================================\\
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController cardNumberEC = TextEditingController();
  TextEditingController cvvEC = TextEditingController();
  TextEditingController cardHoldersFullNameEC = TextEditingController();
  TextEditingController cardMonthEC = TextEditingController();
  TextEditingController cardYearEC = TextEditingController();

  //=========================== FOCUS NODES ====================================\\

  FocusNode cardNumberFN = FocusNode();
  FocusNode cvvFN = FocusNode();
  FocusNode cardHoldersFullNameFN = FocusNode();
  FocusNode rateVendorFN = FocusNode();
  FocusNode cardMonthFN = FocusNode();
  FocusNode cardYearFN = FocusNode();

  //=========================== VARIABLES ====================================\\

  //=========================== BOOL VALUES ====================================\\
  bool _isSavingCard = false;

  //=========================== FUNCTIONS ====================================\\

  Future<bool> addCard() async {
    User? user = await getUser();
    Map body = {
      'card_name': cardHoldersFullNameEC.text,
      'card_number': cardNumberEC.text.replaceAll('-', ''),
      'cvv': cvvEC.text,
      'expiry_month': cardMonthEC.text,
      'expiry_year': cardYearEC.text,
    };

    try {
      await createCreditCard(user!.id, body);
      return true;
    } catch (e) {
      return false;
    }
  }

  //Save the card

  _saveCard() async {
    setState(() {
      _isSavingCard = true;
    });
    await checkAuth(context);

    if (await addCard()) {
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Card has been added successfully",
        const Duration(seconds: 1),
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.back();

      setState(() {
        _isSavingCard = false;
      });
    } else {
      mySnackBar(
        context,
        kErrorColor,
        "Failed!",
        "Failed to add card",
        const Duration(seconds: 1),
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.back();

      setState(() {
        _isSavingCard = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Add New Card",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              children: [
                deviceType(media.width) > 3 && deviceType(media.width) < 5
                    ? Lottie.asset("assets/animations/credit_card/frame_1.json",
                        height: 250)
                    : Lottie.asset(
                        "assets/animations/credit_card/frame_1.json"),
                kSizedBox,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      NumberTextFormField(
                        controller: cardNumberEC,
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(22),
                          FilteringTextInputFormatter.digitsOnly,
                          _CreditCardNumberInputFormatter(),
                        ],
                        validator: (value) {
                          RegExp cardPattern =
                              RegExp(r'^(\d{4}-){3}\d{4}|\d{16,18}$');
                          if (value == null || value!.isEmpty) {
                            cardNumberFN.requestFocus();
                            return "Card Number";
                          } else if (!cardPattern.hasMatch(value)) {
                            cardNumberFN.requestFocus();
                            return "Invalid Card number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          cardNumberEC.text = value;
                        },
                        textInputAction: TextInputAction.next,
                        nameFocusNode: cardNumberFN,
                        hintText: "Card Number",
                      ),
                      kSizedBox,
                      Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: MyCardExpiryTextFormField(
                                      controller: cardMonthEC,
                                      hintText: "MM",
                                      textInputAction: TextInputAction.next,
                                      onSaved: (value) {
                                        cardMonthEC.text = value;
                                      },
                                      onChanged: (value) {
                                        if (value.length == 2) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          cardMonthFN.requestFocus();
                                          return "Month";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    ' / ',
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: MyCardExpiryTextFormField(
                                      controller: cardYearEC,
                                      hintText: "YY",
                                      textInputAction: TextInputAction.next,
                                      onSaved: (value) {
                                        cardYearEC.text = value;
                                      },
                                      onChanged: (value) {
                                        if (value.length == 2) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value!.isEmpty) {
                                          cardYearFN.requestFocus();
                                          return "Year";
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 1),
                          Expanded(
                            flex: 10,
                            child: MyFlexTextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: cvvEC,
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                cvvEC.text = value;
                              },
                              onChanged: (value) {
                                if (value.length == 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              validator: (value) {
                                RegExp cvvPattern = RegExp(
                                  r"^\d{3,4}$",
                                );

                                if (value == null || value!.isEmpty) {
                                  cvvFN.requestFocus();
                                  return "CVV";
                                } else if (!cvvPattern.hasMatch(value)) {
                                  cvvFN.requestFocus();
                                  return "Invalid CVV";
                                }
                                return null;
                              },
                              hintText: 'CVV',
                            ),
                          ),
                        ],
                      ),
                      kSizedBox,
                      NameTextFormField(
                        controller: cardHoldersFullNameEC,
                        textInputAction: TextInputAction.go,
                        nameFocusNode: cardHoldersFullNameFN,
                        hintText: "Card Holder's full name",
                        validator: (value) {
                          // RegExp cardPattern = RegExp(
                          //   r'^.{3,}$', //Min. of 3 characters
                          // );
                          RegExp cardHoldersNamePattern = RegExp(
                            r"^[A-Za-z]+(?:\s+[A-Za-z]+)*$",
                          );
                          if (value == null || value!.isEmpty) {
                            cardHoldersFullNameFN.requestFocus();
                            return "Card Holder's full name";
                          } else if (!cardHoldersNamePattern.hasMatch(value)) {
                            return "Invalid Name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          cardHoldersFullNameEC.text = value;
                        },
                      ),
                      const SizedBox(height: kDefaultPadding * 2),
                      _isSavingCard
                          ? Center(
                              child: SpinKitChasingDots(color: kAccentColor),
                            )
                          : MyElevatedButton(
                              title: "Save card",
                              onPressed: (() async {
                                if (_formKey.currentState!.validate()) {
                                  await _saveCard();
                                }
                              }),
                            ),
                      const SizedBox(height: kDefaultPadding * 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CreditCardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digits and non-letters
    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Insert a dash after every four characters
    final formattedText = cleanText.replaceAllMapped(
        RegExp(r'(\d{4})(?=\d)(?!\d*-$)'), (match) => '${match[1]}-');

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
