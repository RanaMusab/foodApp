import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
//Singleton class
class DioClientService {
  static final DioClientService _dioClientService = DioClientService._();
  Dio? _client;

  DioClientService._();

  factory DioClientService() {
    return _dioClientService;
  }

  Dio getClient() {
    if (_client == null) {
      _initializeDio();
    }
    return _client!;
  }

  void _initializeDio() {
    _client = Dio()
      ..options = BaseOptions(
        contentType: "application/json",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      )
      ..interceptors.add(InterceptorsWrapper(onError: _onError));

    if (kDebugMode) {
      _client?.interceptors.add(
        HttpFormatter(
          loggingFilter: (request, response, error) {
            // Log everything or customize the filter logic
            return true;
          },
        ),
      );
    }
  }

  void disposeClient() {
    _client?.close(force: true);
    _client = null;
  }

  void _onError(DioException e, ErrorInterceptorHandler handler) async {
    try {
      //handle this on error. Normally this mechanism is used for refresh token.
      handler.next(e);
    } on DioException catch (ex) {
      handler.next(ex);
    } on Exception catch (_) {
      handler.next(e);
    }
  }
}
