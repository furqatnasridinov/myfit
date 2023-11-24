import 'dart:io';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class HttpService {
  Dio clientDio() {
    Dio dio = Dio();
    dio.options.baseUrl = AppConstants.baseUrl;
    dio.options.headers['Content-Type'] = "application/json";
    dio.options.sendTimeout = const Duration(seconds: 60);
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.options.headers["Authorization"] = "Bearer ${LocalStorage.getToken()}";
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
    return dio;
  }
}
