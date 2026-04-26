import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../data/models/user_model.dart';

part 'auth_provider.g.dart';

// ── Infra providers ──────────────────────────────────────────────────────────

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return buildDioClient(storage);
});

// ── Auth state ───────────────────────────────────────────────────────────────

/// Estado global do usuário autenticado.
/// null = não autenticado, UserModel = autenticado.
@riverpod
class AuthState extends _$AuthState {
  @override
  Future<UserModel?> build() async {
    return _carregarUsuario();
  }

  Future<UserModel?> _carregarUsuario() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);
    if (token == null) return null;

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(ApiConstants.me);
      final json = response.data['dados']['usuario'] as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Login com email e senha
  Future<void> loginComEmail(String email, String senha) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final storage = ref.read(secureStorageProvider);

      final response = await dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': senha},
      );

      await _salvarTokens(storage, response.data['dados']);
      return _carregarUsuario();
    });
  }

  /// Verificar código OTP (login por telefone)
  Future<void> loginComOtp(String phone, String code) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final storage = ref.read(secureStorageProvider);

      final response = await dio.post(
        ApiConstants.verificarCodigo,
        data: {'phone': phone, 'code': code},
      );

      await _salvarTokens(storage, response.data['dados']);
      return _carregarUsuario();
    });
  }

  /// Login com token do Google
  Future<void> loginComGoogle(String idToken) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final storage = ref.read(secureStorageProvider);

      final response = await dio.post(
        ApiConstants.google,
        data: {'idToken': idToken},
      );

      await _salvarTokens(storage, response.data['dados']);
      return _carregarUsuario();
    });
  }

  /// Login com token da Apple
  Future<void> loginComApple(String identityToken) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final storage = ref.read(secureStorageProvider);

      final response = await dio.post(
        ApiConstants.apple,
        data: {'identityToken': identityToken},
      );

      await _salvarTokens(storage, response.data['dados']);
      return _carregarUsuario();
    });
  }

  /// Logout
  Future<void> sair() async {
    try {
      final dio = ref.read(dioProvider);
      await dio.post(ApiConstants.sair);
    } catch (_) {
      // Ignora erro de rede no logout
    } finally {
      final storage = ref.read(secureStorageProvider);
      await storage.deleteAll();
      state = const AsyncData(null);
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _salvarTokens(
    FlutterSecureStorage storage,
    Map<String, dynamic> dados,
  ) async {
    final accessToken = dados['accessToken'] as String?;
    final refreshToken = dados['refreshToken'] as String?;
    if (accessToken != null) {
      await storage.write(key: StorageKeys.accessToken, value: accessToken);
    }
    if (refreshToken != null) {
      await storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    }
  }
}
