// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class FavoriteProductsTab extends StatefulWidget {
  final Widget list;
  const FavoriteProductsTab({
    super.key,
    required this.list,
  });

  @override
  State<FavoriteProductsTab> createState() => _FavoriteProductsTabState();
}

class _FavoriteProductsTabState extends State<FavoriteProductsTab> {
  //===================== VARIABLES =======================\\

//============================================ FUNCTIONS ==============================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: mediaWidth,
      child: widget.list,
    );
  }
}
