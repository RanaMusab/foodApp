import 'package:flutter/material.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/routes/app_routes.dart';

class AppLoader {
  static final AppLoader _instance = AppLoader._internal();

  AppLoader._internal();

  factory AppLoader() => _instance;

  bool _isLoadingShown = false;

  void showLoader() {
    if (_isLoadingShown) return;
    _isLoadingShown = true;
    showDialog(
      context: getContext(),
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: R.colors.transparent,
          elevation: 0,
          content: SizedBox(
            height: 80,
            width: 80,
            // Swap for `Lottie.asset(R.assets.loading)` once you add the asset.
            child: Center(
              child: CircularProgressIndicator(color: R.colors.primaryColor),
            ),
          ),
        ),
      ),
    ).then((_) => _isLoadingShown = false);
  }

  void hideLoader() {
    if (_isLoadingShown && (navigatorKey.currentContext?.mounted ?? false)) {
      Navigator.of(getContext(), rootNavigator: true).pop();
      _isLoadingShown = false;
    }
  }
}
