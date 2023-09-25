import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/colors.dart';

class MyMessageTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final dynamic onSaved;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final int maxLines;
  final int maxLength;
  final TextInputType keyboardType;

  const MyMessageTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.onSaved,
    required this.textInputAction,
    required this.focusNode,
    required this.hintText,
    required this.maxLines,
    required this.keyboardType,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onSaved: onSaved,
      textInputAction: textInputAction,
      textAlign: TextAlign.start,
      cursorColor: kSecondaryColor,
      autocorrect: true,
      validator: validator,
      maxLines: maxLines,
      enableSuggestions: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      mouseCursor: SystemMouseCursors.click,
      enableInteractiveSelection: true,
      keyboardType: keyboardType,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      maxLength: maxLength,
      scrollPhysics: const BouncingScrollPhysics(),
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(
        color: kSecondaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
    );
  }
}
