import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/config/app_strings.dart';

class TokenStore {
  const TokenStore();

  static const _kAccess = AppStrings.accessToken;
  static const _storage = FlutterSecureStorage();

  Future<void> saveAccess(String token) => _storage.write(key: _kAccess, value: token);

  Future<String?> getAccess() => _storage.read(key: _kAccess);

  Future<void> deleteAccess() => _storage.delete(key: _kAccess);
}