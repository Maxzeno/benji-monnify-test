import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final Function() onPressed;
  final String title;
  final Color bgColor;
  final Color categoryFontColor;
  const CategoryButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.bgColor,
    required this.categoryFontColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 14,
          color: categoryFontColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
