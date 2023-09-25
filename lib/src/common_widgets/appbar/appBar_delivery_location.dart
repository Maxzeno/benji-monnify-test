import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../providers/responsive_constant.dart';

class AppBarDeliveryLocation extends StatelessWidget {
  final String deliveryLocation;
  final Function() toDeliverToPage;
  const AppBarDeliveryLocation({
    super.key,
    required this.deliveryLocation,
    required this.toDeliverToPage,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          InkWell(
            onTap: toDeliverToPage,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Address',
                  style: TextStyle(
                    color: kAccentColor,
                    fontSize: deviceType(media.width) > 2 ? 16 : 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: deviceType(media.width) > 2
                      ? max(100, media.width - 700)
                      : max(100, media.width - 250),
                  child: Text(
                    deliveryLocation,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: deviceType(media.width) > 2 ? 16 : 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: deviceType(media.width) > 2 ? 26 : 14,
            color: kAccentColor,
          ),
        ],
      ),
    );
  }
}
