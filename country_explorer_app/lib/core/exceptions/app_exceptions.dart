class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Şəbəkə xətası baş verdi.']);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server xətası baş verdi.']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Yaddaş xətası baş verdi.']);

  @override
  String toString() => message;
}
