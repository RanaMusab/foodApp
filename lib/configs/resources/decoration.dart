import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';

class AppDecoration {
  InputDecoration fieldDecoration({
    Widget? preIcon,
    required String hintText,
    Color? hintTextColor,
    String? labelText,
    Widget? suffixIcon,
    double? radius,
    double? horizontalPadding,
    double? verticalPadding,
    double? iconMinWidth,
    Color? fillColor,
    Color? borderColor,
    FocusNode? focusNode,
    TextStyle? hintTextStyle,
    bool showCounter = false,
  }) {
    return InputDecoration(
      counterText: showCounter ? null : '',
      prefixIconConstraints: BoxConstraints(minWidth: iconMinWidth ?? 42),
      suffixIconConstraints: BoxConstraints(minWidth: iconMinWidth ?? 42),
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 16,
        vertical: verticalPadding ?? 12,
      ),
      fillColor: fillColor ?? R.colors.fillColor,
      hintText: hintText,
      hintStyle: hintTextStyle ?? R.textStyles.font12R,
      labelText: labelText,
      labelStyle: R.textStyles.font10R,
      prefixIcon: preIcon,
      suffixIcon: suffixIcon != null ? Container(child: suffixIcon) : null,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: borderColor ?? R.colors.borderColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.red, width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
        borderSide: BorderSide(color: R.colors.red, width: 1.3),
      ),
      filled: true,
    );
  }

  InputDecoration fieldBorderDecoration({
    Widget? preIcon,
    required String hintText,
    String? labelText,
    Widget? suffixIcon,
    double? radius,
    double? horizontalPadding,
    double? verticalPadding,
    double? iconMinWidth,
    Color? fillColor,
    Color? borderColor,
    Color? hintTextColor,
    FocusNode? focusNode,
    TextStyle? hintTextStyle,
  }) {
    return InputDecoration(
      prefixIconConstraints: BoxConstraints(minWidth: iconMinWidth ?? 42),
      suffixIconConstraints: BoxConstraints(minWidth: iconMinWidth ?? 42),
      contentPadding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 16,
        vertical: verticalPadding ?? 12,
      ),
      fillColor: fillColor ?? R.colors.white,
      hintText: hintText,
      hintStyle: hintTextStyle ?? R.textStyles.font12R,
      labelText: labelText,
      labelStyle: R.textStyles.font10R,
      prefixIcon: preIcon,
      suffixIcon: suffixIcon != null ? Container(child: suffixIcon) : null,
      isDense: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: borderColor ?? R.colors.borderColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: R.colors.borderColor, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: R.colors.red, width: 1.3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 25)),
        borderSide: BorderSide(color: R.colors.red, width: 1.3),
      ),
      filled: true,
    );
  }

  BoxDecoration boxDecoration({double? radius}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius ?? 20),
      color: R.colors.veryLightGrey,
    );
  }

  BoxDecoration boxDecorationCircular({double? radius, Color? color}) {
    return BoxDecoration(
      color: color ?? R.colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? 30.sp),
        topRight: Radius.circular(radius ?? 30.sp),
      ),
    );
  }
}
