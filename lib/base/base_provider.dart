import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_app/base/base_response.dart';
import 'package:food_app/configs/common_widgets/app_loader.dart';
import 'package:food_app/configs/utils/app_utils.dart';
import 'package:food_app/services/internet_service.dart';

import '../configs/resources/resources.dart';


class BaseProvider extends ChangeNotifier {
  final InternetService _internetService = InternetService();
  bool isLoading = false;

  Future<void> fetchData<RETURN>({
    required Future<BaseResponse> Function() remoteMethod,
    required Function(RETURN) onSuccess,
    Function(String, int)? onError,
    showLoader = true,
    hideLoaderOnSuccess = true,
    showError = true,
    notifyOnEnd = false,
  }) async
  {
    bool didShowLoader = false;
    try {
      if (showLoader && !isLoading) {
        isLoading = true;
        didShowLoader = true;
        AppLoader().showLoader();
        notifyListeners();
      }

      BaseResponse? response;

      //checking if internet is connected
      if (await _internetService.isInternetConnected()) {
        //call remote method
        response = await remoteMethod.call();
      } else {
        //simply return no internet snackBar
        var message = R.strings.noInternet;
        Utils.showSnackBar(
          message,
          onRetry: () => fetchData<RETURN>(
            remoteMethod: remoteMethod,
            onSuccess: onSuccess,
            onError: onError,
            showLoader: showLoader,
            hideLoaderOnSuccess: hideLoaderOnSuccess,
            showError: showError,
            notifyOnEnd: notifyOnEnd,
          ),
        );
        onError?.call(message, 0);
        response = null;
      }

      if (response != null) {
        if (response.code != 200 && response.code != 201) {
          var message = response.message ?? 'Unknown error';
          if (response.code == 301 || response.code == 401) {
            Utils.showSnackBar(
              message,
              onRetry: () => fetchData(
                remoteMethod: remoteMethod,
                onSuccess: onSuccess,
                onError: onError,
                showLoader: showLoader,
                hideLoaderOnSuccess: hideLoaderOnSuccess,
                showError: showError,
                notifyOnEnd: notifyOnEnd,
              ),
            );
          } else if(response.code == 501) {
            Utils.showSnackBar(
              message,
              onRetry: () => fetchData(
                remoteMethod: remoteMethod,
                onSuccess: onSuccess,
                onError: onError,
                showLoader: showLoader,
                hideLoaderOnSuccess: hideLoaderOnSuccess,
                showError: showError,
                notifyOnEnd: notifyOnEnd,
              ),
            );
          } else {
            if (showError) {
              Utils.showSnackBar(
                message,
                onRetry: () => fetchData(
                  remoteMethod: remoteMethod,
                  onSuccess: onSuccess,
                  onError: onError,
                  showLoader: showLoader,
                  hideLoaderOnSuccess: hideLoaderOnSuccess,
                  showError: showError,
                  notifyOnEnd: notifyOnEnd,
                ),
              );
            }
            onError?.call(message.toString(), response.code ?? 0);
          }
        } else {
          onSuccess(response.data as RETURN);
        }
      }

      if (showLoader && hideLoaderOnSuccess) {
        isLoading = false;
          notifyListeners();
      }

      if (notifyOnEnd) {
        Utils.showSnackBar(
          response?.message.toString() ?? '',
        );
        notifyListeners();
      }
    } catch (ex) {
      log(ex.toString());
      isLoading = false;
      notifyListeners();
      Utils.showSnackBar(
        ex.toString(),
        onRetry: () => fetchData(
          remoteMethod: remoteMethod,
          onSuccess: onSuccess,
          onError: onError,
          showLoader: showLoader,
          hideLoaderOnSuccess: hideLoaderOnSuccess,
          showError: showError,
          notifyOnEnd: notifyOnEnd,
        ),
      );
      onError?.call(ex.toString(), ex.hashCode);
    }finally{
      if (didShowLoader) {
        AppLoader().hideLoader();
        notifyListeners();
      }
    }
  }


}
