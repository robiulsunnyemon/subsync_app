import 'package:dio/dio.dart';
import 'package:subsync/app/core/constants/api_constants.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TODO: Add token to headers if available in local storage
        // String? token = await getAuthToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Handle global errors here (e.g., token expiration -> logout)
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return await dio.delete(path, data: data);
  }
}
