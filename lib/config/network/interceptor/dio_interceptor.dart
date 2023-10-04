import 'dart:developer';

import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final keyValueStorageService = KeyValueStorageServiceImpl();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    log("Request[${options.method}] => PATH: ${options.path}");
    final token = await keyValueStorageService.getValue<String>('token');
    if (token != null) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("Response Status Code: [${response.statusCode}]");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("Error[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    super.onError(err, handler);
  }
}
