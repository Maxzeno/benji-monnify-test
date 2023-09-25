import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

void mySnackBar(
  BuildContext context,
  Color indicatorColor,
  String title,
  String message,
  Duration duration,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Container(
              height: 50,
              width: 10,
              decoration: ShapeDecoration(
                color: indicatorColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.0),
                    bottom: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
          kHalfWidthSizedBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextBlackColor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  message.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: kGreyColor1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: MediaQuery.of(context).size.height - 170,
      ),
      showCloseIcon: true,
      closeIconColor: kAccentColor,
      behavior: SnackBarBehavior.floating,
      backgroundColor: kPrimaryColor,
      elevation: 20.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
          bottom: Radius.circular(20.0),
        ),
      ),
    ),
  );
}
