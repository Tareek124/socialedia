import 'package:flutter/material.dart';

import 'color_mode.dart';

class CustomTextFieldOutline extends StatelessWidget {
  const CustomTextFieldOutline(
      {Key? key,
      this.label,
      this.controller,
      this.icon,
      this.isPassword,
      required this.maxLines})
      : super(key: key);

  final String? label;
  final TextEditingController? controller;
  final Icon? icon;
  final bool? isPassword;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context,
            width: 2, color: colorMode(context)),
        borderRadius: BorderRadius.circular(9));

    return TextFormField(
      maxLines: maxLines,
      obscureText: isPassword!,
      keyboardType: isPassword!
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        labelText: label,
        focusedBorder: inputBorder,
        prefixIcon: icon,
        errorBorder: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedErrorBorder: inputBorder,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          if (isPassword!) {
            return "Enter Valid Password";
          } else {
            return "Field Can't Be Empty";
          }
        }
        return null;
      },
    );
  }
}
