import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:go_router/go_router.dart';

import '../resources/resources.dart';

class CustomBackButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 2.w),
      child: GestureDetector(
        onTap:
            widget.onPressed ??
            () {
              context.pop();
            },
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: R.colors.whiteColor,
              shape: BoxShape.circle,
              boxShadow:
                  _isPressed
                      ? []
                      : [
                        BoxShadow(
                          color:  Colors.black.withAlpha(26),
                          offset: const Offset(0, 1),
                          blurRadius: 4,
                        ),
                      ],
            ),
            child: Center(
              child: SvgPicture.asset(
                R.assets.arrowLeft,
                width: 15.h,
                height: 15.h,
                colorFilter: ColorFilter.mode(
                  R.colors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
