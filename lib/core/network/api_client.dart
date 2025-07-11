import 'package:dio/dio.dart';
import 'api_config.dart';

class ApiClient {
  final Dio dio;
  String? _token;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Accept': 'application/json'},
          ),
        ) {
    // Add interceptor to handle authentication
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('API Request: ${options.method} ${options.path}');
          print('Token: $_token');
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
            print('Authorization header set: Bearer $_token');
          } else {
            print('No token available');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          print('API Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  void setToken(String token) {
    print('Setting token: $token');
    _token = token;
  }

  void clearToken() {
    print('Clearing token');
    _token = null;
  }

  String? get token => _token;

  // HTTP Methods
  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, dynamic data) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
