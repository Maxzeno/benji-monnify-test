// ignore_for_file: unused_field

import 'package:benji_user/app/favorites/favorites.dart';
import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/common_widgets/vendor/vendors_card.dart';
import 'package:benji_user/src/others/my_future_builder.dart';
import 'package:benji_user/src/repo/models/address_model.dart';
import 'package:benji_user/src/repo/models/category/sub_category.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/appBar_delivery_location.dart';
import '../../src/common_widgets/button/category button.dart';
import '../../src/common_widgets/cart_card.dart';
import '../../src/common_widgets/product/product_card.dart';
import '../../src/common_widgets/section/custom_showSearch.dart';
import '../../src/common_widgets/section/see_all_container.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/product/product.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../src/repo/utils/cart.dart';
import '../../theme/colors.dart';
import '../address/addresses.dart';
import '../address/deliver_to.dart';
import '../auth/login.dart';
import '../my_packages/my_packages.dart';
import '../orders/order_history.dart';
import '../product/home_page_products.dart';
import '../product/product_detail_screen.dart';
import '../profile_settings/profile_settings.dart';
import '../send_package/send_package.dart';
import '../vendor/popular_vendors.dart';
import '../vendor/vendor_details.dart';
import '../vendor/vendors_near_you.dart';
import 'home_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
    countCartFunc();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(() {});
    super.dispose();
  }

  countCartFunc() async {
    String data = await countCart();
    setState(() {
      cartCount = data;
    });
  }

  Map? _data;
  List<Product>? product;
  _getData() async {
    await checkAuth(context);
    String current = 'Select Address';
    try {
      current = (await getCurrentAddress()).streetAddress ?? current;
    } catch (e) {
      current = current;
    }

    product = [];
    List<SubCategory> category = await getSubCategories();
    try {
      product = await getProductsBySubCategory(category[activeCategory].id);
    } catch (e) {
      product = [];
    }
    List<VendorModel> vendor = await getVendors();
    List<VendorModel> popularVendor = await getPopularVendors();

    setState(() {
      _data = {
        'category': category,
        'product': product,
        'vendor': vendor,
        'popularVendor': popularVendor,
        'currentAddress': current,
      };
    });
  }

  //=======================================================================================================================================\\

//============================================== ALL VARIABLES =================================================\\
  int activeCategory = 0;
  String cartCount = '';
//============================================== BOOL VALUES =================================================\\
  final bool _vendorStatus = true;
  bool _isScrollToTopBtnVisible = false;

  //Online Vendors
  final String _onlineVendorsName = "Ntachi Osa";
  final String _onlineVendorsImage = "ntachi-osa";
  final double _onlineVendorsRating = 4.6;

  final String _vendorActive = "Online";
  final String _vendorInactive = "Offline";
  final Color _vendorActiveColor = kSuccessColor;
  final Color _vendorInactiveColor = kAccentColor;

  //Offline Vendors
  final String _offlineVendorsName = "Best Choice Restaurant";
  final String _offlineVendorsImage = "best-choice-restaurant";
  final double _offlineVendorsRating = 4.0;

  //==================================================== CONTROLLERS ======================================================\\
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();

