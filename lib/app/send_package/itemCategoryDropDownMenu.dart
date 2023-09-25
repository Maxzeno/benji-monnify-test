import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class ItemDropDownMenu extends StatelessWidget {
  const ItemDropDownMenu({
    super.key,
    required this.itemEC,
    required this.mediaWidth,
    required this.hintText,
    required this.dropdownMenuEntries2,
  });

  final TextEditingController itemEC;
  final mediaWidth;
  final hintText;
  final dropdownMenuEntries2;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      onSelected: (value) {
        itemEC.text = value!.toString();
      },
      width: mediaWidth / 1.28,
      hintText: hintText,
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: const TextStyle(
          color: kErrorColor,
        ),
        filled: true,
        fillColor: Colors.blue.shade50,
        focusColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.blue.shade50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: kErrorBorderColor,
            width: 2.0,
          ),
        ),
      ),
      dropdownMenuEntries: dropdownMenuEntries2,
    );
  }
}
