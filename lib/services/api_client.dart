import 'dart:async';

import 'package:dio/dio.dart';

import 'local_storage_service.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({
    required String baseUrl,
    required LocalStorageService localStorage,
  })  : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
        _localStorage = localStorage {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = _localStorage.authToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final LocalStorageService _localStorage;

  LocalStorageService get localStorage => _localStorage;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('Full URL: ${_dio.options.baseUrl + path}');
      print('GET request to $path with query parameters: $queryParameters');
      print('Authorization: ${_localStorage.authToken}');
      print('Headers: ${_dio.options.headers}');
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print('Full URL: ${_dio.options.baseUrl + path}');
      print('POST request to $path with data: $data');
      print('Query parameters: $queryParameters');
      print('Authorization: ${_localStorage.authToken}');
      print('Headers: ${_dio.options.headers}');
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    final status = e.response?.statusCode;
    final message = e.response?.data is Map
        ? (e.response?.data['message']?.toString() ?? 'Unexpected server error')
        : e.message ?? 'Network error';
    return ApiException(message, statusCode: status);
  }
}

