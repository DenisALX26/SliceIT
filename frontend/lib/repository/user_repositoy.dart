import 'package:dio/dio.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/model/user.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<User> getMe() async {
    final response = await _dio
        .get(AppConfig.apiMe)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw Exception('Failed to load user data');
    }
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}
