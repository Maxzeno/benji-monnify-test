// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/button/my_elevatedbutton.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../call/call_screen.dart';

class DeliveryMap extends StatefulWidget {
  const DeliveryMap({super.key});

  @override
  State<DeliveryMap> createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  //====================== ALL VARIABLES =====================================\\

  //===================== GlobalKeys =======================\\

  //===================== CONTROLLERS =======================\\
  GoogleMapController? _googleMapController;
  // final _googleMapController = Completer<GoogleMapController>();

  //===================== GOOGLE MAP =======================\\

  // Future<bool> getLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.denied) {
  //     return false;
  //   }

  //   return false;
  // }

  final LatLng _latLng = const LatLng(
    6.456076934514027,
    7.507987759047121,
  );

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  //=============================== NAVIGATION ======================================\\
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

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: MyAppBar(
        title: "Track Order",
        toolbarHeight: 80,
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        actions: const [],
      ),
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            buildingsEnabled: true,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            cameraTargetBounds: CameraTargetBounds.unbounded,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            trafficEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: 20.0,
              tilt: 16,
            ),
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: MyElevatedButton(
              title: "Order Details",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: kPrimaryColor,
                  barrierColor: kBlackColor.withOpacity(0.5),
                  showDragHandle: true,
                  useSafeArea: true,
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        kDefaultPadding,
                      ),
                    ),
                  ),
                  enableDrag: true,
                  builder: (context) => SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding,
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
                              width: 100,
                              height: 100,
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
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
