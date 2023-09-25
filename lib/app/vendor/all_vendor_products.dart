import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:benji_user/src/common_widgets/button/category%20button.dart';
import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/product/product_card.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/product/product.dart';
import '../../theme/colors.dart';
import '../product/product_detail_screen.dart';

class AllVendorProducts extends StatefulWidget {
  final VendorModel vendor;

  const AllVendorProducts({
    super.key,
    required this.vendor,
  });

  @override
  State<AllVendorProducts> createState() => _AllVendorProductsState();
}

class _AllVendorProductsState extends State<AllVendorProducts> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }
//==========================================================================================\\

  //=================================== LOGIC ====================================\\
  Map<String, List<Product>>? _productAndSubCategoryName;
  String activeCategory = '';

  _getData() async {
    await checkAuth(context);

    Map<String, List<Product>> productAndSubCategoryName =
        await getVendorProductsAndSubCategoryName(widget.vendor.id);
    try {
      activeCategory = productAndSubCategoryName.keys.toList()[0];
    } catch (e) {}

    setState(() {
      _productAndSubCategoryName = productAndSubCategoryName;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _productAndSubCategoryName = null;
    });
    await _getData();
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//===================== KEYS =======================\\
  // final _formKey = GlobalKey<FormState>();

//===================== FOCUS NODES =======================\\
  FocusNode rateVendorFN = FocusNode();

//=================================================== FUNCTIONS =====================================================\\
  void validate() {
    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "Thank you for your feedback!",
      const Duration(seconds: 1),
    );

    Get.back();
  }

  //========================================================================\\

  //============================================= Navigation =======================================\\
  void _toProductDetailScreen(product) => Get.to(
        () => ProductDetailScreen(product: product),
        routeName: 'ProductDetailScreen',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "All Products",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            child: _productAndSubCategoryName == null
                ? SpinKitChasingDots(color: kAccentColor)
                : ListView(
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    dragStartBehavior: DragStartBehavior.down,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          itemCount:
                              _productAndSubCategoryName!.keys.toList().length,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.all(kDefaultPadding / 2),
                            child: CategoryButton(
                              onPressed: () {
                                setState(() {
                                  activeCategory = _productAndSubCategoryName!
                                      .keys
                                      .toList()[index];
                                });
                              },
                              title: _productAndSubCategoryName!.keys
                                  .toList()[index],
                              bgColor: activeCategory ==
                                      _productAndSubCategoryName!.keys
                                          .toList()[index]
                                  ? kAccentColor
                                  : kDefaultCategoryBackgroundColor,
                              categoryFontColor: activeCategory ==
                                      _productAndSubCategoryName!.keys
                                          .toList()[index]
                                  ? kPrimaryColor
                                  : kTextGreyColor,
                            ),
                          ),
                        ),
                      ),
                      kHalfSizedBox,
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: deviceType(media.width) > 2 ? 2 : 1,
                          crossAxisSpacing:
                              deviceType(media.width) > 2 ? 20 : 1,
                          mainAxisSpacing:
                              deviceType(media.width) > 2 ? 25 : 15,
                          childAspectRatio:
                              deviceType(media.width) > 2 ? 1.4 : 1.2,
                        ),
                        itemCount:
                            _productAndSubCategoryName![activeCategory]!.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => ProductCard(
                          product: _productAndSubCategoryName![activeCategory]![
                              index],
                          onTap: () => _toProductDetailScreen(
                              _productAndSubCategoryName![activeCategory]![
                                  index]),
                        ),
                      ),
                      kSizedBox
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
