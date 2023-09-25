// ignore_for_file: unused_field

import 'package:benji_user/src/common_widgets/vendor/vendor_about_tab.dart';
import 'package:benji_user/src/common_widgets/vendor/vendor_products_tab.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:benji_user/src/repo/utils/favorite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/section/custom_showSearch.dart';
import '../../src/common_widgets/section/rate_vendor_dialog.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import 'report_vendor.dart';
import 'vendor_location.dart';

class VendorDetails extends StatefulWidget {
  final VendorModel vendor;
  const VendorDetails({
    super.key,
    required this.vendor,
  });

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
    getFavoriteVSingle(widget.vendor.id.toString()).then(
      (value) {
        setState(() {
          _isAddedToFavorites = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {});
  }

//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\
  int selectedRating = 0;

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== FOCUS NODES =======================\\
  FocusNode rateVendorFN = FocusNode();

//===================== BOOL VALUES =======================\\
  bool _isAddedToFavorites = false;

//================================================= FUNCTIONS ===================================================\\

  void _addToFavorites() async {
    bool val = await favoriteItV(widget.vendor.id.toString());
    setState(() {
      _isAddedToFavorites = val;
    });

    mySnackBar(
      context,
      kSuccessColor,
      "Success",
      _isAddedToFavorites
          ? "Vendor has been added to favorites"
          : "Vendor been removed from favorites",
      const Duration(milliseconds: 500),
    );
  }

  int _selectedtabbar = 0;
  void _clickOnTabBarOption(value) async {
    setState(() {
      _selectedtabbar = value;
    });
  }

//=================================== Show Popup Menu =====================================\\

//Show popup menu
  void showPopupMenu(BuildContext context) {
    // final RenderBox overlay =
    //     Overlay.of(context).context.findRenderObject() as RenderBox;
    const position = RelativeRect.fromLTRB(10, 60, 0, 0);

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem<String>(
          value: 'rate',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.solidStar, color: kStarColor),
              kWidthSizedBox,
              const Text("Rate this vendor"),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'report',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(FontAwesomeIcons.solidFlag, color: kAccentColor),
              kWidthSizedBox,
              const Text("Report this vendor"),
            ],
          ),
        ),
      ],
    ).then((value) {
      // Handle the selected value from the popup menu
      if (value != null) {
        switch (value) {
          case 'rate':
            openRatingDialog(context);
            break;
          case 'report':
            Get.to(
              () => ReportVendor(vendor: widget.vendor),
              routeName: 'ReportVendor',
              duration: const Duration(milliseconds: 300),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              preventDuplicates: true,
              popGesture: true,
              transition: Transition.rightToLeft,
            );
            break;
        }
      }
    });
  }

//================================ Rating Dialog ======================================\\
  openRatingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetAnimationCurve: Curves.easeIn,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding)),
          elevation: 50,
          child: RateVendorDialog(vendor: widget.vendor),
        );
      },
    );
    setState(() {});
  }

