import 'package:flutter/material.dart';
import 'package:food_app/routes/app_routes.dart';

BuildContext appContext() {
  final state = navigatorKey.currentState;
  if (state == null) {
    throw FlutterError('Navigator currentState is null. Ensure navigatorKey is properly attached.');
  }
  return state.context;
}

class CustomSizes {
  var viewPortWidth = 375;
  var viewPortHeight = 812;

  /// The ratio of actual width to UI design
  double get scaleWidth =>
      MediaQuery.of(navigatorKey.currentContext!).size.width / viewPortWidth;

  ///  /// The ratio of actual height to UI design
  double get scaleHeight => screenHeight / viewPortHeight;

  double get scaleText => scaleWidth;
  double get screenWidth =>
      MediaQuery.of(navigatorKey.currentContext!).size.width;

  ///The vertical extent of this size. dp
  double get screenHeight =>
      MediaQuery.of(navigatorKey.currentContext!).size.height;

  /// Adapted to the device width of the UI Design.
  /// Height can also be adapted according to this to ensure no deformation ,
  /// if you want a square
  double setWidth(num width) => width * scaleWidth;

  /// Highly adaptable to the device according to UI Design
  /// It is recommended to use this method to achieve a high degree of adaptation
  /// when it is found that one screen in the UI design
  /// does not match the current style effect, or if there is a difference in shape.
  double setHeight(num height) => height * scaleHeight;

  ///Font size adaptation method
  ///- [fontSize] The size of the font on the UI design, in dp.
  double setSp(num fontSize) => fontSize * scaleText;
}

extension SizeExtension on num {
  ///Multiple of screen width
  double get sw => CustomSizes().screenWidth * this;

  ///Multiple of screen height
  double get sh => CustomSizes().screenHeight * this;

  ///[CustomSizes.setWidth]
  double get w => CustomSizes().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => CustomSizes().setHeight(this);

  ///[ScreenUtil.setSp]
  double get sp => CustomSizes().setSp(this);

  /// Returns a SizedBox with a specified height
  SizedBox get hBox => SizedBox(height: CustomSizes().setHeight(this));

  /// Returns a SizedBox with a specified width
  SizedBox get wBox => SizedBox(width: CustomSizes().setWidth(this));
}
