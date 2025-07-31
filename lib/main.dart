import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:ihealth_2025_mobile/splash.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

import 'shared/api_provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  LineSDK.instance.setup('2006508203').then((_) {
    print('LineSDK Prepared');
  });

  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF224B45),
        fontFamily: 'Sarabun',
      ),
      title: appName,
      home: SplashPage(),
      builder: (context, child) {
        return MediaQuery(
          child: child ?? SizedBox.shrink(),
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
        );
      },
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
