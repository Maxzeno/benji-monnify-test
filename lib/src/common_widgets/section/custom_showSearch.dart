import 'package:benji_user/app/product/product_detail_screen.dart';
import 'package:benji_user/src/common_widgets/product/product_card.dart';
import 'package:benji_user/src/providers/constants.dart';
import 'package:benji_user/src/repo/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../../theme/colors.dart';
import '../../others/my_future_builder.dart';
import '../../providers/responsive_constant.dart';

class CustomSearchDelegate extends SearchDelegate {
  void _toProductDetailScreenPage(product) {
    Get.to(
      () => ProductDetailScreen(product: product),
      routeName: 'ProductDetailScreen',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: FaIcon(FontAwesomeIcons.chevronLeft, color: kAccentColor),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: FaIcon(FontAwesomeIcons.xmark, color: kAccentColor),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    //==================================================== CONTROLLERS ===========================================================\\
    final scrollController = ScrollController();

    //==================================================== FUNCTIONS ===========================================================\\
    //===================== Get Data ==========================\\
    Future<List<Product>> _getData() async {
      if (query == '') {
        return [];
      }
      List<Product> product = await getProductsBySearching(query);
      return product;
    }

    //========================================================================\\

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: MyFutureBuilder(
        future: _getData(),
        child: (data) {
          return data.isEmpty
              ? ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/animations/empty/frame_3.json",
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                          kSizedBox,
                          Text(
                            "No product found",
                            style: TextStyle(
                              color: kTextGreyColor,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Scrollbar(
                  controller: scrollController,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          deviceType(MediaQuery.of(context).size.width) > 2
                              ? 2
                              : 1,
                      crossAxisSpacing:
                          deviceType(MediaQuery.of(context).size.width) > 2
                              ? 20
                              : 1,
                      mainAxisSpacing:
                          deviceType(MediaQuery.of(context).size.width) > 2
                              ? 25
                              : 15,
                      childAspectRatio:
                          deviceType(MediaQuery.of(context).size.width) > 2
                              ? 1.4
                              : 1.2,
                    ),
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(kDefaultPadding),
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) => ProductCard(
                      product: data[index],
                      onTap: () => _toProductDetailScreenPage(data[index]),
                    ),
                  ),
                );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/animations/empty/frame_3.json",
                  height: 300,
                  fit: BoxFit.contain,
                ),
                kSizedBox,
                Text(
                  "Search for a product",
                  style: TextStyle(
                    color: kTextGreyColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
