import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import 'interceptors.dart';

class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._internal() {
    _dio = Dio();
    _setupDio();
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _setupDio() {
    // Base options
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.apiBaseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: ApiConstants.defaultHeaders,
      validateStatus: (status) {
        // Accept status codes from 200-299 and 304
        return status != null && status >= 200 && status < 300 || status == 304;
      },
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(), // Custom auth interceptor
      ErrorInterceptor(), // Custom error interceptor
      PrettyDioLogger( // Logger for debugging
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    ]);
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }
}
