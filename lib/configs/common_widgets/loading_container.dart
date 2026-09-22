
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/shimmer_effect/shimmer.dart';

enum BoxType {
  circular,
  rectangle,
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    this.height,
    this.width,
    this.radius,
    this.margin,
    this.boxType = BoxType.rectangle, // Default to circular
  });

  final double? height, width, radius;
  final EdgeInsets? margin;
  final BoxType boxType;

  @override
  Widget build(BuildContext context) {
    BoxShape shape =
    boxType == BoxType.circular ? BoxShape.circle : BoxShape.rectangle;

    return Shimmer(
      child: Container(
        height: height ?? 30,
        width: width ?? 44,
        margin: margin,
        decoration: BoxDecoration(
          color: R.colors.lightGreyColor,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : BorderRadius.circular(radius ?? 5),
        ),
      ),
    );
  }
}
