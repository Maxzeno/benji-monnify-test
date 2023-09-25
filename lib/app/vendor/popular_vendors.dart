import 'package:benji_user/app/vendor/vendor_details.dart';
import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/vendor/vendors_card.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class PopularVendors extends StatefulWidget {
  const PopularVendors({super.key});

  @override
  State<PopularVendors> createState() => _PopularVendorsState();
}

class _PopularVendorsState extends State<PopularVendors> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(_scrollListener);
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
    if (loadMore || thatsAllData) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loadMore = true;
        start = end;
        end = end + 10;
      });

      await Future.delayed(const Duration(microseconds: 100));
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 25),
        curve: Curves.easeInOut,
      );
      await _getData();

      setState(() {
        loadMore = false;
      });
    }
  }

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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(() {});
  }

  Map? _data;
  int start = 0;
  int end = 10;
  bool loadMore = false;
  bool thatsAllData = false;
  bool _isScrollToTopBtnVisible = false;

  _getData() async {
    await checkAuth(context);
    List<VendorModel> vendor = await getPopularVendors(start: start, end: end);

    _data ??= {'vendor': []};

    setState(() {
      thatsAllData = vendor.isEmpty;
      _data = {
        'vendor': _data!['vendor'] + vendor,
      };
    });
  }

//============================================== CONTROLLERS =================================================\\
  final _scrollController = ScrollController();

  //==================================================== FUNCTIONS ===========================================================\\
  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
      start = 0;
      end = 10;
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
          title: "Popular Vendors ",
          toolbarHeight: 80,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _data == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitChasingDots(color: kAccentColor),
                  ],
                )
              : Scrollbar(
                  controller: _scrollController,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  radius: const Radius.circular(10),
                  child: ListView(
                    dragStartBehavior: DragStartBehavior.down,
                    controller: _scrollController,
                    padding: deviceType(media.width) > 2
                        ? const EdgeInsets.all(kDefaultPadding)
                        : const EdgeInsets.all(kDefaultPadding / 2),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: loadMore
                              ? _data!['vendor'].length + 1
                              : _data!['vendor'].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: deviceType(media.width) > 2 ? 3 : 2,
                            crossAxisSpacing:
                                deviceType(media.width) > 2 ? 20 : 10,
                            mainAxisSpacing:
                                deviceType(media.width) > 2 ? 25 : 15,
                            childAspectRatio:
                                deviceType(media.width) > 2 ? 1.28 : 0.8,
                          ),
                          itemBuilder: (context, index) {
                            if (_data!['vendor'].length == index) {
                              return Column(
                                children: [
                                  SpinKitChasingDots(color: kAccentColor),
                                ],
                              );
                            }
                            return VendorsCard(
                              onTap: () {
                                Get.to(
                                  () => VendorDetails(
                                      vendor: _data!['vendor'][index]),
                                  routeName: 'VendorDetails',
                                  duration: const Duration(milliseconds: 300),
                                  fullscreenDialog: true,
                                  curve: Curves.easeIn,
                                  preventDuplicates: true,
                                  popGesture: true,
                                  transition: Transition.rightToLeft,
                                );
                              },
                              cardImage: 'assets/images/vendors/ntachi-osa.png',
                              vendorName: _data!['vendor'][index].shopName,
                              typeOfBusiness:
                                  _data!['vendor'][index].shopType.name ??
                                      'Not Available',
                              rating:
                                  "${((_data!['vendor'][index].averageRating as double?) ?? 0.0).toStringAsPrecision(2).toString()} (${(_data!['vendor'][index].numberOfClientsReactions ?? 0).toString()})",
                            );
                          }),
                      thatsAllData
                          ? Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              height: 10,
                              width: 10,
                              decoration: ShapeDecoration(
                                  shape: const CircleBorder(),
                                  color: kPageSkeletonColor),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
