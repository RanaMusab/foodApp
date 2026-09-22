import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';

class CustomAvatar extends StatelessWidget {
  final double? radius;
  final double? borderWidth;
  final Color? borderColor, backgroundColor;
  final bool isBorder;
  final Widget? child;
  const CustomAvatar(
      {super.key,
        this.radius,
        this.borderWidth,
        this.borderColor,
        this.isBorder = true,
        this.child,
        this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (radius ?? 23) * 2,
      width: (radius ?? 23) * 2,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        border: isBorder
            ? Border.all(
          width: borderWidth ?? 1,
          color: borderColor ?? R.colors.lightGreyColor.withValues(alpha: 0.6),
        )
            : null,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular((radius ?? 23) * 2),
          child: child),
    );
  }
}