//===================== POPULAR VENDORS =======================\\
  final List<String> popularVendorImage = [
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
    "assets/images/vendors/ntachi-osa.png",
  ];

  //===================== COPY TO CLIPBOARD =======================\\
  void _copyToClipboard(BuildContext context, String userID) {
    Clipboard.setData(
      ClipboardData(text: userID),
    );

    //===================== SNACK BAR =======================\\

    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "ID copied to clipboard",
      const Duration(
        seconds: 2,
      ),
    );
  }

  //==================================================== FUNCTIONS ===========================================================\\

  //===================== Scroll to Top ==========================\\
  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels >= 200 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (_scrollController.position.pixels < 200 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
  }

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
    });
    await _getData();
  }
  //========================================================================\\

  //==================================================== Navigation ===========================================================\\
  void _logOut() => Get.offAll(
        () => const Login(logout: true),
        predicate: (route) => false,
        routeName: 'Login',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.downToUp,
      );

  void _toProfileSettings() async {
    await Get.to(
      () => const ProfileSettings(),
      routeName: 'ProfileSettings',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

  void _toAddressScreen() => Get.to(
        () => const Addresses(),
        routeName: 'Addresses',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toSendPackageScreen() => Get.to(
        () => const SendPackage(),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toFavoritesScreen() => Get.to(
        () => Favorites(
          vendorCoverImage:
              _vendorStatus ? _onlineVendorsImage : _offlineVendorsImage,
          vendorName: _vendorStatus ? _onlineVendorsName : _offlineVendorsName,
          vendorRating:
              _vendorStatus ? _onlineVendorsRating : _offlineVendorsRating,
          vendorActiveStatus: _vendorStatus ? _vendorActive : _vendorInactive,
          vendorActiveStatusColor:
              _vendorStatus ? _vendorActiveColor : _vendorInactiveColor,
        ),
        routeName: 'SendPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toOrdersScreen() => Get.to(
        () => const OrdersHistory(),
        routeName: 'OrdersHistory',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toCheckoutScreen() => Get.to(
        () => const DeliverTo(),
        routeName: 'DeliverTo',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toSeeAllVendorsNearYou() => Get.to(
        () => const VendorsNearYou(),
        routeName: 'VendorsNearYou',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toVendorPage(VendorModel vendor) => Get.to(
        () => VendorDetails(vendor: vendor),
        routeName: 'VendorDetails',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toSeeAllPopularVendors() => Get.to(
        () => const PopularVendors(),
        routeName: 'PopularVendors',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toAddressesPage() => Get.to(
        () => const Addresses(),
        routeName: 'Addresses',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toProductDetailScreenPage(product) async {
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

  void _toSeeProducts() => Get.to(
        () => const HomePageProducts(),
        routeName: 'HomePageProducts',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _toMyPackagesPage() => Get.to(
        () => const MyPackages(),
        routeName: 'MyPackages',
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
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        onDrawerChanged: (isOpened) {
          setState(() {});
        },
        drawerDragStartBehavior: DragStartBehavior.start,
        drawerEnableOpenDragGesture: true,
        endDrawerEnableOpenDragGesture: true,
        resizeToAvoidBottomInset: true,
        drawer: MyFutureBuilder(
          future: getUser(),
          child: (data) => HomeDrawer(
            userID: data.code,
            toProfileSettings: _toProfileSettings,
            copyUserIdToClipBoard: () {
              _copyToClipboard(context, data.code);
            },
            toAddressesPage: _toAddressScreen,
            toMyPackagesPage: _toMyPackagesPage,
            toSendPackagePage: _toSendPackageScreen,
            toFavoritesPage: _toFavoritesScreen,
            toCheckoutScreen: _toCheckoutScreen,
            toOrdersPage: _toOrdersScreen,
            logOut: _logOut,
          ),
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: deviceType(mediaWidth) > 2 ? false : true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : const SizedBox(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0.0,
          title: Row(
            children: [
              Builder(
                builder: (context) => IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Image.asset(
                    "assets/icons/drawer-icon.png",
                    color: kAccentColor,
                    fit: BoxFit.cover,
                    height: deviceType(mediaWidth) > 2 ? 36 : 20,
                  ),
                ),
              ),
              AppBarDeliveryLocation(
                deliveryLocation:
                    _data != null ? _data!['currentAddress'] : 'Select Address',
                toDeliverToPage: _data != null ? _toAddressesPage : () {},
              ),
            ],
          ),
          actions: [
            _data != null
                ? IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: kAccentColor,
                      size: deviceType(mediaWidth) > 2 ? 30 : 24,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitDoubleBounce(color: kAccentColor, size: 12),
                  ),
            _data != null
                ? const CartCard()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SpinKitDoubleBounce(color: kAccentColor, size: 12),
                  ),
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _data == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitChasingDots(color: kAccentColor),
                      kSizedBox,
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: kTextGreyColor,
                          fontSize: deviceType(mediaWidth) > 2 ? 30 : 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: kAccentColor,
                  semanticsLabel: "Pull to refresh",
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: deviceType(mediaWidth) > 2
                          ? const EdgeInsets.all(kDefaultPadding)
                          : const EdgeInsets.all(kDefaultPadding / 2),
                      children: [
                        SeeAllContainer(
                          title: "Vendors Near you",
                          onPressed: _toSeeAllVendorsNearYou,
                        ),
                        kSizedBox,
                        SizedBox(
                          height: 250,
                          width: mediaWidth,
                          child: ListView.separated(
                            itemCount: _data!['vendor'].length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                deviceType(mediaWidth) > 2
                                    ? kWidthSizedBox
                                    : kHalfWidthSizedBox,
                            itemBuilder: (context, index) => InkWell(
                              child: VendorsCard(
                                removeDistance: false,
                                onTap: () {
                                  _toVendorPage(_data!['vendor'][index]);
                                },
                                cardImage:
                                    "assets/images/vendors/ntachi-osa.png",
                                vendorName: _data!['vendor'][index].shopName ??
                                    "Not Available",
                                typeOfBusiness:
                                    _data!['vendor'][index].shopType.name ??
                                        'Not Available',
                                rating:
                                    '${((_data!['vendor'][index].averageRating as double?) ?? 0.0).toStringAsPrecision(2)} (${_data!['vendor'][index].numberOfClientsReactions ?? 0})',
                                distance: "30 mins",
                              ),
                            ),
                          ),
                        ),
                        kSizedBox,
                        SeeAllContainer(
                          title: "Popular Vendors",
                          onPressed: _toSeeAllPopularVendors,
                        ),
                        kSizedBox,
                        Center(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  deviceType(mediaWidth) > 2 ? 3 : 2,
                              crossAxisSpacing:
                                  deviceType(mediaWidth) > 2 ? 20 : 10,
                              mainAxisSpacing:
                                  deviceType(mediaWidth) > 2 ? 25 : 15,
                              childAspectRatio: deviceType(mediaWidth) > 3 &&
                                      deviceType(mediaWidth) < 5
                                  ? 1.8
                                  : deviceType(mediaWidth) > 2
                                      ? 1.28
                                      : 0.86,
                            ),
                            itemCount: _data!['popularVendor'].length,
                            itemBuilder: (context, index) => VendorsCard(
                                removeDistance: true,
                                onTap: () {
                                  _toVendorPage(_data!['popularVendor'][index]);
                                },
                                vendorName:
                                    _data!['popularVendor'][index].shopName,
                                typeOfBusiness: _data!['popularVendor'][index]
                                        .shopType
                                        .name ??
                                    'Not Available',
                                rating:
                                    " ${((_data!['vendor'][index].averageRating as double?) ?? 0.0).toStringAsPrecision(2).toString()} (${(_data!['popularVendor'][index].numberOfClientsReactions ?? 0).toString()})",
                                cardImage: popularVendorImage[index]),
                          ),
                        ),
                        kSizedBox,
                        SeeAllContainer(
                          title: "Products",
                          onPressed: _toSeeProducts,
                        ),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            itemCount: _data!['category'].length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: const EdgeInsets.all(10),
                              child: CategoryButton(
                                onPressed: () {
                                  setState(() {
                                    activeCategory = index;
                                    product = null;
                                    _getData();
                                  });
                                },
                                title: _data!['category'][index].name,
                                bgColor: index == activeCategory
                                    ? kAccentColor
                                    : kDefaultCategoryBackgroundColor,
                                categoryFontColor: index == activeCategory
                                    ? kPrimaryColor
                                    : kTextGreyColor,
                              ),
                            ),
                          ),
                        ),
                        kSizedBox,
                        Center(
                          child: product == null
                              ? Center(
                                  child:
                                      SpinKitChasingDots(color: kAccentColor))
                              : _data!['product'].isEmpty
                                  ? const EmptyCard(
                                      removeButton: true,
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            deviceType(mediaWidth) > 2 ? 2 : 1,
                                        crossAxisSpacing:
                                            deviceType(mediaWidth) > 2 ? 20 : 1,
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
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _data!['product'].length,
                                      itemBuilder: (context, index) =>
                                          ProductCard(
                                        product: _data!['product'][index],
                                        onTap: () => _toProductDetailScreenPage(
                                            _data!['product'][index]),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
