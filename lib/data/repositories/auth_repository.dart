import '../../core/env.dart';
import '../../services/api_client.dart';
import '../../services/local_storage_service.dart';
import '../models/user.dart';

class AuthRepository {
  AuthRepository({
    required LocalStorageService localStorage,
  }) : _apiClient = ApiClient(
          baseUrl: Env.apiBaseUrl,
          localStorage: localStorage,
        );

  final ApiClient _apiClient;

  /// Sends user info from Google/Firebase to backend to create/update user in MongoDB.
  /// [userInfo] should contain: firebaseUid, name, email, photoUrl?, phoneNumber?, emailVerified?, googleId?.
  Future<UserModel> loginWithGoogleUserInfo(
    Map<String, dynamic> userInfo,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/google-login',
      data: userInfo,
    );

    final data = response.data ?? <String, dynamic>{};
    final token = data['token']?.toString();
    final userJson = data['user'] as Map<String, dynamic>? ?? {};

    if (token == null || token.isEmpty) {
      throw Exception('Invalid auth response from server');
    }

    await _apiClient.localStorage.setAuthToken(token);

    return UserModel.fromJson(userJson);
  }
}

