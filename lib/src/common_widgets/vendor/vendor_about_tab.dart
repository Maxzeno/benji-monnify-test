// ignore_for_file: unused_local_variable

import 'package:benji_user/app/vendor/about_vendor.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:flutter/material.dart';

class VendorsAboutTab extends StatefulWidget {
  final VendorModel vendor;

  const VendorsAboutTab({
    super.key,
    required this.vendor,
  });

  @override
  State<VendorsAboutTab> createState() => _VendorsAboutTabState();
}

class _VendorsAboutTabState extends State<VendorsAboutTab> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: AboutVendor(
              vendor: widget.vendor,
            ),
          ),
        ],
      ),
    );
  }
}
