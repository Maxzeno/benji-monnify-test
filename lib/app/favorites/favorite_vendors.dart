// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class FavoriteVendorsTab extends StatefulWidget {
  final Widget list;
  const FavoriteVendorsTab({
    super.key,
    required this.list,
  });

  @override
  State<FavoriteVendorsTab> createState() => _FavoriteVendorsTabState();
}

class _FavoriteVendorsTabState extends State<FavoriteVendorsTab> {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return SizedBox(width: mediaWidth, child: widget.list);
  }
}
