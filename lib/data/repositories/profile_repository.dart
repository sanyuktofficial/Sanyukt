import '../../core/env.dart';
import '../../services/api_client.dart';
import '../../services/local_storage_service.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  ProfileRepository({
    required LocalStorageService localStorage,
  }) : _apiClient = ApiClient(
          baseUrl: Env.apiBaseUrl,
          localStorage: localStorage,
        );

  final ApiClient _apiClient;

  Future<ProfileModel> getProfile() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/user/profile');
    final data = response.data ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};
    return ProfileModel.fromJson(user);
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> body) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      '/user/profile/update',
      data: body,
    );
    final data = response.data ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};
    return ProfileModel.fromJson(user);
  }

  /// Fetches all dropdown options for profile form (blood group, jain sect, etc.)
  Future<Map<String, List<String>>> getProfileOptions() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/user/profile/options');
    final data = response.data ?? {};
    final options = data['options'] as Map<String, dynamic>? ?? {};
    final result = <String, List<String>>{};
    for (final e in options.entries) {
      if (e.value is List) {
        result[e.key] = (e.value as List).map((x) => x.toString()).toList();
      }
    }
    return result;
  }
}
