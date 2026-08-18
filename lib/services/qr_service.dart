class QrService {
  static const prefix = 'WKCLIENT:';
  String generate(String customerId) {
    if (customerId.trim().isEmpty || customerId.contains(':')) throw ArgumentError('ID de cliente inválido.');
    return '$prefix$customerId';
  }
  String? parse(String payload) {
    if (!payload.startsWith(prefix)) return null;
    final id = payload.substring(prefix.length);
    return id.isEmpty || id.contains(':') ? null : id;
  }
}
