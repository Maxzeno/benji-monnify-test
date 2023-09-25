import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/repo/models/rating/ratings.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:benji_user/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/rating_view/customer_review_card.dart';
import '../../src/providers/constants.dart';
import 'all_vendor_reviews.dart';

class AboutVendor extends StatefulWidget {
  final VendorModel vendor;
  const AboutVendor({
    super.key,
    required this.vendor,
  });

  @override
  State<AboutVendor> createState() => _AboutVendorState();
}

class _AboutVendorState extends State<AboutVendor> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  final List<String> stars = ['5', '4', '3', '2', '1'];
  String active = 'all';

  List<Ratings>? _ratings = [];
  _getData() async {
    setState(() {
      _ratings = null;
    });

    List<Ratings> ratings;
    if (active == 'all') {
      ratings = await getRatingsByVendorId(widget.vendor.id!);
    } else {
      ratings = await getRatingsByVendorIdAndRating(
          widget.vendor.id!, int.parse(active));
    }

    setState(() {
      _ratings = ratings;
    });
  }

  void _viewAllReviews() => Get.to(
        () => AllVendorReviews(vendor: widget.vendor),
        routeName: 'AllVendorReviews',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    // double mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About This Business",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
            child: Text(
              widget.vendor.shopType == null
                  ? 'Not Available'
                  : widget.vendor.shopType!.description ?? 'Not Available',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          kSizedBox,
          const Text(
            "Working Hours",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Mon. - Fri.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Row(
                      children: [
                        Text(
                          "Sat.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Row(
                      children: [
                        Text(
                          "Sun.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        kHalfWidthSizedBox,
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          kSizedBox,
          Container(
            width: mediaWidth,
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: ShapeDecoration(
              color: const Color(0xFFFEF8F8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 0.50,
                  color: Color(0xFFFDEDED),
                ),
                borderRadius: BorderRadius.circular(25),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reviews View & Ratings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                    horizontal: kDefaultPadding * 0.5,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: active == 'all'
                                  ? kAccentColor
                                  : const Color(
                                      0xFFA9AAB1,
                                    ),
                            ),
                            backgroundColor:
                                active == 'all' ? kAccentColor : kPrimaryColor,
                            foregroundColor: active == 'all'
                                ? kPrimaryColor
                                : const Color(0xFFA9AAB1),
                          ),
                          onPressed: () async {
                            active = 'all';
                            setState(() {
                              _ratings = null;
                            });

                            List<Ratings> ratings =
                                await getRatingsByVendorId(widget.vendor.id!);

                            setState(() {
                              ratings = ratings;
                            });
                          },
                          child: const Text(
                            'All',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Row(
                          children: stars
                              .map(
                                (item) => Row(
                                  children: [
                                    kHalfWidthSizedBox,
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: active == item
                                              ? kStarColor
                                              : const Color(0xFFA9AAB1),
                                        ),
                                        foregroundColor: active == item
                                            ? kStarColor
                                            : const Color(0xFFA9AAB1),
                                      ),
                                      onPressed: () async {
                                        active = item;

                                        setState(() {
                                          _ratings = null;
                                        });

                                        List<Ratings> ratings =
                                            await getRatingsByVendorIdAndRating(
                                                widget.vendor.id!,
                                                int.parse(active));

                                        setState(() {
                                          ratings = ratings;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: kDefaultPadding * 0.2,
                                          ),
                                          Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        kHalfWidthSizedBox,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          kSizedBox,
          _ratings == null
              ? Center(
                  child: SpinKitChasingDots(
                    color: kAccentColor,
                    duration: const Duration(seconds: 1),
                  ),
                )
              : _ratings!.isEmpty
                  ? const EmptyCard(
                      removeButton: true,
                    )
                  : Column(
                      children: [
                        ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => kSizedBox,
                          shrinkWrap: true,
                          itemCount: _ratings!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              CostumerReviewCard(rating: _ratings![index]),
                        ),
                        kSizedBox,
                        _ratings!.isEmpty
                            ? const SizedBox()
                            : TextButton(
                                onPressed: _viewAllReviews,
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                        kSizedBox,
                      ],
                    ),
        ],
      ),
    );
  }
}
