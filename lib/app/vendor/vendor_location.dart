// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field

import 'dart:async';
import 'dart:ui' as ui; // Import the ui library with an alias

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../theme/colors.dart';
import 'all_vendor_products.dart';

class VendorLocation extends StatefulWidget {
  final VendorModel vendor;
  const VendorLocation({
    Key? key,
    required this.vendor,
  }) : super(key: key);

  @override
  State<VendorLocation> createState() => _VendorLocationState();
}

class _VendorLocationState extends State<VendorLocation> {
  //============================================================== INITIAL STATE ====================================================================\\
  @override
  void initState() {
    super.initState();
    // _getPolyPoints();
    _markerTitle = <String>["Me", widget.vendor.shopName ?? 'Not Available'];
    _markerSnippet = <String>[
      "My Location",
      "${(widget.vendor.averageRating ?? 0).toPrecision(1)} Rating"
    ];
    _loadMapData();
  }

  //============================================================= ALL VARIABLES ======================================================================\\

  //====================================== Setting Google Map Consts =========================================\\

  Position? _userPosition;

  static const LatLng _vendorLocation =
      LatLng(6.463810164127019, 7.539888438605598);
  final List<LatLng> _polylineCoordinates = [];
  // List<LatLng> _latLng = <LatLng>[_userLocation, _vendorLocation];
  Uint8List? _markerImage;
  final List<Marker> _markers = <Marker>[];
  final List<MarkerId> _markerId = <MarkerId>[const MarkerId("0"), const MarkerId("1")];
  List<String>? _markerTitle;
  List<String>? _markerSnippet;
  final List<String> _customMarkers = <String>[
    "assets/icons/person_location.png",
    "assets/icons/store.png",
  ];
  //============================================================= BOOL VALUES ======================================================================\\
  bool _isExpanded = false;

  //========================================================== GlobalKeys ============================================================\\

  //=================================== CONTROLLERS ======================================================\\
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;

  //============================================================== FUNCTIONS ===================================================================\\

  //======================================= Google Maps ================================================\\

  /// When the location services are not enabled or permissions are denied the `Future` will return an error.
  Future<void> _loadMapData() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    await _getUserCurrentLocation();
    await _loadCustomMarkers();
    // await _getPolyPoints();
  }

//============================================== Get Current Location ==================================================\\

  Future<Position> _getUserCurrentLocation() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );

    LatLng latLngPosition =
        LatLng(userLocation.latitude, userLocation.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 12.68);

    _newGoogleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    return userLocation;
  }

  //====================================== Get bytes from assets =========================================\\

  Future<Uint8List> _getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //====================================== Get Location Markers =========================================\\

  _loadCustomMarkers() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );
    List<LatLng> latLng = <LatLng>[
      LatLng(userLocation.latitude, userLocation.longitude),
      _vendorLocation
    ];
    for (int i = 0; i < _customMarkers.length; i++) {
      final Uint8List markerIcon =
          await _getBytesFromAssets(_customMarkers[i], 100);

      _markers.add(
        Marker(
          markerId: _markerId[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: latLng[i],
          infoWindow: InfoWindow(
            title: _markerTitle![i],
            snippet: _markerSnippet![i],
          ),
        ),
      );
      setState(() {});
    }
  }

  //============================================== Adding polypoints ==================================================\\
  // _getPolyPoints() async {
  //   Position _userLocation = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   ).then(
  //     (location) => _userPosition = location,
  //   );
  //   PolylinePoints _polyLinePoints = PolylinePoints();
  //   PolylineResult _result = await _polyLinePoints.getRouteBetweenCoordinates(
  //     googleMapsApiKey,
  //     PointLatLng(_userLocation.latitude, _userLocation.longitude),
  //     PointLatLng(_vendorLocation.latitude, _vendorLocation.longitude),
  //   );

  //   if (_result.points.isNotEmpty) {
  //     _result.points.forEach(
  //       (PointLatLng point) =>
  //           _polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
  //     );
  //     setState(() {});
  //   }
  // }

//============================================== Create Google Maps ==================================================\\

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
    _newGoogleMapController = controller;
  }

//========================================================== Navigation =============================================================\\
  void _viewProducts() => Get.off(
        () => AllVendorProducts(vendor: widget.vendor),
        routeName: 'AllVendorProducts',
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
    double mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Vendor's location",
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        actions: const [],
        toolbarHeight: kToolbarHeight,
      ),
      body: Stack(
        children: [
          _userPosition == null
              ? Center(child: SpinKitChasingDots(color: kAccentColor))
              : GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        _userPosition!.latitude, _userPosition!.longitude),
                    zoom: 12.68,
                  ),
                  markers: Set.of(_markers),
                  padding: EdgeInsets.only(
                    bottom: _isExpanded ? mediaHeight * 0.32 : 90,
                  ),
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                  tiltGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  fortyFiveDegreeImageryEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            left: 0,
            right: 0,
            bottom: _isExpanded ? 0 : -140,
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
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: Color(0xFFFDEDED),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? "See less" : "See more",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: mediaWidth - 200,
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
                    width: mediaWidth - 90,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: kAccentColor,
                          size: 15,
                        ),
                        kHalfWidthSizedBox,
                        Text(
                          widget.vendor.address ?? 'Not Available',
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
                    onTap: _viewProducts,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: mediaWidth / 4,
                      padding: const EdgeInsets.all(kDefaultPadding / 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: kAccentColor,
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        "Show products",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: mediaWidth * 0.23,
                        height: 57,
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        width: mediaWidth * 0.25,
                        height: 57,
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.vendor.isOnline ?? false
                                  ? "Online"
                                  : 'Offline',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.vendor.isOnline ?? false
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            bottom: _isExpanded ? 180 : 40,
            left: mediaWidth / 2.7,
            child: Container(
              width: 100,
              height: 100,
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
    );
  }
}
