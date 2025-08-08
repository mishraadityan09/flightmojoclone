import 'dart:async';

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

// Auth Interceptor - adds auth token to every request
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth code to query parameters for every request
    options.queryParameters[ApiConstants.authCodeKey] = ApiConstants.authCode;
    
    // You can also add headers if needed
    // options.headers['Authorization'] = 'Bearer ${ApiConstants.authCode}';
    
    super.onRequest(options, handler);
  }
}

// Error Interceptor - handles common errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw TimeoutException('Connection timeout occurred');
      
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException('Bad request');
          case 401:
            throw UnauthorizedException('Unauthorized access');
          case 404:
            throw NotFoundException('Resource not found');
          case 500:
            throw ServerException('Internal server error');
          default:
            throw ServerException('Something went wrong');
        }
      
      case DioExceptionType.cancel:
        throw CancelException('Request was cancelled');
      
      case DioExceptionType.unknown:
        throw NetworkException('Network error occurred');
      
      default:
        throw NetworkException('Unexpected error occurred');
    }
  }
}
