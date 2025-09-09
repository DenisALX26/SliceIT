import 'package:dio/dio.dart';
import 'package:frontend/config/app_strings.dart';
import 'package:frontend/auth/token_store.dart';

Dio buildDio(String baseUrl, TokenStore tokens) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {AppStrings.contentType: AppStrings.applicationJson},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await tokens.getAccess();
        if (access != null && access.isNotEmpty) {
          options.headers[AppStrings.authorization] =
              '${AppStrings.bearer} $access';
        }
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  );
  return dio;
}
