import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import '../../providers/responsive_constant.dart';

class VendorsCard extends StatelessWidget {
  final Function() onTap;
  final bool removeDistance;
  final String cardImage, vendorName, typeOfBusiness, rating, distance;
  const VendorsCard({
    super.key,
    required this.onTap,
    required this.vendorName,
    required this.typeOfBusiness,
    required this.rating,
    required this.cardImage,
    this.distance = "",
    this.removeDistance = false,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceType(media.width) > 2
                  ? media.width / 3
                  : media.width / 2,
              height: 128,
              decoration: BoxDecoration(
                color: kPageSkeletonColor,
                image: DecorationImage(
                  image: AssetImage(cardImage),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7.20),
                  topRight: Radius.circular(7.20),
                ),
              ),
            ),
            kHalfSizedBox,
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceType(media.width) > 2
                        ? media.width / 5.5
                        : media.width / 2.5,
                    child: Text(
                      vendorName,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.40,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  SizedBox(
                    width: deviceType(media.width) > 2
                        ? media.width / 5.5
                        : media.width / 2.5,
                    child: Text(
                      typeOfBusiness,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  SizedBox(
                    width: deviceType(media.width) > 2
                        ? media.width / 5.5
                        : media.width / 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: kStarColor,
                          size: 15,
                        ),
                        const SizedBox(width: 4.0),
                        SizedBox(
                          child: Text(
                            rating,
                            style: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        removeDistance == true
                            ? const SizedBox()
                            : FaIcon(
                                FontAwesomeIcons.solidClock,
                                color: kAccentColor,
                                size: 15,
                              ),
                        removeDistance == true
                            ? const SizedBox()
                            : const SizedBox(width: 4.0),
                        removeDistance == true
                            ? const SizedBox()
                            : SizedBox(
                                width: deviceType(media.width) > 2 ? 80 : 60,
                                child: Text(
                                  distance,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.28,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
