import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final int maxLine;
  final bool enable;
  final TextEditingController controller;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final String validator;
  final TextStyle style;
  final bool hasPassword;
  final TextInputType keyboardType;
  final InputBorder inputBorder;
  CustomTextField({
    this.hintText = '',
    this.suffixIcon,
    this.enable = true,
    this.prefixIcon,
    this.validator,
    this.maxLine,
    this.controller,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.inputBorder,
    this.hasPassword = false,
    this.keyboardType = TextInputType.text,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: style ??
          TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.black),
      textAlign: TextAlign.left,
      enabled: enable,
      maxLines: maxLine,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: AppColor.lavender),
        border: inputBorder ?? InputBorder.none,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: validator,
      ),
      obscureText: hasPassword,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
    );
  }
}
