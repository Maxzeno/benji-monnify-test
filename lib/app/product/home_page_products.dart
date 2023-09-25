import 'package:benji_user/app/product/product_detail_screen.dart';
import 'package:benji_user/src/common_widgets/button/category%20button.dart';
import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:benji_user/src/repo/models/address_model.dart';
import 'package:benji_user/src/repo/models/category/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/product/product_card.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/product/product.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class HomePageProducts extends StatefulWidget {
  const HomePageProducts({super.key});

  @override
  State<HomePageProducts> createState() => _HomePageProductsState();
}

class _HomePageProductsState extends State<HomePageProducts> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Map? _data;
  int activeCategory = 0;

  _getData() async {
    await checkAuth(context);
    String current = 'Select Address';
    try {
      current = (await getCurrentAddress()).streetAddress ?? current;
    } catch (e) {
      current = current;
    }

    List<Product> product = [];
    List<SubCategory> category = await getSubCategories();
    try {
      product = await getProductsBySubCategory(category[activeCategory].id);
    } catch (e) {
      product = [];
    }
    setState(() {
      _data = {
        'category': category,
        'product': product,
      };
    });
  }
  //==================================================== ALL VARIABLES ===========================================================\\

  //==================================================== BOOL VALUES ===========================================================\\

  //==================================================== CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();

  //==================================================== FUNCTIONS ===========================================================\\
  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
    });
    await _getData();
  }
  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Products",
          toolbarHeight: kToolbarHeight,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _data == null
              ? SpinKitChasingDots(color: kAccentColor)
              : Scrollbar(
                  controller: _scrollController,
                  radius: const Radius.circular(10),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
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
                                  _data!['product'] = null;
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
                      _data!['product'] == null
                          ? Center(
                              child: SpinKitChasingDots(color: kAccentColor))
                          : _data!['product'].isEmpty
                              ? const EmptyCard(
                                  removeButton: true,
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        deviceType(media.width) > 2 ? 2 : 1,
                                    crossAxisSpacing:
                                        deviceType(media.width) > 2 ? 20 : 1,
                                    mainAxisSpacing:
                                        deviceType(media.width) > 2 ? 25 : 15,
                                    childAspectRatio:
                                        deviceType(media.width) > 2 ? 1.4 : 1.2,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _data!['product'].length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(kDefaultPadding),
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          ProductCard(
                                    onTap: () {
                                      Get.to(
                                        () => ProductDetailScreen(
                                            product: _data!['product'][index]),
                                        routeName: 'ProductDetailScreen',
                                        duration:
                                            const Duration(milliseconds: 300),
                                        fullscreenDialog: true,
                                        curve: Curves.easeIn,
                                        preventDuplicates: true,
                                        popGesture: true,
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    product: _data!['product'][index],
                                  ),
                                ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
