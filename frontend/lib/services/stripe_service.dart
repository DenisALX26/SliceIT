import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:frontend/colors.dart';
import 'package:frontend/config/app_config.dart';

class StripeService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<void> makePayment(String jwtToken) async {
    try {
      final response = await _dio.post(
        '/api/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        final String? clientSecret = data['clientSecret'];

        if (clientSecret == null || clientSecret.isEmpty) {
          throw Exception('Client secret is missing in the response.');
        }

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'SliceIt',
            style: ThemeMode.system,
            appearance: const PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(primary: AppColors.myRed),
            ),
          ),
        );

        await _displayPaymentSheet();
      } else {
        throw Exception(
          'Unexpected response format from the server. Got: ${response.data}',
        );
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map
          ? e.response?.data['message']
          : (e.response?.data ?? "Network error");
      throw Exception(errorMessage);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      rethrow;
    }
  }

  static Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.localizedMessage}');
      throw Exception(e.error.localizedMessage);
    }
  }
}
