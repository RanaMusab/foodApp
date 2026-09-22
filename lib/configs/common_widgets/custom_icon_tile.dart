import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/configs/resources/sizing.dart';

import '../../../../configs/resources/resources.dart';

class CustomIconTile extends StatelessWidget {
  final String iconPath;
  final String text;
  final bool isSelected;

  const CustomIconTile({
    super.key,
    required this.iconPath,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isSelected
                ? R.colors.secondaryColor15
                : const Color(0xFFF4F7F6), // Background color
        borderRadius: BorderRadius.circular(30),
        border: isSelected ? Border.all(color: R.colors.secondaryColor) : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: R.colors.primaryColor15,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: SvgPicture.asset(iconPath),
              ),
            ),
            12.wBox,
            Expanded(child: Text(text, style: R.textStyles.font16M)),
          ],
        ),
      ),
    );
  }
}
