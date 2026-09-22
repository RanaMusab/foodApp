import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/resources/sizing.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.node,
    this.enabled,
    this.errorText,
    this.autoFocus,
    this.prefixIcon,
    this.onChangeFtn,
    this.initialValue,
    this.validatorFtn,
    this.textAlignment,
    required this.name,
    required this.hint,
    this.isPass = false,
    this.textCapitalization = TextCapitalization.none,
    this.isSuffixIcon = false,
    required this.textInputType,
    this.width = double.infinity,
    this.verticalPadding,
    this.borderRadius,
    this.textInputAction = TextInputAction.done,
    this.readOnly,
    this.onTap,
    this.onPressSuffix,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textController,
    this.onSubmitFtn,
    this.helperText,
    this.textStyle,
    this.helperStyle,
    this.suffixIcon,
    this.autocorrect,
    this.enableSuggestions,
    this.show = false,
    this.borderColor,
    this.fillColor,
    this.onTapEye,
    this.inputFormatter,
  });

  final String name;
  final int? maxLines, minLines, maxLength;
  final TextEditingController? textController;
  final String? hint, helperText, errorText, initialValue;
  final TextStyle? helperStyle,textStyle;
  final bool? isPass, show, readOnly, enabled, autoFocus, isSuffixIcon,autocorrect, enableSuggestions;
  final double? width, verticalPadding, borderRadius;
  final FocusNode? node;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap, onTapEye, onPressSuffix;
  final TextAlign? textAlignment;
  final Color? borderColor;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatter;

  final String? Function(String?)? validatorFtn;
  final String? Function(String?)? onChangeFtn;
  final String? Function(String?)? onSubmitFtn;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
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
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FormBuilderTextField(
              onTapOutside: (_) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              textAlign: textAlignment ?? TextAlign.start,
              inputFormatters: inputFormatter ?? [],
              cursorColor: R.colors.primaryColor,
              style:textStyle?? R.textStyles.font16R,
              autocorrect: autocorrect ?? false,
              enableSuggestions:enableSuggestions ?? false,
              controller: textController,
              maxLength: maxLength,
              onTap: onTap,
              textCapitalization: textCapitalization,
              enabled: enabled ?? true,
              initialValue: initialValue,
              name: name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: autoFocus ?? false,
              textInputAction: textInputAction,
              keyboardType: textInputType,
              focusNode: node,
              readOnly: readOnly ?? false,
              obscureText: show ?? false,
              maxLines: maxLines ?? 1,
              minLines: minLines,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.transparent,
                // Already wrapped with background color
                helperMaxLines: 2,
                helperStyle: helperStyle,
                helperText: helperText,
                errorText: errorText,
                prefixIcon: prefixIcon,
                suffixIcon:
                    isPass!
                        ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            splashRadius: 10,
                            onPressed: onTapEye,
                            icon: Icon(
                              !show! ? Icons.visibility_off : Icons.visibility,
                              size: 20.sp,
                              color: R.colors.primaryColor,
                            ),
                          ),
                        )
                        : GestureDetector(
                          onTap: onPressSuffix,
                          child: SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: suffixIcon,
                          ),
                        ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                  vertical: verticalPadding ?? 17.h,
                ),
                hintText: hint,
                hintStyle: R.textStyles.font16R.copyWith(
                  color: R.colors.hintColor,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide:BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide:BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 30),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: validatorFtn,
              onChanged: onChangeFtn,
              onSubmitted: onSubmitFtn,
            );
          },
        ),
      ),
    );
  }
}
