import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/button/my_outlined_elevatedbutton.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../splash_screens/payment_successful_screen.dart';

class BankTransfer extends StatefulWidget {
  final double totalPrice;
  const BankTransfer({super.key, required this.totalPrice});

  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
//==================================================== ALL VARIABLES ======================================================\\

//==================================================== BOOL VALUES ======================================================\\
  bool _processingBankTransfer = false;

//==================================================== COPY TO CLIPBOARD ======================================================\\
  final String _accountNumber = '9926374776';
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(text: _accountNumber),
    );

    //==================================================== SNACK BAR ======================================================\\

    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "Copied to clipboard",
      const Duration(
        seconds: 2,
      ),
    );
  }

  void _paymentFunc() async {
    setState(() {
      _processingBankTransfer = true;
    });

    //Simulate a delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _processingBankTransfer = false;
    });

    Get.to(
      () => const PaymentSuccessful(),
      routeName: 'PaymentSuccessful',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: kLightGreyColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bank Transfer',
                  style: TextStyle(
                    color: kTextBlackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                kSizedBox,
                Text(
                  'Please transfer the money to the bank account below',
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                kSizedBox,
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'ACCOUNT NUMBER',
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: SizedBox(
                    width: mediaWidth / 1.2,
                    child: Text(
                      _accountNumber,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kAccentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  trailing: OutlinedButton(
                    onPressed: () {
                      _copyToClipboard(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: kAccentColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: kAccentColor,
                      ),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.copy,
                          color: kAccentColor,
                          size: 18,
                        ),
                        kHalfWidthSizedBox,
                        Text(
                          'copy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(color: kGreyColor1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.bakery_dining_sharp,
                    color: kAccentColor,
                    size: 40,
                  ),
                  title: Text(
                    'BANK NAME',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: SizedBox(
                    width: mediaWidth / 1.2,
                    child: const Text(
                      'Guarantee Trust Bank',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'ACCOUNT NAME',
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: SizedBox(
                    width: mediaWidth / 1.2,
                    child: const Text(
                      'Leticia Ikaegbu',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          kSizedBox,
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Amount to Pay:',
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '₦ ${formattedText(widget.totalPrice)}',
                          style: const TextStyle(
                            fontFamily: 'sen',
                            color: kTextBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  )),
              kSizedBox,
              _processingBankTransfer
                  ? SpinKitChasingDots(color: kAccentColor)
                  : MyOutlinedElevatedButton(
                      onPressed: _paymentFunc,
                      title: 'I have made the transfer',
                    ),
            ],
          )
        ],
      ),
    );
  }
}
