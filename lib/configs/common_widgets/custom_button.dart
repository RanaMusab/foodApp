import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? width;
  final double? height;
  final double? radius;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final String text;
  final bool? showShadow;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.verticalPadding,
    this.backgroundColor,
    this.shadowColor,
    this.horizontalPadding,
    this.width,
    this.height,
    this.radius,
    this.borderColor,
    this.textColor,
    this.textStyle,
    required this.text,
    this.showShadow,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height == 0 ? null : widget.height ?? 60.h,
        padding: EdgeInsets.symmetric(
          horizontal: widget.horizontalPadding ?? 20.w,
          vertical: widget.verticalPadding ?? 13.h,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          gradient:
              widget.backgroundColor == null
                  ? LinearGradient(
                    colors: [R.colors.secondaryColor, R.colors.secondaryColor2],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : null,
          borderRadius: BorderRadius.circular(widget.radius ?? 30),
          border:
              widget.borderColor != null
                  ? Border.all(color: widget.borderColor!)
                  : null,
          boxShadow:
              widget.showShadow ?? true
                  ? _isPressed
                      ? []
                      : [
                        BoxShadow(
                          color:widget.shadowColor ?? R.colors.shadowColor, // Shadow color
                          offset: Offset(0, 10), // Like dy="10"
                          blurRadius: 16, // Like stdDeviation="8"
                        ),
                      ]
                  : null,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style:
              widget.textStyle ??
              R.textStyles.font18M.copyWith(
                color: widget.textColor ?? R.colors.white,
              ),
        ),
      ),
    );
  }
}
