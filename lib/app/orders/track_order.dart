import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../theme/colors.dart';
import '../call/call_screen.dart';
import '../delivery/delivery_map.dart';
import '../home/home.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  //================================================= ALL VARIABLES ========================================================\\

  //==================================================== CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();

  //=============================================== FUNCTIONS =================================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {}
  //========================================================================\\

  //=============================== NAVIGATION ======================================\\
  void _toHomeScreen() => Get.offAll(
        () => const Home(),
        routeName: 'Home',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: false,
        predicate: (routes) => false,
        transition: Transition.rightToLeft,
      );
  void _callCustomer() => Get.to(
        () => const CallPage(
          userImage: "rider/martins-okafor.png",
          userName: "Martins Okafor",
          userPhoneNumber: "08125374562",
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "CallPage",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toDeliveryMap() => Get.to(
        () => const DeliveryMap(),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "DeliveryMap",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        elevation: 0,
        title: "Track Order",
        toolbarHeight: 80,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: _toHomeScreen,
            icon: FaIcon(
              FontAwesomeIcons.house,
              size: 18,
              semanticLabel: "Home",
              color: kAccentColor,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: kAccentColor,
        semanticsLabel: "Pull to refresh",
        child: Scrollbar(
          controller: _scrollController,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(kDefaultPadding),
            children: [
              Container(
                width: mediaWidth,
                height: 105,
                padding: const EdgeInsets.all(kDefaultPadding / 2),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 24,
                      offset: Offset(0, 4),
                      spreadRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Received',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Dispatched',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Delivered',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kDefaultPadding / 2,
                        right: kDefaultPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: kAccentColor,
                              shape: const OvalBorder(),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 2,
                                  bottom: 2,
                                  left: 2,
                                  child: Container(
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: kPrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 4,
                              color: kAccentColor,
                            ),
                          ),
                          SizedBox(
                            width: 26,
                            height: 26,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 4,
                                  top: 4,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: ShapeDecoration(
                                      color: kAccentColor,
                                      shape: const OvalBorder(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: ShapeDecoration(
                                      shape: OvalBorder(
                                        side: BorderSide(
                                          width: 0.50,
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 1,
                              color: const Color(0xFFC4C4C4),
                            ),
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFC4C4C4),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 1,
                              color: const Color(
                                0xFFC4C4C4,
                              ),
                            ),
                          ),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 0.50,
                                  color: Color(0xFFC4C4C4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              kSizedBox,
              Container(
                width: mediaWidth,
                height: 103,
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                child: Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: deviceType(mediaWidth) > 2 ? 18 : 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: deviceType(mediaWidth) > 2
                                ? mediaWidth / 3
                                : mediaWidth / 1.5,
                            child: const Text(
                              'Order received by vendor',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kWidthSizedBox,
                          FaIcon(
                            FontAwesomeIcons.solidCircleCheck,
                            size: 14,
                            color: kAccentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              kSizedBox,
              Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: ShapeDecoration(
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                      'Order Details',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kSizedBox,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: ShapeDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/products/chizzy's-food.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        kHalfWidthSizedBox,
                        Column(
                          children: [
                            SizedBox(
                              width: mediaWidth / 2,
                              child: const Text(
                                "Chizzy's Food",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            kSizedBox,
                            Row(
                              children: [
                                SizedBox(
                                  width: mediaWidth / 4,
                                  child: const Text(
                                    '3 Item (s)',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                kWidthSizedBox,
                                SizedBox(
                                  width: mediaWidth / 5,
                                  child: Text(
                                    'Waiting',
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            kSizedBox,
                            SizedBox(
                              width: mediaWidth / 2,
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.solidCircleCheck,
                                    color: kSuccessColor,
                                    size: 18,
                                  ),
                                  kHalfWidthSizedBox,
                                  SizedBox(
                                    width: mediaWidth / 5,
                                    child: const Text(
                                      'Paid',
                                      style: TextStyle(
                                        color: kTextBlackColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    kHalfSizedBox,
                    Divider(color: kGreyColor, thickness: 1),
                    kHalfSizedBox,
                    const Text(
                      'Delivery Officer',
                      style: TextStyle(
                        color: kTextBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    kHalfSizedBox,
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      onTap: null,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/rider/martins-okafor.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: mediaWidth / 2.2,
                            child: const Text(
                              'Martins Okafor ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: kTextBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.locationCrosshairs,
                                size: 14,
                                color: kGreyColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '3.2km away',
                                style: TextStyle(
                                  color: kTextGreyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      trailing: Container(
                        height: 50,
                        width: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFDD5D5),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.40, color: Color(0xFFD4DAF0)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: IconButton(
                          splashRadius: 30,
                          onPressed: _callCustomer,
                          icon: FaIcon(
                            FontAwesomeIcons.phone,
                            color: kAccentColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    kSizedBox,
                    InkWell(
                      onTap: _toDeliveryMap,
                      child: Container(
                        width: mediaWidth,
                        height: 50,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 0.50,
                              color: Color(0xFFDADADA),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 14,
                              color: kGreyColor,
                            ),
                            kHalfWidthSizedBox,
                            const SizedBox(
                              width: 90,
                              child: Text(
                                'View on map',
                                style: TextStyle(
                                  color: kTextBlackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              kSizedBox,
              const SizedBox(
                height: kDefaultPadding * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
