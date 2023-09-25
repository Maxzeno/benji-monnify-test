// ignore_for_file: unused_local_variable

import 'package:benji_user/app/vendor/product_vendor.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:flutter/material.dart';

class VendorsProductsTab extends StatefulWidget {
  final VendorModel vendor;
  const VendorsProductsTab({
    super.key,
    required this.vendor,
  });

  @override
  State<VendorsProductsTab> createState() => _VendorsProductsTabState();
}

class _VendorsProductsTabState extends State<VendorsProductsTab> {
  //===================== VARIABLES =======================\\

//============================================ FUNCTIONS ==============================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: mediaWidth,
      child: ProductVendor(
        vendor: widget.vendor,
      ),
    );
  }
}
