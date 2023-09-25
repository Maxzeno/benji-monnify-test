import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:benji_user/src/repo/models/package/delivery_item.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:benji_user/theme/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

import '../../src/providers/constants.dart';
import 'view_package.dart';

class MyPackages extends StatefulWidget {
  const MyPackages({super.key});

  @override
  State<MyPackages> createState() => _MyPackagesState();
}

class _MyPackagesState extends State<MyPackages>
    with SingleTickerProviderStateMixin {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    _tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

//================================================= CONTROLLERS ===================================================\\
  late TabController _tabBarController;
  final _scrollController = ScrollController();
//================================================= FUNCTIONS ===================================================\\

  Future<List<DeliveryItem>> _getDataPending() async {
    List<DeliveryItem> pending =
        await getDeliveryItemsByClientAndStatus('pending');
    return pending;
  }

  Future<List<DeliveryItem>> _getDataCompleted() async {
    List<DeliveryItem> completed =
        await getDeliveryItemsByClientAndStatus('completed');
    return completed;
  }

  Future<void> _handleRefresh() async {
    // setState(() {});
  }

  int _selectedtabbar = 0;
  void _clickOnTabBarOption(value) async {
    setState(() {
      _selectedtabbar = value;
    });
  }

//================================================= Navigation ===================================================\\

  void _viewPendingPackage(deliveryItem) => Get.to(
        () => ViewPackage(deliveryItem: deliveryItem),
        routeName: 'ViewPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.size,
      );

  void _viewDeliveredPackage(deliveryItem) => Get.to(
        () => ViewPackage(deliveryItem: deliveryItem),
        routeName: 'ViewPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.size,
      );

  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "My Packages",
          elevation: 0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(kDefaultPadding),
              physics: const BouncingScrollPhysics(),
              children: [
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
                        color: kLightGreyColor,
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
                            dragStartBehavior: DragStartBehavior.start,
                            mouseCursor: SystemMouseCursors.click,
                            automaticIndicatorColorAdjustment: true,
                            overlayColor:
                                MaterialStatePropertyAll(kAccentColor),
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
                              Tab(text: "Pending"),
                              Tab(text: "Completed"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _selectedtabbar == 0
                      ? FutureBuilder(
                          future: _getDataPending(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return SizedBox(
                                width: mediaWidth,
                                child: Column(
                                  children: [
                                    snapshot.data!.isEmpty
                                        ? const EmptyCard(
                                            removeButton: true,
                                          )
                                        : ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    Divider(color: kGreyColor),
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Container(
                                              child: ListTile(
                                                onTap: () =>
                                                    _viewPendingPackage(
                                                        snapshot.data![index]),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                enableFeedback: true,
                                                dense: true,
                                                leading: FaIcon(
                                                  FontAwesomeIcons.boxesStacked,
                                                  color: kAccentColor,
                                                ),
                                                title: Text(
                                                  snapshot
                                                      .data![index].itemName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: kTextBlackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                subtitle: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(text: "Price:"),
                                                      const TextSpan(text: " "),
                                                      TextSpan(
                                                        text:
                                                            "₦${formattedText(snapshot.data![index].prices)}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'sen',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: FaIcon(
                                                  FontAwesomeIcons
                                                      .hourglassHalf,
                                                  color: kSecondaryColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
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
                          future: _getDataCompleted(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return SizedBox(
                                width: mediaWidth,
                                child: Column(
                                  children: [
                                    snapshot.data!.isEmpty
                                        ? const EmptyCard(
                                            removeButton: true,
                                          )
                                        : ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    Divider(color: kGreyColor),
                                            itemCount: snapshot.data!.length,
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Container(
                                              child: ListTile(
                                                onTap: () =>
                                                    _viewDeliveredPackage(
                                                        (snapshot
                                                            .data![index])),
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                enableFeedback: true,
                                                dense: true,
                                                leading: FaIcon(
                                                  FontAwesomeIcons.boxesStacked,
                                                  color: kAccentColor,
                                                ),
                                                title: Text(
                                                  snapshot
                                                      .data![index].itemName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: kTextBlackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                subtitle: Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const TextSpan(text: "Price:"),
                                                      const TextSpan(text: " "),
                                                      TextSpan(
                                                        text:
                                                            "₦${formattedText(snapshot.data![index].prices)}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: 'sen',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: const FaIcon(
                                                  FontAwesomeIcons
                                                      .solidCircleCheck,
                                                  color: kSuccessColor,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: SpinKitChasingDots(
                                color: kAccentColor,
                              ),
                            );
                          },
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
