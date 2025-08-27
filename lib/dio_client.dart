import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  static Dio get client => _client;
  static Dio _client = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      validateStatus: (status) => true,
    ),
  )..interceptors.add(authInterceptor);
  static AuthInterceptor authInterceptor = AuthInterceptor();
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = dotenv.env['TMDB_ACCESS_TOKEN'];

    if (apiKey == null || apiKey.isEmpty) {
      print('CRITICAL ERROR: TMDB_ACCESS_TOKEN not found in .env file');
    }
    options.headers.addAll({
      'Authorization': 'Bearer $apiKey',
      'accept': 'application/json',
    });
    return super.onRequest(options, handler);
  }
}
