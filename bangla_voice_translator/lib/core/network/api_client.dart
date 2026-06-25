import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../constants/api_keys.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.openAiBaseUrl,
        connectTimeout:
            const Duration(seconds: AppConstants.connectionTimeout),
        receiveTimeout:
            const Duration(seconds: AppConstants.receiveTimeout),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.openAiApiKey}',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleRequest(() => _dio.get<T>(
          path,
          queryParameters: queryParameters,
        ));
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.post<T>(
          path,
          data: data,
          options: options,
        ));
  }

  Future<Response<T>> postFormData<T>(
    String path, {
    required FormData data,
  }) async {
    return _handleRequest(() => _dio.post<T>(
          path,
          data: data,
          options: Options(contentType: 'multipart/form-data'),
        ));
  }

  Future<Response<List<int>>> downloadBytes(
    String path, {
    dynamic data,
  }) async {
    return _handleRequest(() => _dio.post<List<int>>(
          path,
          data: data,
          options: Options(responseType: ResponseType.bytes),
        ));
  }

  Future<Response<T>> _handleRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['error']?['message']?.toString() ??
            e.message ??
            'Server error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
