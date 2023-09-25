import 'package:benji_user/src/common_widgets/snackbar/my_floating_snackbar.dart';
import 'package:benji_user/src/repo/models/package/item_category.dart';
import 'package:benji_user/src/repo/models/package/item_weight.dart';
import 'package:benji_user/src/repo/models/user/user_model.dart';
import 'package:benji_user/src/repo/utils/base_url.dart';
import 'package:benji_user/src/repo/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/textformfield/my textformfield.dart';
import '../../src/common_widgets/textformfield/my_intl_phonefield.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import 'choose_rider.dart';
import 'itemCategoryDropDownMenu.dart';

class SendPackage extends StatefulWidget {
  const SendPackage({super.key});

  @override
  State<SendPackage> createState() => _SendPackageState();
}

class _SendPackageState extends State<SendPackage> {
  //=============================== ALL VARIABLES ==================================\\
  int _currentStep = 0;
  bool _nextPage = false;
  bool _continuePage = false;
  bool _processingRequest = false;
  get mediaWidth => MediaQuery.of(context).size.width;

  //=============================== CONTROLLERS ==================================\\

  final _formKey = GlobalKey<FormState>();

  //=============================== CONTROLLERS ==================================\\
  final _pickupEC = TextEditingController();
  final _senderNameEC = TextEditingController();
  final _senderPhoneEC = TextEditingController();
  final _dropOffEC = TextEditingController();
  final _receiverNameEC = TextEditingController();
  final _receiverPhoneEC = TextEditingController();
  final _itemNameEC = TextEditingController();
  final _itemCategoryEC = TextEditingController();
  final _itemWeightEC = TextEditingController();
  final _itemQuantityEC = TextEditingController();
  // var _AddressesState = TextEditingController();
  final _itemValueEC = TextEditingController();

  //=============================== FOCUS NODES ==================================\\
  final _pickupFN = FocusNode();
  final _senderNameFN = FocusNode();
  var senderPhoneFN = FocusNode();
  var dropOffFN = FocusNode();
  var receiverNameFN = FocusNode();
  var receiverPhoneFN = FocusNode();
  var itemNameFN = FocusNode();
  var itemQuantityFN = FocusNode();
  var itemValueFN = FocusNode();

  //=============================== FUNCTIONS ==================================\\
  @override
  void initState() {
    super.initState();
    _getData();
  }

  String countryDialCode = '234';
  List<ItemCategory> _category = [];
  List<ItemWeight> _weight = [];

  _getData() async {
    await checkAuth(context);
    List<ItemCategory> category = await getPackageCategory();
    List<ItemWeight> weight = await getPackageWeight();

    setState(() {
      _category = category;
      _weight = weight;
    });
  }

  Future<bool> createDeliveryItem({
    required clientId,
    required pickUpAddress,
    required senderName,
    required senderPhoneNumber,
    required dropOffAddress,
    required receiverName,
    required receiverPhoneNumber,
    required itemName,
    required itemCategoryId,
    required itemWeightId,
    required itemQuantity,
    required itemValue,
  }) async {
    Map body = {
      'client_id': clientId,
      'pickUpAddress': pickUpAddress,
      'senderName': senderName,
      'senderPhoneNumber': senderPhoneNumber,
      'dropOffAddress': dropOffAddress,
      'receiverName': receiverName,
      'receiverPhoneNumber': receiverPhoneNumber,
      'itemName': itemName,
      'itemCategory_id': itemCategoryId,
      'itemWeight_id': itemWeightId,
      'itemQuantity': itemQuantity,
      'itemValue': itemValue,
    };

    final response = await http.post(
      Uri.parse('$baseURL/sendPackage/createItemPackage/'),
      body: body,
      headers: await authHeader(),
    );

    return response.statusCode == 200 && response.body == '"Package Created."';
  }

  _postData() async {
    setState(() {
      _processingRequest = true;
    });
    await checkAuth(context);
    User? user = await getUser();
    // try {
    bool res = await createDeliveryItem(
      clientId: user!.id.toString(),
      dropOffAddress: _dropOffEC.text,
      itemCategoryId: _itemCategoryEC.text,
      itemName: _itemNameEC.text,
      itemQuantity: _itemQuantityEC.text,
      itemValue: _itemValueEC.text,
      itemWeightId: _itemWeightEC.text,
      pickUpAddress: _pickupEC.text,
      receiverName: _receiverNameEC.text,
      receiverPhoneNumber: '+$countryDialCode${_receiverPhoneEC.text}',
      senderName: _senderNameEC.text,
      senderPhoneNumber: '+$countryDialCode${_senderPhoneEC.text}',
    );
    if (res) {
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Your delivery request has been submitted",
        const Duration(seconds: 2),
      );

      setState(() {
        _processingRequest = false;
      });
      Get.to(
        () => const ChooseRider(),
        routeName: 'ChooseRider',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    } else {
      mySnackBar(
        context,
        kErrorColor,
        "Failed!",
        "Failed to submit",
        const Duration(seconds: 2),
      );
      setState(() {
        _processingRequest = false;
      });
    }
  }

