import 'package:flutter/material.dart';
import 'package:food_app/configs/common_widgets/custom_back_button.dart';
import 'package:food_app/configs/resources/sizing.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key, this.onPressed, this.child});

  final Function()? onPressed;
  final Widget? child;

  @override
  Size get preferredSize => Size.fromHeight(80.h);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        margin: EdgeInsets.only(top: 20.h, left: 15.w,right: 15.w),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment:
              child != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
          children: [
            CustomBackButton(onPressed: onPressed),
            if (child != null) ...{child!},
          ],
        ),
      ),
    );
  }
}
