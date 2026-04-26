import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

/// Interceptor que injeta o Bearer token em todas as requisições
/// e renova automaticamente quando recebe 401.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._storage, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }

        // Tenta renovar o token
        final response = await _dio.post(
          ApiConstants.renovar,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['dados']['accessToken'] as String?;
        final newRefreshToken = response.data['dados']['refreshToken'] as String?;

        if (newAccessToken != null) {
          await _storage.write(key: StorageKeys.accessToken, value: newAccessToken);
        }
        if (newRefreshToken != null) {
          await _storage.write(key: StorageKeys.refreshToken, value: newRefreshToken);
        }

        // Reenviar a requisição original com o novo token
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _dio.fetch(retryOptions);
        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (_) {
        // Refresh falhou — limpar tokens (usuário precisa fazer login novamente)
        await _storage.deleteAll();
        _isRefreshing = false;
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}

/// Provider do cliente Dio configurado
Dio buildDioClient(FlutterSecureStorage storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(storage, dio));

  return dio;
}
