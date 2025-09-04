import 'package:dio/dio.dart';
import 'package:frontend/config/app_strings.dart';

Dio buildDio(String baseUrl) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        AppStrings.contentType: AppStrings.applicationJson,
      }
    ),
  );
}