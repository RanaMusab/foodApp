import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/configs/resources/sizing.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';

class Utils {
  void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget widget,
    Color? barrierColor,
    bool? isDismissible,
  }) {
    showModalBottomSheet<void>(
      context: context,
      scrollControlDisabledMaxHeightRatio: double.infinity,
      useSafeArea: false,
      isDismissible: isDismissible ?? true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0.w)),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[widget],
        );
      },
    );
  }

  static Future<void> deleteConfirmationDialog({
    required BuildContext context,
    required String title,
    required String subTitle,
    required void Function() canceledOnPressed,
    required void Function() doneOnPressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: R.colors.white,
          title: Text(
            title,
            style: R.textStyles.font18B,
            textAlign: TextAlign.center,
          ),
          content: Text(
            subTitle,
            style: R.textStyles.font14R,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: canceledOnPressed,
              child: Text(R.strings.cancel, style: R.textStyles.font16B),
            ),
            ElevatedButton(
              onPressed: doneOnPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: R.colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
              child: Text(
                R.strings.delete,
                style: R.textStyles.font16B.copyWith(color: R.colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static SnackBar getSnackBar(String message) {
    return SnackBar(
      backgroundColor: R.colors.veryLightGrey,
      elevation: 2.0,
      showCloseIcon: true,
      closeIconColor: R.colors.primaryColor,
      content: Center(child: Text(message, style: R.textStyles.font12R)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }

  static Widget closeButton({Function? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // makes the whole box tappable
      onTap: () {
        getContext().pop();
        if (onTap != null) {
          onTap();
        }
      },
      child: SizedBox(
        height: 48.h, // tappable area
        width: 48.w,
        child: Center(
          child: SvgPicture.asset(
            R.assets.iconCross,
            colorFilter: ColorFilter.mode(
              R.colors.hintColor.withValues(alpha: 0.6),
              BlendMode.srcIn,
            ),
            height: 15.h, // actual icon size
            width: 15.w,
          ),
        ),
      ),
    );
  }

  static void showSnackBar(String message, {Function()? onRetry}) async {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ).copyWith(right: 0),
      elevation: 5,
      backgroundColor: R.colors.fillColor,
      duration: Duration(seconds: 5),
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: R.textStyles.font14R,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onRetry == null
              ? IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(appContext()).removeCurrentSnackBar();
                },
                icon: Icon(Icons.close, size: 18.sp),
              )
              : GestureDetector(
                onTap: onRetry,
                child: Container(
                  height: 30.h,
                  width: 65.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: R.colors.secondaryColor,
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Icon(Icons.refresh, color: R.colors.white),
                ),
              ),
        ],
      ),
    );

    ScaffoldMessenger.of(appContext()).showSnackBar(snackBar);
  }

  static LinearGradient lightGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.alphaBlend(
          R.colors.white.withAlpha(204),
          R.colors.primaryLighterColor,
        ),
        Color.alphaBlend(R.colors.white.withAlpha(128), R.colors.primaryColor),
      ],
    );
  }

  static Widget getNetworkImage({
    required String endPoint,
    BoxFit? fit,
    double? width,
    double? height,
  }) {
    return CachedNetworkImage(
      imageUrl: endPoint,
      height: height,
      width: width,
      fit: fit,
      filterQuality: FilterQuality.high,

      placeholder:
          (context, url) => Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            color: R.colors.white,
            child: DecoratedBox(
              decoration: BoxDecoration(color: R.colors.whiteColor),
            ),
          ),
      errorWidget:
          (context, url, error) => Container(
            padding: EdgeInsets.all(5.w),
            color: R.colors.white,
            child: SvgPicture.asset(
              R.assets.appLogo,
              colorFilter: ColorFilter.mode(
                R.colors.lightGreyColor,
                BlendMode.srcIn,
              ),
              fit: BoxFit.scaleDown,
              width: width,
              height: height,
            ),
          ),
    );
  }

  static Widget getNetworkImageSvg({
    required String endPoint,
    BoxFit? fit,
    double? width,
    double? height,
    ColorFilter? colorFilter,
  }) {
    return CachedNetworkSVGImage(
      endPoint,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      colorFilter: colorFilter,
      placeholder: Container(
        alignment: Alignment.center,
        width: 10,
        height: 10,
        color: R.colors.white,
        child: CircularProgressIndicator(color: R.colors.primaryColor),
      ),
      errorWidget: Container(
        padding: EdgeInsets.all(5.w),
        color: R.colors.white,
        child: SvgPicture.asset(
          R.assets.appLogo,
          colorFilter: ColorFilter.mode(
            R.colors.lightGreyColor,
            BlendMode.srcIn,
          ),
          fit: BoxFit.scaleDown,
          width: width,
          height: height,
        ),
      ),
    );
  }

  static Future<void> successDialog({
    required BuildContext context,
    required String title,
    required String message,
    required void Function() onPressed,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 20.h,
            ).copyWith(top: 8.h),
            decoration: BoxDecoration(
              color: R.colors.white,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Utils.closeButton(onTap: onPressed),
                ),
                SvgPicture.asset(
                  R.assets.success,
                  width: 100.w,
                  height: 98.h,
                ),
                16.hBox,
                Text(
                  "$title !",
                  style: R.textStyles.font22B,
                ),
                15.hBox,
                Text(
                  message,
                  style: R.textStyles.font14M,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
