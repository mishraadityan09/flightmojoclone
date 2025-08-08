abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  const ServerException(String message) : super(message);
}

class TimeoutException extends AppException {
  const TimeoutException(String message) : super(message);
}

class BadRequestException extends AppException {
  const BadRequestException(String message) : super(message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(String message) : super(message);
}

class NotFoundException extends AppException {
  const NotFoundException(String message) : super(message);
}

class CancelException extends AppException {
  const CancelException(String message) : super(message);
}
