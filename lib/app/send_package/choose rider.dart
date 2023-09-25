// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../theme/colors.dart';

class ChooseRider extends StatefulWidget {
  const ChooseRider({super.key});

  @override
  State<ChooseRider> createState() => _ChooseRiderState();
}

class _ChooseRiderState extends State<ChooseRider> {
//================================== ALL VARIABLES ===============================\\
  final LatLng _latLng = const LatLng(
    6.456076934514027,
    7.507987759047121,
  );

//================================== CONTROLLERS ===============================\\
  GoogleMapController? _googleMapController;

//================================== FUNCTIONS ===============================\\
  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Choose a rider",
        elevation: 0.0,
        actions: const [],
        backgroundColor: kPrimaryColor,
        toolbarHeight: kToolbarHeight,
      ),
      body: SafeArea(
        child: Stack(
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
          ],
        ),
      ),
    );
  }
}