  _continueStep() {
    if (_currentStep < 2) {
      setState(() {
        _nextPage = true;
        _currentStep = _currentStep + 1;
      });
    }
    if (_currentStep == 2) {
      setState(() {
        _nextPage = true;
        _continuePage = true;
      });
    }
  }

  _cancelStep() {
    if (_currentStep < 2) {
      setState(() {
        _nextPage = false;
      });
    }

    if (_currentStep > 0) {
      setState(() {
        _currentStep = _currentStep - 1;
        _continuePage = false;
      });
    }
  }

  //=============================== WIDGETS ==================================\\

  // Widget stepIconBuilder(context, details) {
  //   return Icon(
  //     Icons.check,
  //     color: kPrimaryColor,
  //     size: 15,
  //   );
  // }

  Widget _controlsBuilder(context, details) {
    return _nextPage == false
        ? ElevatedButton(
            onPressed: details.onStepContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentColor,
              elevation: 20.0,
              fixedSize: Size(MediaQuery.of(context).size.width, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Next"),
          )
        : _continuePage == true
            ? _processingRequest
                ? Center(child: SpinKitChasingDots(color: kAccentColor))
                : Row(
                    children: [
                      ElevatedButton(
                        onPressed: _postData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kAccentColor,
                          elevation: 20.0,
                          fixedSize:
                              Size(MediaQuery.of(context).size.width / 2, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Continue"),
                      ),
                      kWidthSizedBox,
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          elevation: 20.0,
                          side: BorderSide(color: kAccentColor, width: 1.2),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width / 5, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(color: kAccentColor),
                        ),
                      )
                    ],
                  )
            : Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentColor,
                      elevation: 20.0,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 2, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Next"),
                  ),
                  kWidthSizedBox,
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      elevation: 20.0,
                      side: BorderSide(color: kAccentColor, width: 1.2),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width / 5, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(color: kAccentColor),
                    ),
                  )
                ],
              );
  }

  List<Step> steps() => [
        Step(
          subtitle: const Text("details"),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Sender's",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            // mainAxisAlignment: MainAxis,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pickup Address",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _pickupEC,
                validator: (value) {
                  RegExp pickupAddress = RegExp(r'^\d+\s+[a-zA-Z0-9\s.-]+$');
                  if (value!.isEmpty || value == null) {
                    _pickupFN.requestFocus();
                    return "Enter pickup location";
                  } else if (!pickupAddress.hasMatch(value)) {
                    _pickupFN.requestFocus();
                    return "Enter a valid address (must have a street number)";
                  }
                  return null;
                },
                onSaved: (value) {
                  _pickupEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: _pickupFN,
                hintText: "E.g 123, Main Street",
                textInputType: TextInputType.streetAddress,
              ),
              kHalfSizedBox,
              const Text(
                "Sender's Name",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _senderNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    _senderNameFN.requestFocus();
                    return "Enter your name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    _senderNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _senderNameEC.text = value;
                },
                textInputAction: TextInputAction.done,
                focusNode: _senderNameFN,
                hintText: "Enter your name",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyIntlPhoneField(
                initialCountryCode: "NG",
                invalidNumberMessage: "Invalid phone number",
                dropdownIconPosition: IconPosition.trailing,
                showCountryFlag: true,
                showDropdownIcon: true,
                dropdownIcon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: kAccentColor,
                ),
                controller: _senderPhoneEC,
                textInputAction: TextInputAction.done,
                focusNode: senderPhoneFN,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    senderPhoneFN.requestFocus();
                    return "Enter your phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  _senderPhoneEC.text = value;
                },
              ),
              kSizedBox,
            ],
          ),
        ),
        Step(
          subtitle: const Text("details"),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Receiver's",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            // mainAxisAlignment: MainAxis,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Drop-off Address",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _dropOffEC,
                validator: (value) {
                  RegExp dropOffAddress = RegExp(r'^\d+\s+[a-zA-Z0-9\s.-]+$');
                  if (value.isEmpty || value == null) {
                    dropOffFN.requestFocus();
                    return "Enter drop-off address";
                  } else if (!dropOffAddress.hasMatch(value)) {
                    dropOffFN.requestFocus();
                    return "Enter a valid address (must have a street number)";
                  }
                  return null;
                },
                onSaved: (value) {
                  _dropOffEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: dropOffFN,
                hintText: "E.g 123, Main Street",
                textInputType: TextInputType.streetAddress,
              ),
              kHalfSizedBox,
              const Text(
                "Receiver's Name",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _receiverNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    receiverNameFN.requestFocus();
                    return "Enter receiver's name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    receiverNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _receiverNameEC.text = value;
                },
                textInputAction: TextInputAction.done,
                focusNode: receiverNameFN,
                hintText: "Enter receiver's name",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyIntlPhoneField(
                initialCountryCode: "NG",
                invalidNumberMessage: "Invalid phone number",
                dropdownIconPosition: IconPosition.trailing,
                showCountryFlag: true,
                showDropdownIcon: true,
                dropdownIcon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: kAccentColor,
                ),
                controller: _receiverPhoneEC,
                textInputAction: TextInputAction.done,
                focusNode: receiverPhoneFN,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      _receiverPhoneEC.text.isEmpty) {
                    receiverPhoneFN.requestFocus();
                    return "Enter receiver's phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  _receiverPhoneEC.text = value;
                },
              ),
              kSizedBox,
            ],
          ),
        ),
        Step(
          subtitle: const Text("details"),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          title: const Text(
            "Item",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Item Name",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _itemNameEC,
                validator: (value) {
                  RegExp userNamePattern = RegExp(
                    r'^.{3,}$', //Min. of 3 characters
                  );
                  if (value == null || value!.isEmpty) {
                    itemNameFN.requestFocus();
                    return "Enter the item's name";
                  } else if (!userNamePattern.hasMatch(value)) {
                    itemNameFN.requestFocus();
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemNameEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: itemNameFN,
                hintText: "Enter the name of the item",
                textInputType: TextInputType.name,
              ),
              kHalfSizedBox,
              const Text(
                "Item Category",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              ItemDropDownMenu(
                itemEC: _itemCategoryEC,
                mediaWidth: mediaWidth,
                hintText: "Choose category",
                dropdownMenuEntries2: _category
                    .map(
                      (item) =>
                          DropdownMenuEntry(value: item.id, label: item.name),
                    )
                    .toList(),
              ),
              kSizedBox,
              const Text(
                "Item Weight",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              ItemDropDownMenu(
                itemEC: _itemWeightEC,
                mediaWidth: mediaWidth,
                hintText: "Choose weight",
                dropdownMenuEntries2: _weight
                    .map(
                      (item) => DropdownMenuEntry(
                          value: item.id,
                          label: '${item.start}KG - ${item.end}KG'),
                    )
                    .toList(),
              ),
              kSizedBox,
              const Text(
                "Item Quantity",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _itemQuantityEC,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    itemQuantityFN.requestFocus();
                    return "Enter the item's quantity";
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemQuantityEC.text = value;
                },
                textInputAction: TextInputAction.next,
                focusNode: itemQuantityFN,
                hintText: "Enter the quantity ",
                textInputType: TextInputType.number,
              ),
              kSizedBox,
              const Text(
                "Item Value",
                style: TextStyle(
                  fontSize: 17.6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              kHalfSizedBox,
              MyTextFormField(
                controller: _itemValueEC,
                validator: (value) {
                  if (value == null || value!.isEmpty) {
                    itemValueFN.requestFocus();
                    return "Enter the item's value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemValueEC.text = value;
                },
                textInputAction: TextInputAction.done,
                focusNode: itemValueFN,
                hintText: "Enter the value (in Naira)",
                textInputType: TextInputType.number,
              ),
              kSizedBox,
              InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.blue.shade50,
                focusColor: Colors.blue.shade50,
                highlightColor: Colors.blue.shade50,
                onTap: () {},
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 144,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        color: Color(0xFFE6E6E6),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_upload),
                        // Image.asset(
                        //   "assets/icons/image-upload.png",
                        // ),
                        kHalfSizedBox,
                        Text(
                          'Upload an image of the item',
                          style: TextStyle(
                            color: kTextGreyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              kSizedBox,
            ],
          ),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          title: "Send Package",
          elevation: 0.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Stepper(
                physics: const BouncingScrollPhysics(),
                margin: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                ),
                currentStep: _currentStep,
                onStepContinue: _continueStep,
                onStepCancel: _cancelStep,
                onStepTapped: null,
                controlsBuilder: _controlsBuilder,
                elevation: 0.0,
                // stepIconBuilder: stepIconBuilder,
                type: StepperType.horizontal,
                steps: steps(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
