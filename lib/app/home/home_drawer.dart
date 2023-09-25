import 'package:benji_user/src/others/my_future_builder.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class HomeDrawer extends StatefulWidget {
  final Function() toProfileSettings;
  final Function() copyUserIdToClipBoard;
  final Function() toCheckoutScreen;
  final Function() toFavoritesPage;
  final Function() toOrdersPage;
  final Function() toAddressesPage;
  final Function() toSendPackagePage;
  final Function() toMyPackagesPage;
  final Function() logOut;

  final String userID;
  const HomeDrawer({
    super.key,
    required this.copyUserIdToClipBoard,
    required this.userID,
    required this.toOrdersPage,
    // required this.toInvitesPage,
    required this.toAddressesPage,
    required this.toSendPackagePage,
    required this.logOut,
    required this.toFavoritesPage,
    required this.toProfileSettings,
    required this.toMyPackagesPage,
    required this.toCheckoutScreen,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: [
          MyAppBar(
            elevation: 0.0,
            title: "",
            toolbarHeight: kToolbarHeight,
            backgroundColor: kPrimaryColor,
            actions: const [],
          ),
          MyFutureBuilder(
            future: getUser(),
            child: (data) => ListTile(
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                height: 50,
                width: 50,
                decoration: ShapeDecoration(
                  color: kPageSkeletonColor,
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/images/profile/avatar-image.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: const OvalBorder(),
                ),
              ),
              title: Text(
                '${data.firstName} ${data.lastName}',
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: kTextBlackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.userID,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: kTextBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        IconButton(
                          onPressed: widget.copyUserIdToClipBoard,
                          tooltip: "Copy ID",
                          mouseCursor: SystemMouseCursors.click,
                          icon: FaIcon(
                            FontAwesomeIcons.copy,
                            size: 14,
                            color: kAccentColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          kHalfSizedBox,
          const Divider(
            color: kTextBlackColor,
          ),
          kHalfSizedBox,
          ListTile(
            onTap: widget.toProfileSettings,
            leading: FaIcon(
              FontAwesomeIcons.gear,
              color: kAccentColor,
            ),
            title: const Text(
              'Profile Settings',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toAddressesPage,
            leading: FaIcon(
              FontAwesomeIcons.locationDot,
              color: kAccentColor,
            ),
            title: const Text(
              'Addresses',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toSendPackagePage,
            leading: FaIcon(
              FontAwesomeIcons.bicycle,
              color: kAccentColor,
            ),
            title: const Text(
              'Send Package',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toMyPackagesPage,
            leading: FaIcon(
              FontAwesomeIcons.boxesStacked,
              color: kAccentColor,
            ),
            title: const Text(
              'My Packages',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toFavoritesPage,
            leading: FaIcon(
              FontAwesomeIcons.solidHeart,
              color: kAccentColor,
            ),
            title: const Text(
              'Favorites',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toCheckoutScreen,
            leading: FaIcon(
              Icons.shopping_cart_checkout,
              size: 28,
              color: kAccentColor,
            ),
            title: const Text(
              'Checkout',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toOrdersPage,
            leading: FaIcon(
              FontAwesomeIcons.boxOpen,
              color: kAccentColor,
            ),
            title: const Text(
              'My Orders',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.logOut,
            leading: FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: kAccentColor,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}
