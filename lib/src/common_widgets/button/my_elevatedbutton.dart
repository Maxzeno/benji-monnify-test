import 'package:flutter/material.dart';

import '../../../theme/colors.dart';

class MyElevatedButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const MyElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccentColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: kBlackColor.withOpacity(0.4),
        minimumSize: Size(mediaWidth, 60),
      ),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 18,
          fontFamily: "Sen",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
