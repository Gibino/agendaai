/// URL base da API
class ApiConstants {
  ApiConstants._();

  // Altere para o endereço real do seu servidor em produção
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator → localhost
  // static const String baseUrl = 'http://localhost:3000/api/v1'; // iOS Simulator

  // Auth
  static const String registrar = '/auth/registrar';
  static const String login = '/auth/login';
  static const String renovar = '/auth/renovar';
  static const String sair = '/auth/sair';
  static const String me = '/auth/me';
  static const String google = '/auth/google';
  static const String apple = '/auth/apple';
  static const String enviarCodigo = '/auth/telefone/enviar-codigo';
  static const String verificarCodigo = '/auth/telefone/verificar';

  // Recursos públicos
  static const String empresas = '/empresas';
  static const String categorias = '/categorias';
  static const String banners = '/banners';
  static const String promocoes = '/promocoes';
}

/// Chaves para flutter_secure_storage
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
}
