import 'package:benji_user/src/common_widgets/empty.dart';
import 'package:benji_user/src/repo/models/order/order.dart';
import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/section/track_order_details_container.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({super.key});

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  //=================================== ALL VARIABLES ====================================\\

  //=================================== CONTROLLERS ====================================\\
  TextEditingController searchController = TextEditingController();
  //=================================== Logic ====================================\\
  @override
  void initState() {
    super.initState();
    _getData();
  }

  List<Order>? _data;

  _getData() async {
    await checkAuth(context);
    User? user = await getUser();
    List<Order> order = await getOrders(user!.id);

    setState(() {
      _data = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "My Orders ",
          toolbarHeight: 80,
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            margin: const EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: _data == null
                      ? Center(
                          child: SpinKitChasingDots(color: kAccentColor),
                        )
                      : _data!.isEmpty
                          ? const EmptyCard()
                          : ListView.separated(
                              itemCount: _data!.length,
                              separatorBuilder: (context, index) =>
                                  kHalfSizedBox,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  TrackOrderDetailsContainer(
                                order: _data![index],
                              ),
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
