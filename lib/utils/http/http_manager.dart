import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'interceptors.dart';

final baseUrl = dotenv.env['GCI_API']??'';
final baseUrlPlanok = dotenv.env['PLANOK_API']??'';
final baseUrlPvi = dotenv.env['PVI_API']??'';

class HttpManager {

  static final HttpManager _instance = HttpManager._internal();

  HttpManager._internal();

  static HttpManager get instance => _instance;

  static final BaseOptions _defaultOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 60000,
    receiveTimeout: 120000,
    contentType: "application/json",
  );
  static final BaseOptions _planokOptions = BaseOptions(
    baseUrl: baseUrlPlanok,
    connectTimeout: 600000,
    receiveTimeout: 1200000,
    contentType: "application/json",
  );

  static final BaseOptions _pvikOptions = BaseOptions(
    baseUrl: baseUrlPvi,
    connectTimeout: 600000,
    receiveTimeout: 1200000,
    contentType: "application/json",
  );

  final Dio _dio = Dio(_defaultOptions);
  final Dio _dioPlanok = Dio(_planokOptions);
  final Dio _dioPvi = Dio(_pvikOptions);

  Dio get init => _dio;

  Dio get initRetryConnection =>
      _dio..interceptors.add(RetryOnConnectionChangeInterceptor());

  Dio get withToken => _dio
    ..interceptors.add(
      TokenInterceptors(),
    );
  Dio get withTokenPlanok => _dioPlanok
    ..interceptors.add(
      TokenInterceptors(),
    );
  Dio get withTokenPvi => _dioPvi
    ..interceptors.add(
      TokenInterceptors(),
    );

}
