import '../../core/env.dart';
import '../../services/api_client.dart';
import '../../services/local_storage_service.dart';

class AudienceCategory {
  AudienceCategory({required this.id, required this.name});
  final String id;
  final String name;

  factory AudienceCategory.fromJson(Map<String, dynamic> json) {
    return AudienceCategory(
      id: json['id']?.toString() ?? json['name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class AudienceUser {
  AudienceUser({
    required this.id,
    required this.name,
    this.designation,
    this.companyName,
    this.industry,
    this.city,
    this.state,
    this.country,
    this.profileCompletion = 0,
    this.photoUrl,
  });
  final String id;
  final String name;
  final String? designation;
  final String? companyName;
  final String? industry;
  final String? city;
  final String? state;
  final String? country;
  final double profileCompletion;
  final String? photoUrl;

  factory AudienceUser.fromJson(Map<String, dynamic> json) {
    return AudienceUser(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      designation: json['designation']?.toString(),
      companyName: json['companyName']?.toString(),
      industry: json['industry']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      profileCompletion: (json['profileCompletion'] as num?)?.toDouble() ?? 0,
      photoUrl: json['photoUrl']?.toString(),
    );
  }
}

class AudienceRepository {
  AudienceRepository({
    required LocalStorageService localStorage,
  }) : _apiClient = ApiClient(
          baseUrl: Env.apiBaseUrl,
          localStorage: localStorage,
        );

  final ApiClient _apiClient;

  /// type: job | business | student
  Future<List<AudienceCategory>> getCategories(String type) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/audience/categories',
      queryParameters: {'type': type},
    );
    final data = response.data ?? {};
    final list = data['categories'] as List? ?? [];
    return list
        .map((e) => AudienceCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// type: job | business | student, category: industry or field name
  Future<List<AudienceUser>> getUsersByCategory(String type, String category) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/audience/users',
      queryParameters: {'type': type, 'category': category},
    );
    final data = response.data ?? {};
    final list = data['users'] as List? ?? [];
    return list
        .map((e) => AudienceUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getUserDetail(String userId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/audience/user/$userId',
    );
    final data = response.data ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};
    user['canSeeSensitive'] = data['canSeeSensitive'] as bool? ?? false;
    return user;
  }
}
