import 'package:flutter/cupertino.dart';
import 'package:food_app/configs/resources/sizing.dart';

import '../resources/resources.dart';

class CustomInfoContainer extends StatelessWidget {
  final String text;

  const CustomInfoContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.rotate(
          angle: 0, // No rotation, triangle already points right
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 13,
              height: 15,
              color: R.colors.primaryColor15,
            ),
          ),
        ),
        Container(
          width: 235.w,
          decoration: BoxDecoration(
            color: R.colors.primaryColor15,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 15.w,right: 15.w),
          child: Text(text, style: R.textStyles.font16M),
        ),
      ],
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
