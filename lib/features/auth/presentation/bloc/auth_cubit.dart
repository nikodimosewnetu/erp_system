import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/injector.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  final ApiClient apiClient;

  AuthCubit(this.authRepository)
      : apiClient = sl<ApiClient>(),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(email, password);
      final token = response.data['token'];
      final user = response.data['user'];

      // Set the token in the API client for future requests
      apiClient.setToken(token);

      emit(AuthSuccess(user, token));
    } catch (e) {
      String message = 'Login failed';
      if (e is DioError && e.response != null) {
        message = e.response?.data['message'] ?? message;
      }
      emit(AuthFailure(message));
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(data);
      final token = response.data['token'];
      final user = response.data['user'];

      // Set the token in the API client for future requests
      apiClient.setToken(token);

      emit(AuthSuccess(user, token));
    } catch (e) {
      String message = 'Registration failed';
      if (e is DioError && e.response != null) {
        message = e.response?.data['message'] ?? message;
      }
      emit(AuthFailure(message));
    }
  }

  Future<void> logout(String token) async {
    emit(AuthLoading());
    try {
      await authRepository.logout(token);
      // Clear the token from the API client
      apiClient.clearToken();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure('Logout failed'));
    }
  }
}
