// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:path_provider/path_provider.dart';

// class DioService {
//   static final DioService _instance = DioService._internal();
//   factory DioService() => _instance;

//   DioService._internal() {
//     _init();
//   }

//   late Dio _dio;
//   late PersistCookieJar _cookieJar;

//   Dio get dio => _dio;
//   PersistCookieJar get cookieJar => _cookieJar;

//   Future<void> _init() async {
//     final dir = await getApplicationDocumentsDirectory();
//     _cookieJar = PersistCookieJar(storage: FileStorage("${dir.path}/.cookies"));
//     _dio = Dio();
//     _dio.interceptors.add(CookieManager(_cookieJar));
//   }
// }

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class DioService {
  static final DioService _instance = DioService._internal();
  factory DioService() => _instance;

  DioService._internal();

  Dio? _dio;
  PersistCookieJar? _cookieJar;

  Dio get dio => _dio!;
  PersistCookieJar get cookieJar => _cookieJar!;

  bool _initialized = false;

  /// ต้องเรียกก่อนใช้งาน dio
  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();

    _cookieJar = PersistCookieJar(
      storage: FileStorage("${dir.path}/.cookies"),
    );

    _dio = Dio();
    _dio!.interceptors.add(CookieManager(_cookieJar!));

    _initialized = true;
  }

  /// ลบ cookie ตอน logout
  Future<void> clearCookies() async {
    await _cookieJar?.deleteAll();
  }
}
