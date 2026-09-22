import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart'; // Update with your actual path

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.name,
    required this.hint,
    required this.items,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.fillColor,
    this.borderRadius,
    this.suffixIcon,
    this.width = double.infinity,
  });

  final String name;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final Color? fillColor;
  final double? borderRadius;
  final Widget? suffixIcon;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: fillColor ?? R.colors.whiteColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 30),
        boxShadow: [
          BoxShadow(
            color: R.colors.primaryColor15,
            offset: Offset(0, 5),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: FormBuilderDropdown<T>(
        key: key,
        icon:
            suffixIcon ??
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: R.colors.primaryColor,
            ),
        name: name,
        initialValue: initialValue,
        items: items,
        enabled: enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
        style: R.textStyles.font16R,
        hint: Text(
          hint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: R.textStyles.font16R.copyWith(
            color: R.colors.blackTextColor50,
          ),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25.w,
            vertical: 17.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
