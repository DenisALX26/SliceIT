import 'package:flutter/foundation.dart';
import 'package:frontend/auth/token_store.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._tokens);

  final TokenStore _tokens;
  bool _isLoggedIn = false;

  bool getIsLoggedIn() => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final token = await _tokens.getAccess();
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> setLoggedIn(String accessToken) async {
    await _tokens.saveAccess(accessToken);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> setLoggedOut() async {
    await _tokens.deleteAccess();
    _isLoggedIn = false;
    notifyListeners();
  }
}