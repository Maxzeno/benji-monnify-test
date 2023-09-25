import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';

class HomePageVendorsNearYou extends StatelessWidget {
  final Function() onTap;
  const HomePageVendorsNearYou({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ListView.separated(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => kHalfWidthSizedBox,
        itemBuilder: (context, index) => InkWell(
          onTap: onTap,
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
                  width: 224,
                  height: 128,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/vendors/ntachi-osa.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
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
                      const SizedBox(
                        width: 200,
                        height: 26,
                        child: Text(
                          'Ntachi Osa',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.40,
                          ),
                        ),
                      ),
                      kHalfSizedBox,
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Restaurant",
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
                        width: 200,
                        height: 17,
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
                            const SizedBox(
                              width: 70,
                              child: Text(
                                '3.6 (100+)',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.28,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: kAccentColor,
                              size: 15,
                            ),
                            const SizedBox(width: 4.0),
                            const SizedBox(
                              width: 60,
                              child: Text(
                                '30 mins',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
        ),
      ),
    );
  }
}
