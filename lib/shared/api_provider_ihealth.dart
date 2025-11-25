import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/ihealth/login.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';

const appName = 'iHealth+';
const versionName = '0.0.1';
const versionNumber = 1;

//prod inet
const baseUrl = 'https://api-ihealth.spl-system.com/api/';

class ApiProviderIhealth {
  // 1. ทำให้เป็น Singleton และ private constructor
  ApiProviderIhealth._internal();
  static final ApiProviderIhealth _instance = ApiProviderIhealth._internal();
  factory ApiProviderIhealth() => _instance;

  late Dio _dio;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  bool _isInitialized = false;

  // 2. สร้าง init method สำหรับ Provider เอง
  Future<void> _init() async {
    if (_isInitialized) return;

    // Init DioService ก่อนเสมอ
    await DioService().init();
    _dio = DioService().dio;

    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 30);
    _dio.options.receiveTimeout = Duration(seconds: 30);
    _dio.options.headers['Accept'] = 'application/json'; 

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('--> ${options.method} ${options.uri}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          print('Data: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            '<-- ${response.statusCode} ${response.requestOptions.uri.path}');
        print('Response: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        print('Error Response: ${e.response?.data}');

        // หาก Token หมดอายุ (Unauthorized)
        if (e.response?.statusCode == 401) {
          await _storage.deleteAll();
          await DioService().clearCookies();

          // ใช้ GlobalKey เพื่อนนำทางไปยังหน้า Login
          final context = navigatorKey.currentContext;
          if (context != null && context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        }
        return handler.next(e);
      },
    ));

    _isInitialized = true;
    print("✅ ApiProviderIhealth Initialized");
  }

  // 3. สร้าง static method สำหรับการเข้าถึง instance ที่ init แล้ว
  static Future<ApiProviderIhealth> getInstance() async {
    await _instance._init();
    return _instance;
  }

  /// GET request
  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    await _init(); // ตรวจสอบว่า init แล้วหรือยัง
    return await _dio.get(path, queryParameters: queryParameters);
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) async {
    await _init(); // ตรวจสอบว่า init แล้วหรือยัง
    return await _dio.post(path, data: data);
  }

  /// PUT request
  Future<Response> put(String path, {dynamic data}) async {
    await _init(); // ตรวจสอบว่า init แล้วหรือยัง
    return await _dio.put(path, data: data);
  }

  /// DELETE request
  Future<Response> delete(String path, {dynamic data}) async {
    await _init(); // ตรวจสอบว่า init แล้วหรือยัง
    return await _dio.delete(path, data: data);
  }

  /// Upload file
  Future<Response> upload(String path, {required FormData formData}) async {
    await _init(); // ตรวจสอบว่า init แล้วหรือยัง
    return await _dio.post(
      path,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
