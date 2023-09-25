import 'package:benji_user/src/repo/models/order/order.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class TrackOrderDetailsContainer extends StatelessWidget {
  final Order order;
  TrackOrderDetailsContainer({
    super.key,
    required this.order,
  });

  String shortenUuid(String uuid) {
    const int truncationLength = 6; // Number of characters to keep on each end
    final String shortenedUuid =
        "${uuid.substring(0, truncationLength)}...${uuid.substring(uuid.length - truncationLength)}";
    return shortenedUuid;
  }

  String intToMonth(int monthNumber) {
    List<String> months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    if (monthNumber >= 1 && monthNumber <= 12) {
      return months[monthNumber];
    } else {
      throw Exception("Invalid month number");
    }
  }

  final Map statusColor = {
    'pend': kLoadingColor,
    'comp': kSuccessColor,
    'canc': kAccentColor,
  };

  final Map status = {
    'pend': 'PENDING',
    'comp': 'COMPLETED',
    'canc': 'CANCELLED',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 104,
      decoration: ShapeDecoration(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.50,
            color: Color(0xFFF0F0F0),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          kDefaultPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      status[order.deliveryStatus.toLowerCase()] ?? "Not Available",
                      style: TextStyle(
                        color: statusColor[order.deliveryStatus.toLowerCase()] ?? kSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    kHalfWidthSizedBox,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                    ),
                    kHalfWidthSizedBox,
                    Text(
                      '${order.orderItems.length} items',
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${intToMonth(order.created.month)} ${order.created.day}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    kHalfWidthSizedBox,
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC4C4C4),
                        shape: OvalBorder(),
                      ),
                    ),
                    kHalfWidthSizedBox,
                    Text(
                      '${order.created.minute}:${order.created.second}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shortenUuid(order.id),
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "₦ ${formattedText(order.totalPrice.toDouble())}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
