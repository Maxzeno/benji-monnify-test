import 'package:flutter/material.dart';

import '../../providers/constants.dart';
import '../../../theme/colors.dart';

class SeeAllContainer extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const SeeAllContainer({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(
                0xFF222222,
              ),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.40,
            ),
          ),
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(
              20,
            ),
            enableFeedback: true,
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFFEF8F8,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'See all',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kAccentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: kAccentColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
