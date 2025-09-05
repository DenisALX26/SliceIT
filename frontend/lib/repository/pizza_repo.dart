import 'package:dio/dio.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/app_strings.dart';
import '/model/pizza.dart';

class PizzaRepo {
  final Dio _dio;

  PizzaRepo(this._dio);

  Future<List<Pizza>> getAllPizzas() async {
    try {
      final res = await _dio.get(AppConfig.apiPizzas);
      if(res.statusCode == 200 && res.data is List) {
        final list = (res.data as List).map((e) => Pizza.fromJson(e as Map<String, dynamic>)).toList();
        return list;
      }
      throw Exception(AppStrings.pizzaNotFound);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final body =e.response?.data;
      final msg = (body is Map && body['error'] is String) ? body['error'] as String : e.message ?? AppStrings.requestFailed;
      throw Exception('$code: $msg');
    }
  }
}