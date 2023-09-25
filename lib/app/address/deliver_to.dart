import 'package:benji_user/app/checkout/checkout_screen.dart';
import 'package:benji_user/src/repo/models/address_model.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/common_widgets/button/my_outlined_elevatedbutton.dart';
import '../../src/common_widgets/empty.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../theme/colors.dart';
import 'add_new_address.dart';

class DeliverTo extends StatefulWidget {
  final bool inCheckout;
  const DeliverTo({super.key, this.inCheckout = false});

  @override
  State<DeliverTo> createState() => _DeliverToState();
}

class _DeliverToState extends State<DeliverTo> {
  //=================================== ALL VARIABLES =====================================\\

  //=========================== BOOL VALUES ====================================\\
  bool _isLoading = false;

  String _currentOption = '';

  //===================== STATES =======================\\

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Map? _addressData;

  _getData() async {
    await checkAuth(context);

    String current = '';
    try {
      current = (await getCurrentAddress()).id ?? '';
    } catch (e) {
      current = '';
    }
    _currentOption = current;
    List<Address> addresses = await getAddressesByUser();

    if (current != '') {
      Address? itemToMove = addresses.firstWhere(
        (elem) => elem.id == current,
      );

      addresses.remove(itemToMove);
      addresses.insert(0, itemToMove);
    }
    Map data = {
      'current': current,
      'addresses': addresses,
    };

    setState(() {
      _addressData = data;
    });
  }

  //=================================================================================================\\

  //===================================================================== FUNCTIONS =======================================================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _addressData = null;
    });

    await _getData();
  }

  void _addAddress() async {
    await Get.to(
      () => const AddNewAddress(),
      routeName: 'AddNewAddress',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    await _getData();
  }
  //===================== FUNCTIONS =======================\\

  Future<void> applyDeliveryAddress(String addressId) async {
    setState(() {
      _isLoading = true;
    });

    if (_currentOption == '') {
      await Get.to(
        () => const AddNewAddress(),
        routeName: 'AddNewAddress',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
      await _getData();
    }
    try {
      await setCurrentAddress(addressId);
      if (widget.inCheckout) {
        Get.back();
      } else {
        Get.off(
          () => const CheckoutScreen(),
          routeName: 'CheckoutScreen',
          duration: const Duration(milliseconds: 300),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          popGesture: true,
          transition: Transition.rightToLeft,
        );
      }
    } catch (e) {
      mySnackBar(
        context,
        kAccentColor,
        "No address selected!",
        "Select address to add as default or add address",
        const Duration(
          seconds: 2,
        ),
      );
    }

    // if (widget.toCheckout) {
    //   if (widget.inCheckout && address != null) {
    //     Get.close(1);
    //   } else {
    //     Get.off(
    //       () => CheckoutScreen(deliverTo: address!),
    //       routeName: 'CheckoutScreen',
    //       duration: const Duration(milliseconds: 300),
    //       fullscreenDialog: true,
    //       curve: Curves.easeIn,
    //       popGesture: true,
    //       transition: Transition.rightToLeft,
    //     );
    //   }
    // } else {
    //   Get.back();
    // }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Add a delivery location",
          toolbarHeight: kToolbarHeight,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        body: _addressData == null
            ? Center(child: SpinKitChasingDots(color: kAccentColor))
            : ListView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                children: [
                  Column(
                    children: [
                      _addressData!['addresses']!.isEmpty
                          ? const EmptyCard(removeButton: true)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _addressData!['addresses'].length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding:
                                      const EdgeInsetsDirectional.symmetric(
                                    vertical: kDefaultPadding / 2,
                                  ),
                                  child: RadioListTile(
                                    value: _addressData!['addresses'][index].id,
                                    groupValue: _currentOption,
                                    activeColor: kAccentColor,
                                    enableFeedback: true,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    fillColor: MaterialStatePropertyAll(
                                      kAccentColor,
                                    ),
                                    onChanged: ((value) {
                                      setState(
                                        () {
                                          _currentOption =
                                              _addressData!['addresses'][index]
                                                  .id;
                                        },
                                      );
                                    }),
                                    title: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            _addressData!['addresses'][index]
                                                .title
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: kTextBlackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          kWidthSizedBox,
                                          Container(
                                            width: 58,
                                            height: 24,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: ShapeDecoration(
                                              color: _currentOption ==
                                                      _addressData!['addresses']
                                                              [index]
                                                          .id
                                                  ? const Color(0xFFFFCFCF)
                                                  : kTransparentColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _currentOption ==
                                                          _addressData![
                                                                      'addresses']
                                                                  [index]
                                                              .id
                                                      ? 'Default'
                                                      : '',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: kAccentColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                        top: kDefaultPadding / 2,
                                      ),
                                      child: Container(
                                        child: Text(
                                          _addressData!['addresses'][index]
                                              .streetAddress,
                                          style: TextStyle(
                                            color: kTextGreyColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                      const SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                    ],
                  ),
                  MyOutlinedElevatedButton(
                    title: "Add New Address",
                    onPressed: _addAddress,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  _addressData!['addresses']!.isEmpty
                      ? const SizedBox()
                      : _isLoading
                          ? Center(
                              child: SpinKitChasingDots(
                                color: kAccentColor,
                                duration: const Duration(seconds: 1),
                              ),
                            )
                          : MyElevatedButton(
                              title: "Apply",
                              onPressed: () {
                                applyDeliveryAddress(_currentOption);
                              },
                            ),
                  const SizedBox(height: kDefaultPadding * 2),
                ],
              ),
      ),
    );
  }
}
