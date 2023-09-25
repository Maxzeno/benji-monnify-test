import 'package:benji_user/src/providers/responsive_constant.dart';
import 'package:benji_user/src/repo/utils/cart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../theme/colors.dart';
import '../../providers/constants.dart';
import '../../repo/models/product/product.dart';
import '../snackbar/my_floating_snackbar.dart';

class ProductCartContainer extends StatefulWidget {
  final Function() onTap;
  final Function()? incrementQuantity;
  final Function()? decrementQuantity;
  final Product product;
  const ProductCartContainer({
    super.key,
    required this.onTap,
    this.incrementQuantity,
    this.decrementQuantity,
    required this.product,
  });

  @override
  State<ProductCartContainer> createState() => sProductContaCartinerState();
}

class sProductContaCartinerState extends State<ProductCartContainer> {
  @override
  void initState() {
    super.initState();
    checkCart();
    _productPrice = widget.product.price;
  }
  //======================================= VARIABLES ==========================================\\

  double _productPrice = 0;
  String cartCount = '1';
  String cartCountAll = '1';

//===================== Number format ==========================\\
  String formattedText(double value) {
    final numberFormat = NumberFormat('#,##0');
    return numberFormat.format(value);
  }

//===================== Cart logic functions ==========================\\

  checkCart() async {
    String count = await countCart();
    String countAll = await countSingleCart(widget.product.id);

    setState(() {
      cartCount = count;
      cartCountAll = countAll;
    });
    if (cartCountAll == '0') {
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Item has been removed from cart.",
        const Duration(
          seconds: 1,
        ),
      );
    }
  }

  // void incrementQuantity() async {
  //   await addToCart(widget.product.id);
  //   await checkCart();
  // }

  // void decrementQuantity() async {
  //   await removeFromCart(widget.product.id);
  //   await checkCart();
  // }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return cartCountAll == '0'
        ? const SizedBox()
        : InkWell(
            onTap: widget.onTap,
            child: Container(
              width: media.width / 2.5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: ShapeDecoration(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.19),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x19616161),
                    blurRadius: 24,
                    offset: Offset(0, 0),
                    spreadRadius: 7,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 186,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/products/okra-soup.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  kSizedBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 57.06,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: media.width - 200,
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                color: kTextBlackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          kHalfSizedBox,
                          SizedBox(
                            width: media.width - 200,
                            child: Text(
                              widget.product.description,
                              style: TextStyle(
                                color: kTextGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.43,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  kSizedBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: deviceType(media.width) > 3 &&
                                  deviceType(media.width) < 5
                              ? media.width / 2.6
                              : deviceType(media.width) > 2
                                  ? media.width / 2.8
                                  : media.width / 1.6,
                          child: Text(
                            "₦${formattedText(_productPrice)}",
                            style: const TextStyle(
                              color: kTextBlackColor,
                              fontSize: 20,
                              fontFamily: 'Sen',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.decrementQuantity != null) {
                                  widget.decrementQuantity!();
                                }
                                checkCart();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.circleMinus,
                                color: kAccentColor,
                              ),
                            ),
                            Text(
                              cartCountAll,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (widget.incrementQuantity != null) {
                                  widget.incrementQuantity!();
                                }
                                checkCart();
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.circlePlus,
                                color: kAccentColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
