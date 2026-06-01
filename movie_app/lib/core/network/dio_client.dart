import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class DioClient {
  late final Dio _dio;
  late final CacheOptions _cacheOptions;

  DioClient() {
    _cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.forceCache,
      maxStale: const Duration(minutes: 30),
      priority: CachePriority.normal,
      allowPostMethod: false,
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.bearerToken}',
          'accept': 'application/json',
        },
      ),
    )
      ..interceptors.add(DioCacheInterceptor(options: _cacheOptions))
      ..interceptors.add(_ErrorInterceptor())
      ..interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        error: true,
      ));
  }

  Dio get dio => _dio;
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        final message = err.response?.data?['status_message'] ?? 'Server xətası';
        if (statusCode == 404) throw ServerException('Tapılmadı: $message');
        if (statusCode == 401) throw ServerException('İcazəsiz: API açarını yoxlayın');
        throw ServerException('$statusCode: $message');
      default:
        throw ServerException(err.message ?? 'Naməlum xəta');
    }
  }
}
