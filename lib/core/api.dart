import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tmdb/shared_pref_helper.dart';

final List<String> url = ['https://api.themoviedb.org/3/'];
const int isbeta = 0;

Map<String, dynamic> defaultHEADERS = {"Content-Type": "application/json", "accept": "application/json"};

class Api {
  final Dio _dio = Dio();

  Api() {
    _dio.options.baseUrl = url[isbeta];
    _dio.options.headers = defaultHEADERS;

    //add 3 tries if api failed
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.sendTimeout = Duration(seconds: 30);
    _dio.options.receiveDataWhenStatusError = true;
    _dio.options.headers = defaultHEADERS;

    // Interceptor to inject auth token before each request
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = SharedPreferencesHelper.getAccessToken();
          if (accessToken.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          return handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(requestBody: true, requestHeader: true, responseBody: true, responseHeader: true, compact: true),
    );
  }

  Dio get sendRequest => _dio;
}

class ApiResponse {
  bool success;
  dynamic data;
  int? code;
  String? message;

  ApiResponse({required this.success, this.data, this.code, this.message});

  factory ApiResponse.fromResponse(Response response) {
    try {
      final data = response.data;
      return ApiResponse(
        success: response.statusCode == 200 || response.statusCode == 201,
        code: response.statusCode,
        data: data,
        message: data is Map<String, dynamic> ? data["status_message"] : null,
      );
    } catch (e) {
      return ApiResponse(success: false, code: response.statusCode, message: "Failed to parse response");
    }
  }
}
