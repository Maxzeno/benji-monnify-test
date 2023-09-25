import 'dart:io';
import 'dart:typed_data';

import 'package:benji_user/src/common_widgets/appbar/my_appbar.dart';
import 'package:benji_user/src/repo/models/package/delivery_item.dart';
import 'package:benji_user/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../src/providers/constants.dart';
import 'report_package.dart';

class ViewPackage extends StatefulWidget {
  final DeliveryItem deliveryItem;
  const ViewPackage({
    super.key,
    required this.deliveryItem,
  });

  @override
  State<ViewPackage> createState() => _ViewPackageState();
}

class _ViewPackageState extends State<ViewPackage> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _packageData = <String>[
      widget.deliveryItem.status[0].toUpperCase() +
          widget.deliveryItem.status.substring(1).toLowerCase(),
      widget.deliveryItem.senderName,
      widget.deliveryItem.senderPhoneNumber,
      widget.deliveryItem.receiverName,
      widget.deliveryItem.receiverPhoneNumber,
      widget.deliveryItem.dropOffAddress,
      widget.deliveryItem.itemName,
      (formattedText(widget.deliveryItem.itemQuantity.toDouble())),
      "${widget.deliveryItem.itemWeight.start} KG - ${widget.deliveryItem.itemWeight.end} KG",
      "₦ ${formattedText(widget.deliveryItem.itemValue.toDouble())}",
      "₦ ${formattedText(widget.deliveryItem.prices)}",
    ];
  }

  //================================================= ALL VARIABLES =====================================================\\
  DateTime now = DateTime.now();
  final List<String> _titles = <String>[
    "Status",
    "Sender's name",
    "Sender's phone number",
    "Receiver's name",
    "Receiver's phone number",
    "Receiver's location",
    "Item name",
    "Item quantity",
    "Item weight",
    "Item value",
    "Price",
  ];

  List<String>? _packageData;
  //=================================================  CONTROLLERS =====================================================\\
  final _scrollController = ScrollController();
  final _screenshotController = ScreenshotController();

  //=================================================  Navigation =====================================================\\
  void _toReportPackage() => Get.to(
        () => const ReportPackage(),
        routeName: 'ReportPackage',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  void _sharePackage() {
    showModalBottomSheet(
      context: context,
      elevation: 20,
      barrierColor: kBlackColor.withOpacity(0.8),
      showDragHandle: true,
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kDefaultPadding),
        ),
      ),
      enableDrag: true,
      builder: (builder) => shareBottomSheet(),
    );
  }

  Future<Uint8List> _generatePdf() async {
    // Create a PDF document
    final pdf = pw.Document();

    // Capture the screenshot
    final imageFile = await _screenshotController.capture();

    // Convert the image data to bytes
    final imgData = Uint8List.fromList(imageFile!);

    // Create a MemoryImage from the bytes
    final pdfImage = pw.MemoryImage(imgData);

    // Add the image to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            height: 1000,
            width: 1000,
            child: pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.contain,
                alignment: pw.Alignment.center,
                height: 800,
                width: 800,
              ),
            ),
          );
        },
      ),
    );

    // Save the PDF as bytes
    final pdfBytes = await pdf.save();

    return pdfBytes;
  }

  Future<void> _sharePDF() async {
    final pdfBytes = await _generatePdf();

    final appDir = await getTemporaryDirectory();
    final pdfName = "Benji Delivery ${formatDateAndTime(now)}";
    final pdfPath = '${appDir.path}/$pdfName.pdf';
    await File(pdfPath).writeAsBytes(pdfBytes);

    // Share the PDF file using share_plus
    await Share.shareXFiles([XFile(pdfPath)]);
  }

  _shareImage() async {
    final imageFile = await _screenshotController.capture();

    if (imageFile != null) {
      final appDir = await getTemporaryDirectory();
      final fileName = "Benji Delivery ${formatDateAndTime(now)}";
      final filePath = '${appDir.path}/$fileName.png';

      // Write the image data to the file
      await File(filePath).writeAsBytes(imageFile);

      //Share the file on any platform
      await Share.shareXFiles([XFile(filePath)], text: 'Shared from Benji');
    }
  }

  //=================================================  Widgets =====================================================\\
  Widget shareBottomSheet() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: kDefaultPadding,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              onTap: _sharePDF,
              title: Text(
                "Share PDF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Divider(height: 1, color: kGreyColor),
            ListTile(
              onTap: _shareImage,
              title: Text(
                "Share Image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kTextGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "View Package",
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              Center(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/icons/${widget.deliveryItem.status.toLowerCase() == "pending" ? "package-waiting" : "package-success"}.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              kHalfSizedBox,
              Screenshot(
                controller: _screenshotController,
                child: Card(
                  borderOnForeground: true,
                  elevation: 20,
                  color: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/logo/benji_full_logo.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Divider(color: kGreyColor, height: 0),
                          ListView.separated(
                            itemCount: _titles.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              height: 1,
                              color: kGreyColor,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 100,
                                width: mediaWidth / 3,
                                padding: const EdgeInsets.all(10),
                                decoration:
                                    BoxDecoration(color: kLightGreyColor),
                                child: Text(
                                  _titles[index],
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              trailing: Container(
                                width: mediaWidth / 2,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  _packageData![index],
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: widget.deliveryItem.status
                                                .toLowerCase() !=
                                            "pending"
                                        ? kSuccessColor
                                        : kSecondaryColor,
                                    fontSize: 12,
                                    fontFamily: 'sen',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(color: kGreyColor, height: 0),
                          kSizedBox,
                          widget.deliveryItem.status.toLowerCase() != "pending"
                              ? Text(
                                  "Thanks for choosing our service",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              : const SizedBox(),
                          Text.rich(
                            softWrap: true,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Generated by ",
                                  style: TextStyle(
                                    color: kTextGreyColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "Ben",
                                  style: TextStyle(
                                    color: kSecondaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "ji",
                                  style: TextStyle(
                                    color: kAccentColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kSizedBox,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              kSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: _toReportPackage,
                    style: OutlinedButton.styleFrom(
                      elevation: 20,
                      enableFeedback: true,
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.all(kDefaultPadding),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidFlag,
                          color: kAccentColor,
                          size: 16,
                        ),
                        kWidthSizedBox,
                        Center(
                          child: Text(
                            "Report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kAccentColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  kWidthSizedBox,
                  ElevatedButton(
                    onPressed: _sharePackage,
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: kAccentColor,
                      padding: const EdgeInsets.all(kDefaultPadding),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.shareNodes,
                          color: kPrimaryColor,
                          size: 18,
                        ),
                        kWidthSizedBox,
                        SizedBox(
                          child: Text(
                            "Share",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              kSizedBox,
            ],
          ),
        ),
      ),
    );
  }
}
