class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  @override
  String toString() => message;
}

class NetworkException implements Exception {
  const NetworkException();
  @override
  String toString() => 'Şəbəkə bağlantısı yoxdur';
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Lokal xəta baş verdi']);
  @override
  String toString() => message;
}
