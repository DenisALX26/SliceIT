import 'package:dio/dio.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/app_strings.dart';

class AuthRepo {
  AuthRepo(this._dio);

  final Dio _dio;

  Future<String>login({required String email, required String password}) async {
    try {
      final res = await _dio.post(AppConfig.apiLogin, data: {
        AppStrings.emailTextForData: email,
        AppStrings.passwordTextForData: password,
      });
      final token = res.data[AppStrings.accessToken] as String?;
      if(token == null || token.isEmpty) {
        throw const AuthException(AppStrings.invalidTokenReceived);
      }
      return token;
    } on DioException catch (e) {
      if(e.response?.statusCode == 400 || e.response?.statusCode == 401) {
        throw const AuthException(AppStrings.invalidEmailOrPassword);
      }
      throw AuthException('${AppStrings.loginFailed}: ${e.message}');
    }
  }

  Future<bool> register({required String fullName, required String email, required String password}) async {
    try {
      final res = await _dio.post(AppConfig.apiRegister, data: {
        AppStrings.fullNameTextForData: fullName,
        AppStrings.emailTextForData: email,
        AppStrings.passwordTextForData:password,
      },
      );
      if(res.statusCode == 201) {
        return true;
      }
      final serverMsg = _safeErrorMessage(res.data);
      throw AuthException('${AppStrings.registrationFailed}${serverMsg !=null ? ': $serverMsg' : ''}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if(code == 409) {
        throw const AuthException(AppStrings.emailAlreadyInUse);
      }
      if(code == 400) {
        throw AuthException(AppStrings.invalidEmailOrPassword);
      }
      final serverMsg = _safeErrorMessage(e.response?.data);
      throw AuthException('${AppStrings.registrationError}${serverMsg !=null ? ': $serverMsg' : ''}');
    }
  }
}

String? _safeErrorMessage(dynamic data) {
  if (data is Map && data['error'] is String && (data['error'] as String).isNotEmpty) {
    return data['error'] as String;
  }
  if (data is Map && data['message'] is String && (data['message'] as String).isNotEmpty) {
    return data['message'] as String;
  }
  return null;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}