//=================================== Navigation =====================================\\

  void _toVendorLocation() => Get.to(
        () => VendorLocation(
          vendor: widget.vendor,
        ),
        routeName: 'VendorLocation',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        extendBody: true,
        appBar: MyAppBar(
          title: "Vendor Details",
          elevation: 0.0,
          backgroundColor: kPrimaryColor,
          toolbarHeight: 40,
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: _addToFavorites,
              icon: FaIcon(
                _isAddedToFavorites
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: kAccentColor,
              ),
            ),
            IconButton(
              onPressed: () => showPopupMenu(context),
              icon: FaIcon(
                FontAwesomeIcons.ellipsisVertical,
                color: kAccentColor,
              ),
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              controller: _scrollController,
              physics: const ScrollPhysics(),
              children: [
                SizedBox(
                  height:
                      deviceType(media.width) > 2 && deviceType(media.width) < 4
                          ? 540
                          : deviceType(media.width) > 2
                              ? 470
                              : 370,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.height * 0.325
                              : deviceType(media.width) > 2
                                  ? media.height * 0.305
                                  : media.height * 0.28,
                          decoration: BoxDecoration(
                            color: kPageSkeletonColor,
                            image: const DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                "assets/images/vendors/ntachi-osa.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 2
                            ? media.height * 0.21
                            : media.height * 0.13,
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(kDefaultPadding / 2),
                          decoration: ShapeDecoration(
                            shadows: [
                              BoxShadow(
                                color: kBlackColor.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                            color: const Color(0xFFFEF8F8),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 0.50,
                                color: Color(0xFFFDEDED),
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: kDefaultPadding * 2.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width - 200,
                                  child: Text(
                                    widget.vendor.shopName ?? 'Not Available',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                Container(
                                  width: media.width - 90,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationDot,
                                        color: kAccentColor,
                                        size: 15,
                                      ),
                                      kHalfWidthSizedBox,
                                      Text(
                                        widget.vendor.address ??
                                            'Not Available',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                kHalfSizedBox,
                                InkWell(
                                  onTap: widget.vendor.address == null
                                      ? null
                                      : _toVendorLocation,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        kDefaultPadding / 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: kAccentColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      widget.vendor.address == null
                                          ? "Not Available"
                                          : "Show on map",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                kHalfSizedBox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: media.width * 0.23,
                                      height: 57,
                                      decoration: ShapeDecoration(
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidStar,
                                            color: kStarColor,
                                            size: 17,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${(widget.vendor.averageRating ?? 0).toPrecision(1)}',
                                            style: const TextStyle(
                                              color: kBlackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -0.28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: media.width * 0.25,
                                      height: 57,
                                      decoration: ShapeDecoration(
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(19),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.vendor.isOnline ?? false
                                                ? "Online"
                                                : 'Offline',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: widget.vendor.isOnline ??
                                                      false
                                                  ? kSuccessColor
                                                  : kAccentColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: -0.36,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          FaIcon(
                                            Icons.info,
                                            color: kAccentColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.height * 0.12
                            : deviceType(media.width) > 2
                                ? media.height * 0.14
                                : media.height * 0.08,
                        left: deviceType(media.width) > 3 &&
                                deviceType(media.width) < 5
                            ? media.width / 2.24
                            : deviceType(media.width) > 2
                                ? media.width / 2.36
                                : media.width / 2.7,
                        child: Container(
                          width: deviceType(media.width) > 2 ? 150 : 100,
                          height: deviceType(media.width) > 2 ? 150 : 100,
                          decoration: ShapeDecoration(
                            color: kPageSkeletonColor,
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/vendors/ntachi-osa-logo.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: const OvalBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: deviceType(media.width) > 2
                      ? const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 6)
                      : const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 1.5),
                  child: Container(
                    width: media.width,
                    decoration: BoxDecoration(
                      color: kDefaultCategoryBackgroundColor,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: kLightGreyColor,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TabBar(
                            controller: _tabBarController,
                            onTap: (value) => _clickOnTabBarOption(value),
                            enableFeedback: true,
                            dragStartBehavior: DragStartBehavior.start,
                            mouseCursor: SystemMouseCursors.click,
                            automaticIndicatorColorAdjustment: true,
                            overlayColor:
                                MaterialStatePropertyAll(kAccentColor),
                            labelColor: kPrimaryColor,
                            unselectedLabelColor: kTextGreyColor,
                            indicatorColor: kAccentColor,
                            indicatorWeight: 2,
                            splashBorderRadius: BorderRadius.circular(50),
                            indicator: BoxDecoration(
                              color: kAccentColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            tabs: const [
                              Tab(text: "Products"),
                              Tab(text: "About"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  padding: deviceType(media.width) > 2
                      ? const EdgeInsets.symmetric(horizontal: 20)
                      : const EdgeInsets.symmetric(horizontal: 10),
                  child: _selectedtabbar == 0
                      ? VendorsProductsTab(
                          vendor: widget.vendor,
                        )
                      : VendorsAboutTab(
                          vendor: widget.vendor,
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
