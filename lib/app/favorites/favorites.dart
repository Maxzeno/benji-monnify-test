// ignore_for_file: unused_local_variable
import 'package:benji_user/app/vendor/vendor_details.dart';
import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:benji_user/src/common_widgets/cart_card.dart';
import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/common_widgets/product/product_card.dart';
import 'package:benji_user/src/common_widgets/snackbar/my_floating_snackbar.dart';
import 'package:benji_user/src/repo/models/vendor/vendor.dart';
import 'package:benji_user/src/repo/utils/favorite.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/vendor/vendors_card.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/product/product.dart';
import '../../theme/colors.dart';
import '../product/product_detail_screen.dart';
import 'favorite_products.dart';
import 'favorite_vendors.dart';

class Favorites extends StatefulWidget {
  final String vendorCoverImage;
  final String vendorName;
  final double vendorRating;
  final String vendorActiveStatus;
  final Color vendorActiveStatusColor;
  const Favorites({
    super.key,
    required this.vendorCoverImage,
    required this.vendorName,
    required this.vendorRating,
    required this.vendorActiveStatus,
    required this.vendorActiveStatusColor,
  });

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with SingleTickerProviderStateMixin {
  //=================================== ALL VARIABLES ====================================\\
  //======================================================================================\\
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    _tabBarController = TabController(length: 2, vsync: this);
  }

  Future<List<Product>> _getDataProduct() async {
    List<Product> product = await getFavoriteProduct(
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

    return product;
  }

  Future<List<VendorModel>> _getDataVendor() async {
    List<VendorModel> vendor = await getFavoriteVendor(
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

    return vendor;
  }

  Future<void> _handleRefresh() async {
    // setState(() {});
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

//==========================================================================================\\

  //=================================== CONTROLLERS ====================================\\
  late TabController _tabBarController;
  final ScrollController _scrollController = ScrollController();

//===================== Tabs ==========================\\
  int _selectedtabbar = 0;
  void _clickOnTabBarOption(value) async {
    setState(() {
      _selectedtabbar = value;
    });
  }
  //===================== Navigation ==========================\\

  void _toProductDetailsScreen(product) async {
    await Get.to(
      () => ProductDetailScreen(product: product),
      routeName: 'ProductDetailScreen',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

  void _vendorDetailPage(vendor) async {
    await Get.to(
      () => VendorDetails(vendor: vendor),
      routeName: 'VendorDetails',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }
//====================================================================================\\

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

//====================================================================================\\

    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "Favorites",
          elevation: 0.0,
          actions: const [
            CartCard(),
          ],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              kSizedBox,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                ),
                child: Container(
                  width: mediaWidth,
                  decoration: BoxDecoration(
                    color: kDefaultCategoryBackgroundColor,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: kGreyColor1,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TabBar(
                          controller: _tabBarController,
                          onTap: (value) => _clickOnTabBarOption(value),
                          enableFeedback: true,
                          mouseCursor: SystemMouseCursors.click,
                          automaticIndicatorColorAdjustment: true,
                          overlayColor: MaterialStatePropertyAll(kAccentColor),
                          labelColor: kPrimaryColor,
                          unselectedLabelColor: kTextGreyColor,
                          indicatorColor: kAccentColor,
                          indicatorWeight: 2,
                          splashBorderRadius: BorderRadius.circular(50),
                          indicator: BoxDecoration(
                            color: kAccentColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          tabs: const [
                            Tab(text: "Products"),
                            Tab(text: "Vendors"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kSizedBox,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                ),
                width: mediaWidth,
                child: _selectedtabbar == 0
                    ? FutureBuilder(
                        future: _getDataProduct(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Scrollbar(
                              controller: _scrollController,
                              radius: const Radius.circular(10),
                              child: FavoriteProductsTab(
                                list: snapshot.data!.isEmpty
                                    ? const EmptyCard()
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              deviceType(mediaWidth) > 2
                                                  ? 2
                                                  : 1,
                                          crossAxisSpacing:
                                              deviceType(mediaWidth) > 2
                                                  ? 20
                                                  : 1,
                                          mainAxisSpacing:
                                              deviceType(mediaWidth) > 2
                                                  ? 25
                                                  : 15,
                                          childAspectRatio:
                                              deviceType(mediaWidth) > 3 &&
                                                      deviceType(mediaWidth) < 5
                                                  ? 1.9
                                                  : deviceType(mediaWidth) > 2
                                                      ? 1.4
                                                      : 1.2,
                                        ),
                                        controller: _scrollController,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ProductCard(
                                          onTap: () => _toProductDetailsScreen(
                                              snapshot.data![index]),
                                          product: snapshot.data![index],
                                        ),
                                      ),
                              ),
                            );
                          }
                          return Center(
                            child: SpinKitChasingDots(
                              color: kAccentColor,
                            ),
                          );
                        },
                      )
                    : FutureBuilder(
                        future: _getDataVendor(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return FavoriteVendorsTab(
                              list: Scrollbar(
                                controller: _scrollController,
                                radius: const Radius.circular(10),
                                child: snapshot.data!.isEmpty
                                    ? const EmptyCard()
                                    : GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              deviceType(mediaWidth) > 2
                                                  ? 3
                                                  : 2,
                                          crossAxisSpacing:
                                              deviceType(mediaWidth) > 2
                                                  ? 20
                                                  : 10,
                                          mainAxisSpacing:
                                              deviceType(mediaWidth) > 2
                                                  ? 25
                                                  : 15,
                                          childAspectRatio:
                                              deviceType(mediaWidth) > 3 &&
                                                      deviceType(mediaWidth) < 5
                                                  ? 1.8
                                                  : deviceType(mediaWidth) > 2
                                                      ? 1.28
                                                      : 0.86,
                                        ),
                                        controller: _scrollController,
                                        itemCount: snapshot.data!.length,
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            VendorsCard(
                                          onTap: () => _vendorDetailPage(
                                              snapshot.data![index]),
                                          cardImage:
                                              'assets/images/vendors/ntachi-osa.png',
                                          vendorName:
                                              snapshot.data![index].shopName!,
                                          typeOfBusiness: snapshot
                                              .data![index].shopType!.name!,
                                          rating:
                                              "${snapshot.data![index].averageRating!.toStringAsPrecision(2)} (${(snapshot.data![index].numberOfClientsReactions ?? 0).toString()}",
                                          removeDistance: true,
                                        ),
                                      ),
                              ),
                            );
                          }
                          return Center(
                            child: SpinKitChasingDots(
                              color: kAccentColor,
                            ),
                          );
                        }),
              ),
              kHalfSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
