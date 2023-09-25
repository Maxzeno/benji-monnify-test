// ignore_for_file: unused_local_variable

import 'package:benji_user/app/home/home.dart';
import 'package:benji_user/app/payment/payment_method.dart';
import 'package:benji_user/src/common_widgets/snackbar/my_floating_snackbar.dart';
import 'package:benji_user/src/repo/models/address_model.dart';
import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:benji_user/src/repo/utils/cart.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../address/deliver_to.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //=================================== INITIAL STATE ==========================================\\
  @override
  void initState() {
    super.initState();
    _getData();
  }

  //=================================== ALL VARIABLES ==========================================\\

  double deliveryFee = 700;
  double serviceFee = 0;
  // double insuranceFee = 0;
  // double discountFee = 0;

  //===================== GlobalKeys =======================\\

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //===================== CONTROLLERS =======================\\

  final ScrollController _scrollController = ScrollController();

  //===================== BOOL VALUES =======================\\
  final bool _isLoading = false;

  //===================== FUNCTIONS =======================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
    });
    await _getData();
  }

  Map? _data;
  double _subTotal = 0;
  double totalPrice = 0;

  _getData() async {
    _subTotal = 0;
    await checkAuth(context);
    List<Product> product = await getCartProduct(
      (data) => mySnackBar(
        context,
        kAccentColor,
        "Error!",
        "Item with id $data not found",
        const Duration(
          seconds: 1,
        ),
      ),
    );

    Map<String, dynamic> cartItems = await getCart();

    Address? deliverTo;
    try {
      deliverTo = await getCurrentAddress();
    } catch (e) {
      deliverTo = null;
    }

    for (Product item in product) {
      _subTotal += (item.price * cartItems[item.id]);
    }

    totalPrice = _subTotal + deliveryFee + serviceFee;

    setState(() {
      _data = {
        'deliverTo': deliverTo,
        'product': product,
        'cartItems': cartItems,
      };
    });
  }

  // COPY TO CLIPBOARD
  final String text = 'Generated Link code here';

  //PLACE ORDER

  void _placeOrder() async {
    Get.to(
      () => PaymentMethod(
        totalPrice: totalPrice,
      ),
      routeName: 'PaymentMethod',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

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

  void _toDeliverTo() async {
    await Get.to(
      () => const DeliverTo(inCheckout: true),
      routeName: 'DeliverTo',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    Address? deliverTo;
    try {
      deliverTo = await getCurrentAddress();
    } catch (e) {
      deliverTo = null;
    }
    setState(() {
      _data!['deliverTo'] = deliverTo;
    });
    // await _getData();
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        toolbarHeight: 80,
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        title: "Checkout",
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
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: _data == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitChasingDots(color: kAccentColor),
                    kSizedBox,
                    Text(
                      "Loading...",
                      style: TextStyle(
                        color: kTextGreyColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _handleRefresh,
                color: kAccentColor,
                displacement: kDefaultPadding,
                semanticsLabel: "Pull to refresh",
                child: () {
                  if (_data!['product'].isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Center(
                        child: Column(
                          children: [
                            kSizedBox,
                            Lottie.asset(
                              "assets/animations/empty/frame_2.json",
                            ),
                            kSizedBox,
                            Text(
                              "Oops!, Your cart is empty",
                              style: TextStyle(
                                color: kTextGreyColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            kSizedBox,
                            MyElevatedButton(
                              title: "Start shopping",
                              onPressed: _toHomeScreen,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Scrollbar(
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(kDefaultPadding),
                      children: [
                        const Text(
                          'Delivery location',
                          style: TextStyle(
                            color: kTextBlackColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        kSizedBox,
                        InkWell(
                          onTap: _toDeliverTo,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: mediaWidth,
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _data!['deliverTo'].title.toUpperCase() ??
                                          'Select location',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: kTextBlackColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    kSizedBox,
                                    Text(
                                      _data!['deliverTo'].streetAddress ??
                                          'Not Available',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: kTextGreyColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                FaIcon(
                                  FontAwesomeIcons.chevronRight,
                                  color: kAccentColor,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding * 2,
                        ),
                        Container(
                          child: const Text(
                            'Product Summary',
                            style: TextStyle(
                              color: kTextBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        kSizedBox,
                        Container(
                          width: mediaWidth,
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Scrollbar(
                                controller: _scrollController,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: _data!['product'].length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return kHalfSizedBox;
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width: mediaWidth,
                                      child: Text(
                                        '${_data!['cartItems'][_data!['product'][index].id]}x  ${_data!['product'][index].name}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kTextGreyColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        kSizedBox,
                        Container(
                          width: mediaWidth,
                          padding: const EdgeInsets.all(
                            kDefaultPadding,
                          ),
                          decoration: ShapeDecoration(
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  child: Text(
                                    'Payment Summary',
                                    style: TextStyle(
                                      color: kTextBlackColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Divider(height: 20, color: kGreyColor1),
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Subtotal',
                                              style: TextStyle(
                                                color: kTextBlackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '₦${formattedText(_subTotal)}',
                                              style: TextStyle(
                                                color: kTextGreyColor,
                                                fontSize: 16,
                                                fontFamily: 'Sen',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      kSizedBox,
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Delivery Fee',
                                              style: TextStyle(
                                                color: kTextBlackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '₦${formattedText(deliveryFee)}',
                                              style: TextStyle(
                                                color: kTextGreyColor,
                                                fontSize: 16,
                                                fontFamily: 'Sen',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      kSizedBox,
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Service Fee',
                                              style: TextStyle(
                                                color: kTextBlackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              '₦${formattedText(serviceFee)}',
                                              style: TextStyle(
                                                color: kTextGreyColor,
                                                fontSize: 16,
                                                fontFamily: 'Sen',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                kHalfSizedBox,
                                const Divider(height: 4, color: kGreyColor1),
                                kHalfSizedBox,
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total',
                                        style: TextStyle(
                                          color: kTextBlackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '₦${formattedText(totalPrice)}',
                                        style: TextStyle(
                                          color: kTextGreyColor,
                                          fontSize: 16,
                                          fontFamily: 'Sen',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: kDefaultPadding * 2),
                        _isLoading
                            ? Center(
                                child: SpinKitChasingDots(
                                  color: kAccentColor,
                                  duration: const Duration(seconds: 1),
                                ),
                              )
                            : MyElevatedButton(
                                title:
                                    "Place Order - ₦${formattedText(totalPrice)}",
                                onPressed: () {
                                  _placeOrder();
                                },
                              ),
                        kSizedBox,
                      ],
                    ),
                  );
                }(),
              ),
      ),
    );
  }
}


//======================================================= FUTURE REFERENCE ====================================================================\\

//====================================== Add Coupon ====================================\\

              // Container(
              //   width: mediaWidth,
              //   padding: EdgeInsets.all(
              //     kDefaultPadding,
              //   ),
              //   decoration: ShapeDecoration(
              //     color: kPrimaryColor,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     shadows: [
              //       BoxShadow(
              //         color: Color(0x0F000000),
              //         blurRadius: 24,
              //         offset: Offset(0, 4),
              //         spreadRadius: 0,
              //       ),
              //     ],
              //   ),
              //   child: Container(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Coupon',
              //           style: TextStyle(
              //             color: Color(
              //               0xFF151515,
              //             ),
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         kHalfSizedBox,
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           decoration: ShapeDecoration(
              //             shape: RoundedRectangleBorder(
              //               side: BorderSide(
              //                 width: 0.50,
              //                 strokeAlign: BorderSide.strokeAlignCenter,
              //                 color: Color(
              //                   0xFFEAEAEA,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         kHalfSizedBox,
              //         InkWell(
              //           onTap: () {
              //             Navigator.of(context).push(
              //               MaterialPageRoute(
              //                 builder: (context) => ApplyCoupon(),
              //               ),
              //             );
              //           },
              //           child: Container(
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Text(
              //                   'Add Coupon',
              //                   style: TextStyle(
              //                     color: Color(
              //                       0xFF151515,
              //                     ),
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.w400,
              //                   ),
              //                 ),
              //                 Container(
              //                   child: Row(
              //                     children: [
              //                       Container(
              //                         height: 24,
              //                         padding: const EdgeInsets.symmetric(
              //                           horizontal: 8,
              //                           vertical: 4,
              //                         ),
              //                         decoration: ShapeDecoration(
              //                           color: kAccentColor,
              //                           shape: RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(
              //                               8,
              //                             ),
              //                           ),
              //                         ),
              //                         child: Row(
              //                           mainAxisSize: MainAxisSize.min,
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.center,
              //                           children: [
              //                             Text(
              //                               'ADB1897',
              //                               style: TextStyle(
              //                                 color: kPrimaryColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w700,
              //                               ),
              //                             ),
              //                             const SizedBox(
              //                               width: 8,
              //                             ),
              //                             Text(
              //                               'x',
              //                               style: TextStyle(
              //                                 color: kPrimaryColor,
              //                                 fontSize: 12,
              //                                 fontWeight: FontWeight.w400,
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Icon(
              //                         Icons.arrow_forward_ios_rounded,
              //                         color: kAccentColor,
              //                         size: 16,
              //                       ),
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // kSizedBox,

//====================================== Pay for me ====================================\\

                  // MyOutlinedElevatedButton(
                  //   title: "Pay For Me\n (Coming soon 😊)",
                  //   onPressed: 
                  //   () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       backgroundColor: kPrimaryColor,
                  //       elevation: 20,
                  //       barrierColor: kBlackColor.withOpacity(
                  //         0.2,
                  //       ),
                  //       showDragHandle: true,
                  //       useSafeArea: true,
                  //       constraints: BoxConstraints(
                  //         maxHeight: MediaQuery.of(context).size.height * 0.8,
                  //         minHeight: MediaQuery.of(context).size.height * 0.5,
                  //       ),
                  //       isScrollControlled: true,
                  //       isDismissible: true,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.vertical(
                  //           top: Radius.circular(
                  //             kDefaultPadding,
                  //           ),
                  //         ),
                  //       ),
                  //       enableDrag: true,
                  //       builder: (context) => Container(
                  //         margin: EdgeInsets.symmetric(
                  //           horizontal: kDefaultPadding,
                  //         ),
                  //         // color: kAccentColor,
                  //         child: ListView(
                  //           physics: const BouncingScrollPhysics(),
                  //           scrollDirection: Axis.vertical,
                  //           children: [
                  //             Container(
                  //               height: 65,
                  //               padding: const EdgeInsets.all(
                  //                 8,
                  //               ),
                  //               child: Text(
                  //                 'Hey! share this link with your friends to have them pay for your order',
                  //                 style: TextStyle(
                  //                   color: Color(
                  //                     0xFF333333,
                  //                   ),
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w400,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: kDefaultPadding,
                  //             ),
                  //             Container(
                  //               height: 64,
                  //               padding: const EdgeInsets.only(
                  //                 top: 16,
                  //                 left: 17,
                  //                 right: 17,
                  //                 bottom: 18,
                  //               ),
                  //               decoration: ShapeDecoration(
                  //                 color: Color(
                  //                   0xFFFEF8F8,
                  //                 ),
                  //                 shape: RoundedRectangleBorder(
                  //                   side: BorderSide(
                  //                     width: 0.50,
                  //                     color: Color(
                  //                       0xFFFDEDED,
                  //                     ),
                  //                   ),
                  //                   borderRadius: BorderRadius.circular(
                  //                     10,
                  //                   ),
                  //                 ),
                  //               ),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceAround,
                  //                 children: [
                  //                   Text(
                  //                     text,
                  //                     style: TextStyle(
                  //                       color: kBlackColor,
                  //                       fontSize: 12,
                  //                       fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                   Container(
                  //                     margin: EdgeInsets.only(
                  //                       left: kDefaultPadding * 4,
                  //                     ),
                  //                     width: 2,
                  //                     height: 30,
                  //                     decoration: BoxDecoration(
                  //                       color: Color(
                  //                         0xFFA39B9B,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   kHalfWidthSizedBox,
                  //                   IconButton(
                  //                     onPressed: () =>
                  //                         _copyToClipboard(context),
                  //                     icon: Icon(
                  //                       Icons.content_copy_rounded,
                  //                       color: kAccentColor,
                  //                       size: 14,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             kSizedBox,
                  //             Container(
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Container(
                  //                         child: Column(
                  //                           children: [
                  //                             Container(
                  //                               height: 80,
                  //                               width: 80,
                  //                               decoration: BoxDecoration(
                  //                                 image: DecorationImage(
                  //                                   image: AssetImage(
                  //                                     "assets/icons/whatsapp-icon.png",
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               'WhatsApp',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: Color(
                  //                                   0xFF3C3E56,
                  //                                 ),
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.w400,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Container(
                  //                         child: Column(
                  //                           children: [
                  //                             Container(
                  //                               height: 80,
                  //                               width: 80,
                  //                               decoration: BoxDecoration(
                  //                                 image: DecorationImage(
                  //                                   image: AssetImage(
                  //                                     "assets/icons/facebook-icon.png",
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               'Facebook',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: Color(
                  //                                   0xFF3C3E56,
                  //                                 ),
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.w400,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Container(
                  //                         child: Column(
                  //                           children: [
                  //                             Container(
                  //                               height: 80,
                  //                               width: 80,
                  //                               decoration: BoxDecoration(
                  //                                 image: DecorationImage(
                  //                                   image: AssetImage(
                  //                                     "assets/icons/messenger-icon.png",
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               'Messenger',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: Color(
                  //                                   0xFF3C3E56,
                  //                                 ),
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.w400,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Container(
                  //                         child: Column(
                  //                           children: [
                  //                             Container(
                  //                               height: 80,
                  //                               width: 80,
                  //                               decoration: BoxDecoration(
                  //                                 image: DecorationImage(
                  //                                   image: AssetImage(
                  //                                     "assets/icons/messages-icon.png",
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Text(
                  //                               'Message',
                  //                               textAlign: TextAlign.center,
                  //                               style: TextStyle(
                  //                                 color: Color(
                  //                                   0xFF3C3E56,
                  //                                 ),
                  //                                 fontSize: 16,
                  //                                 fontWeight: FontWeight.w400,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   kHalfSizedBox,
                  //                   Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       InkWell(
                  //                         onTap: () {},
                  //                         child: Container(
                  //                           child: Column(
                  //                             children: [
                  //                               Container(
                  //                                 height: 80,
                  //                                 width: 80,
                  //                                 decoration: BoxDecoration(
                  //                                   image: DecorationImage(
                  //                                     image: AssetImage(
                  //                                       "assets/icons/instagram-icon.png",
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 'Instagram',
                  //                                 textAlign: TextAlign.center,
                  //                                 style: TextStyle(
                  //                                   color: Color(
                  //                                     0xFF3C3E56,
                  //                                   ),
                  //                                   fontSize: 16,
                  //                                   fontWeight: FontWeight.w400,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       InkWell(
                  //                         onTap: () {},
                  //                         child: Container(
                  //                           child: Column(
                  //                             children: [
                  //                               Container(
                  //                                 height: 80,
                  //                                 width: 80,
                  //                                 decoration: BoxDecoration(
                  //                                   image: DecorationImage(
                  //                                     image: AssetImage(
                  //                                       "assets/icons/twitter-icon.png",
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 'Twitter',
                  //                                 textAlign: TextAlign.center,
                  //                                 style: TextStyle(
                  //                                   color: Color(
                  //                                     0xFF3C3E56,
                  //                                   ),
                  //                                   fontSize: 16,
                  //                                   fontWeight: FontWeight.w400,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       InkWell(
                  //                         onTap: () {},
                  //                         child: Container(
                  //                           child: Column(
                  //                             children: [
                  //                               Container(
                  //                                 height: 80,
                  //                                 width: 80,
                  //                                 decoration: BoxDecoration(
                  //                                   image: DecorationImage(
                  //                                     image: AssetImage(
                  //                                       "assets/icons/telegram-icon.png",
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 'Telegram',
                  //                                 textAlign: TextAlign.center,
                  //                                 style: TextStyle(
                  //                                   color: Color(
                  //                                     0xFF3C3E56,
                  //                                   ),
                  //                                   fontSize: 16,
                  //                                   fontWeight: FontWeight.w400,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       InkWell(
                  //                         onTap: () {},
                  //                         child: Container(
                  //                           child: Column(
                  //                             children: [
                  //                               Container(
                  //                                 height: 80,
                  //                                 width: 80,
                  //                                 decoration: BoxDecoration(
                  //                                   image: DecorationImage(
                  //                                     image: AssetImage(
                  //                                       "assets/icons/linkedin-icon.png",
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 'LinkedIn',
                  //                                 textAlign: TextAlign.center,
                  //                                 style: TextStyle(
                  //                                   color: Color(
                  //                                     0xFF3C3E56,
                  //                                   ),
                  //                                   fontSize: 16,
                  //                                   fontWeight: FontWeight.w400,
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: kDefaultPadding * 4,
                  //             ),
                  //             MyElevatedButton(
                  //               title: "Close",
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),