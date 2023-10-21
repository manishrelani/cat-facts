import 'package:dio/dio.dart';

import '../../core/config/exeption/exeption.dart';

class DioInterceptor extends Interceptor {
  DioInterceptor() : super();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          default:
            throw InternalServerErrorException(err.requestOptions);
        }

      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionError:
        throw NoInternetException(err.requestOptions);
      default:
        throw InternalServerErrorException(err.requestOptions);
    }

    return handler.next(err);
  }
}
