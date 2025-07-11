import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class AuthRepository {
  final ApiClient apiClient;
  AuthRepository(this.apiClient);

  Future<Response> login(String email, String password) {
    return apiClient.dio.post(
      'login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register(Map<String, dynamic> data) {
    return apiClient.dio.post('register', data: data);
  }

  Future<Response> logout(String token) {
    return apiClient.dio.post(
      'logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
