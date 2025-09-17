class AppConfig {
  static const baseUrl = "http://10.0.2.2:8080";
  static const apiAuth = "$baseUrl/api/auth";
  static const apiLogin = "$apiAuth/login";
  static const apiRegister = "$apiAuth/register";
  static const apiPizzas = "$baseUrl/api/pizza";
  static const apiMe = "$baseUrl/api/me";
  static const cart = "$baseUrl/api/cart";
  static const items = "$baseUrl/api/cart/items";
}
