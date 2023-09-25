import 'dart:io';

import 'package:benji_user/app/auth/forgot_password.dart';
import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:benji_user/src/common_widgets/button/my_elevatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/others/my_future_builder.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';
import '../auth/login.dart';
import 'edit_profile.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
  }

  //=======================================================================================================================================\\

  //==================================================== CONTROLLERS ======================================================\\
  final _scrollController = ScrollController();

//============================================== ALL VARIABLES =================================================\\
  int activeCategory = 0;
  String cartCount = '';

  //=========================== IMAGE PICKER ====================================\\

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

//============================================== BOOL VALUES =================================================\\

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

  //=========================== WIDGETS ====================================\\
  Widget _profilePicBottomSheet() {
    return selectedImage == null
        ? Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profile photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                kSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pickProfilePic(ImageSource.camera);
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: kGreyColor1,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: kAccentColor,
                            ),
                          ),
                        ),
                        kHalfSizedBox,
                        const Text(
                          "Camera",
                        ),
                      ],
                    ),
                    kWidthSizedBox,
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            pickProfilePic(ImageSource.gallery);
                          },
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: const BorderSide(
                                  width: 0.5,
                                  color: kGreyColor1,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.image,
                              color: kAccentColor,
                            ),
                          ),
                        ),
                        kHalfSizedBox,
                        const Text(
                          "Gallery",
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            height: 140,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Profile photo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(80),
                      onTap: () {},
                      child: FaIcon(
                        FontAwesomeIcons.solidTrashCan,
                        color: kAccentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                MyElevatedButton(
                  title: "Upload Image",
                  onPressed: _uploadImage,
                ),
              ],
            ),
          );
  }

  //==================================================== FUNCTIONS ===========================================================\\

  //===================== Profile Picture ==========================\\
  _uploadImage() async {}

  pickProfilePic(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
    );
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {}
  //========================================================================\\

  //==================================================== Navigation ===========================================================\\
  void _toEditProfile() async {
    await Get.to(
      () => const EditProfile(),
      routeName: 'EditProfile',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

  void _toChangePassword() async {
    await Get.to(
      () => const ForgotPassword(
          title: "Email",
          subTitle:
              "Enter your email below and we will send you a code via which you need to change your password"),
      routeName: 'ForgotPassword',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    // double mediaHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Profile Settings",
          elevation: 0.0,
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
            radius: const Radius.circular(10),
            scrollbarOrientation: ScrollbarOrientation.right,
            child: ListView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                MyFutureBuilder(
                  future: getUser(),
                  child: (snapshot) => Container(
                    width: mediaWidth,
                    padding: const EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        elevation: 20,
                                        barrierColor:
                                            kBlackColor.withOpacity(0.8),
                                        showDragHandle: true,
                                        useSafeArea: true,
                                        isDismissible: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(
                                              kDefaultPadding,
                                            ),
                                          ),
                                        ),
                                        enableDrag: true,
                                        builder: (builder) =>
                                            _profilePicBottomSheet(),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(100),
                                    child: selectedImage == null
                                        ? Container(
                                            height: 150,
                                            width: 150,
                                            decoration: ShapeDecoration(
                                              color: kPageSkeletonColor,
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/profile/avatar-image.jpg",
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              shape: const OvalBorder(),
                                            ),
                                          )
                                        : Container(
                                            height: 150,
                                            width: 150,
                                            decoration: ShapeDecoration(
                                              color: kPageSkeletonColor,
                                              image: DecorationImage(
                                                image:
                                                    FileImage(selectedImage!),
                                                fit: BoxFit.contain,
                                              ),
                                              shape: const OvalBorder(),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 5,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          elevation: 20,
                                          barrierColor:
                                              kBlackColor.withOpacity(0.8),
                                          showDragHandle: true,
                                          useSafeArea: true,
                                          isDismissible: true,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(
                                                kDefaultPadding,
                                              ),
                                            ),
                                          ),
                                          enableDrag: true,
                                          builder: (builder) =>
                                              _profilePicBottomSheet(),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: ShapeDecoration(
                                          color: kAccentColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        kWidthSizedBox,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${snapshot.firstName} ${snapshot.lastName}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              snapshot.email,
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
                                  snapshot.code,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _copyToClipboard(context, snapshot.code);
                                  },
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
                      ],
                    ),
                  ),
                ),
                kSizedBox,
                InkWell(
                  onTap: _toEditProfile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: mediaWidth,
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      enableFeedback: true,
                      leading: FaIcon(
                        FontAwesomeIcons.userPen,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Edit profile',
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
                  ),
                ),
                kHalfSizedBox,
                InkWell(
                  onTap: _toChangePassword,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: mediaWidth,
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      enableFeedback: true,
                      leading: FaIcon(
                        FontAwesomeIcons.solidPenToSquare,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Change Password',
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
                  ),
                ),
                kHalfSizedBox,
                InkWell(
                  onTap: _logOut,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: mediaWidth,
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      enableFeedback: true,
                      leading: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        color: kAccentColor,
                      ),
                      title: const Text(
                        'Log out',
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
