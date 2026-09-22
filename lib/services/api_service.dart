import 'package:dio/dio.dart';
import 'package:food_app/base/base_response.dart';
import 'package:food_app/configs/resources/resources.dart';
import 'package:food_app/configs/utils/singleton.dart';
import 'package:food_app/services/dio_client_service.dart';

class ApiService {
  static final ApiService _apiService = ApiService._();
  final Dio _api = DioClientService().getClient();
  CancelToken? _cancelToken;

  ApiService._();

  factory ApiService() => _apiService;

  static Future<void> Function()? onUnauthenticated;

  Future<BaseResponse> get(
    String endPoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    bool? addToken = true,
    bool? cancelPreviousRequests = false,
  }) async {
    try {
      if (cancelPreviousRequests == true) cancelAllRequests();
      _cancelToken = CancelToken();

      headers ??= Singleton.headerNoAuth;
      if (addToken == true) headers = Singleton.header;

      final response = await _api.request(
        endPoint,
        queryParameters: query,
        cancelToken: _cancelToken,
        options: Options(method: 'GET', headers: headers),
      );

      return BaseResponse.fromJson(response.data);
    } on Exception catch (ex) {
      return _handleException(ex);
    }
  }

  Future<BaseResponse> post(
    String endPoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Object? formData,
    bool? addToken = true,
    bool? cancelPreviousRequests = false,
    void Function(double progress)? onProgress,
  }) async {
    try {
      if (cancelPreviousRequests == true) cancelAllRequests();
      _cancelToken = CancelToken();

      headers ??= Singleton.headerNoAuth;
      if (addToken == true) headers = Singleton.header;

      final response = await _api.request(
        endPoint,
        data: body ?? formData,
        cancelToken: _cancelToken,
        options: Options(method: 'POST', headers: headers),
        onSendProgress: (sent, total) {
          if (onProgress != null && total != 0) onProgress(sent / total);
        },
      );

      return BaseResponse.fromJson(response.data);
    } on Exception catch (ex) {
      return _handleException(ex);
    }
  }

  Future<BaseResponse> put(
    String endPoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Object? formData,
    bool? addToken = true,
    bool? cancelPreviousRequests = false,
  }) async {
    try {
      if (cancelPreviousRequests == true) cancelAllRequests();
      _cancelToken = CancelToken();

      headers ??= Singleton.headerNoAuth;
      if (addToken == true) headers = Singleton.header;

      final response = await _api.request(
        endPoint,
        data: body ?? formData,
        cancelToken: _cancelToken,
        options: Options(method: 'PUT', headers: headers),
      );

      return BaseResponse.fromJson(response.data);
    } on Exception catch (ex) {
      return _handleException(ex);
    }
  }

  Future<BaseResponse> delete(
    String endPoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Object? formData,
    bool? addToken = true,
    bool? cancelPreviousRequests = false,
  }) async {
    try {
      if (cancelPreviousRequests == true) cancelAllRequests();
      _cancelToken = CancelToken();

      headers ??= Singleton.headerNoAuth;
      if (addToken == true) headers = Singleton.header;

      final response = await _api.request(
        endPoint,
        data: body ?? formData,
        cancelToken: _cancelToken,
        options: Options(method: 'DELETE', headers: headers),
      );

      return BaseResponse.fromJson(response.data);
    } on Exception catch (ex) {
      return _handleException(ex);
    }
  }

  /// Multipart upload. [files] maps a field name to a local file path.
  Future<BaseResponse> postFile(
    String endPoint, {
    Map<String, dynamic>? body,
    Map<String, String>? files,
    Map<String, dynamic>? headers,
    bool? addToken = true,
    void Function(double progress)? onProgress,
  }) async {
    try {
      _cancelToken = CancelToken();

      headers ??= Singleton.headerNoAuth;
      if (addToken == true) headers = Singleton.header;

      final form = FormData.fromMap({
        ...?body,
        for (final entry in (files ?? {}).entries)
          entry.key: await MultipartFile.fromFile(entry.value),
      });

      final response = await _api.request(
        endPoint,
        data: form,
        cancelToken: _cancelToken,
        options: Options(method: 'POST', headers: headers),
        onSendProgress: (sent, total) {
          if (onProgress != null && total != 0) onProgress(sent / total);
        },
      );

      return BaseResponse.fromJson(response.data);
    } on Exception catch (ex) {
      return _handleException(ex);
    }
  }

  Future<BaseResponse> _handleException(Exception ex) async {
    if (ex is DioException) {
      if (CancelToken.isCancel(ex)) {
        return BaseResponse(message: R.strings.requestCanceled, code: 501);
      }

      if (ex.type == DioExceptionType.connectionTimeout ||
          ex.type == DioExceptionType.connectionError ||
          ex.type == DioExceptionType.receiveTimeout) {
        return BaseResponse(message: R.strings.noInternet, code: 0);
      }

      if (ex.response?.statusCode == 302 || ex.response?.statusCode == 401) {
        final data = ex.response?.data;
        final message = (data is Map ? data['message'] : null)?.toString();

        if (message != null &&
            message.toLowerCase().contains('unauthenticated')) {
          await onUnauthenticated?.call();
        }

        return BaseResponse(
          message: message ?? R.strings.authenticationFailed,
          code: ex.response?.statusCode,
        );
      }

      if (ex.response?.data is Map) {
        return BaseResponse(
          message: ex.response?.data['message'],
          code: ex.response?.statusCode,
        );
      }

      return BaseResponse(
        message: ex.message ?? R.strings.error,
        code: ex.response?.statusCode,
      );
    }
    return BaseResponse(message: ex.toString(), code: 0);
  }

  void cancelAllRequests() {
    _cancelToken?.cancel("Previous requests canceled");
    _cancelToken = null;
  }
}
