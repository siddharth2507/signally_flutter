import 'package:flutter/material.dart';
import 'package:signalbyt/constants/app_colors.dart';


class DecorationUtils {
  BuildContext context;

  DecorationUtils(this.context);

  InputDecoration getUnderlineInputDecoration({
    String? labelText = "",
    bool isRequire = false,
    bool isEnable = true,
    final Color? enableColor,
    final Color? disabledColor,
    bool? alignLabelWithHint,
    final Color? focusedColor,
    final TextStyle? hintTextStyle,
    final Color? labelTextColor,
    final FloatingLabelBehavior? floatingLabelBehavior,
    icon,
    final Widget? prefixIcon,
    final Widget? suffixIcon,
    final BorderRadius? borderRadius,
    final Color? fillColor,
    final Color? hintColor,
  }) {
    return InputDecoration(
      fillColor: isRequire ? fillColor ?? appColorCardLight : appColorCardLight,
      filled: (isEnable) ? true : true,
      alignLabelWithHint: alignLabelWithHint,
      suffixIcon: suffixIcon,
      icon: icon,
      border: InputBorder.none,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.all(8.0),
      labelText: labelText,
      // hintText: labelText,
      counterText: "",
      labelStyle: TextStyle(
        color: labelTextColor ?? Colors.grey,
      ),
      hintStyle:hintTextStyle?? TextStyle(
        color: hintColor ?? Colors.grey,
      ),
      floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.auto,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: enableColor ?? appColorCardDark, width: 0.5),

      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: disabledColor ?? appColorCardDark, width: 0.5),

      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: focusedColor ?? appColorCardDark, width: 0.5),
      ),
    );
  }
}
