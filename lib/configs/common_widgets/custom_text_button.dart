import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? width;
  final double? height;
  final Color? color;
  final double? radius;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final String text;
  const CustomTextButton({super.key, required this.onPressed, this.verticalPadding, this.horizontalPadding, this.color, this.radius, this.borderColor, this.textColor, this.textStyle, required this.text, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 20.w, vertical: verticalPadding ?? 13.h),
        decoration: BoxDecoration(
            color: color ?? R.colors.primaryColor,
            borderRadius: BorderRadius.circular(radius ?? 100),
            border: borderColor != null
                ? Border.all(
              color: borderColor ?? R.colors.primaryColor,
            )
                : const Border()),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? R.textStyles.font16M.copyWith(color: textColor),
        ),
      ),
    );
  }
}
