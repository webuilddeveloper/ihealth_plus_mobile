import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:ihealth_2025_mobile/client/home_client.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/ihealth/menu.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/models/user.dart';
import 'package:ihealth_2025_mobile/ihealth/register.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/widget/text_field.dart';
import 'package:ihealth_2025_mobile/widget/text_form_field.dart';
import '../pages/auth/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/pages/login_phone.dart';
import 'package:ihealth_2025_mobile/shared/line.dart';
import '../shared/apple_firebase.dart';
import '../shared/facebook_firebase.dart';
import '../shared/google_firebase.dart';

DateTime now = new DateTime.now();
void main() {
  // Intl.defaultLocale = 'th';

  runApp(LoginPage(
    title: '',
  ));
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscureNotifier = ValueNotifier(true);

  // late String _username;
  // late String _password;
  // late String _facebookID;
  // late String _appleID;
  // late String _googleID;
  // late String _lineID;
  // late String _email;
  // late String _imageUrl;
  // late String _category;
  // late String _prefixName;
  // late String _firstName;
  // late String _lastName;

  late Map userProfile;
  // bool _isOnlyWebLogin = false;

  late DataUser dataUser;
  late Map<String, dynamic> profile;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      // _username = "";
      // _password = "";
      // _facebookID = "";
      // _appleID = "";
      // _googleID = "";
      // _lineID = "";
      // _email = "";
      // _imageUrl = "";
      // _category = "";
      // _prefixName = "";
      // _firstName = "";
      // _lastName = "";
    });
    // checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: AppColors.primary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () {
          // loginWithGuest();
          _signIn();
        },
        child: Text(
          'เข้าสู่ระบบ',
          style: new TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            child: Image.asset(
              'assets/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 40,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      "assets/logo/logo_main.png",
                      fit: BoxFit.contain,
                      height: 120.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontSize: 20.00,
                                  fontFamily: 'Sarabun',
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          labelTextField(
                            'ชื่อผู้ใช้งาน',
                            Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 20.00,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          ihealtTextFormField(
                            txtUsername,
                            'ชื่อผู้ใช้งาน',
                            true,
                            validator: emailValidator,
                          ),
                          SizedBox(height: 15.0),
                          labelTextField(
                            'รหัสผ่าน',
                            Icon(
                              Icons.lock,
                              color: AppColors.primary,
                              size: 20.00,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          ihealtTextFormField(
                            txtPassword,
                            'รหัสผ่าน',
                            true,
                            validator: passwordValidator,
                            obscureText: obscureNotifier.value,
                            suffixIcon: ValueListenableBuilder<bool>(
                              valueListenable: obscureNotifier,
                              builder: (context, value, child) {
                                return IconButton(
                                  icon: Icon(
                                    value
                                        ? Icons.visibility_off_rounded
                                        : Icons.remove_red_eye_rounded,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscureNotifier.value = !value;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          loginButton,
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "ลืมรหัสผ่าน",
                                  style: TextStyle(
                                    fontSize: 12.00,
                                    fontFamily: 'Sarabun',
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: AppColors.primary_gold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "สมัครสมาชิก",
                                  style: TextStyle(
                                    fontSize: 12.00,
                                    fontFamily: 'Sarabun',
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     Text(
                          //       ' หรือเข้าสู่ระบบโดย ',
                          //       style: TextStyle(
                          //         fontSize: 14.00,
                          //         fontFamily: 'Sarabun',
                          //         color: AppColors.primary_gold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 8.0,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     if (Platform.isIOS)
                          //       Container(
                          //         alignment: FractionalOffset(0.5, 0.5),
                          //         height: 50.0,
                          //         width: 50.0,
                          //         child: IconButton(
                          //           onPressed: () async {
                          //             _loginApple();
                          //           },
                          //           icon: Image.asset(
                          //             "assets/logo/socials/apple.png",
                          //           ),
                          //           padding: EdgeInsets.all(5.0),
                          //         ),
                          //       ),
                          //     Container(
                          //       alignment: FractionalOffset(0.5, 0.5),
                          //       height: 50.0,
                          //       width: 50.0,
                          //       child: IconButton(
                          //         onPressed: () async {
                          //           _loginFacebook();
                          //         },
                          //         icon: Image.asset(
                          //           "assets/logo/socials/Group379.png",
                          //         ),
                          //         padding: EdgeInsets.all(5.0),
                          //       ),
                          //     ),
                          //     Container(
                          //       alignment: FractionalOffset(0.5, 0.5),
                          //       height: 50.0,
                          //       width: 50.0,
                          //       child: IconButton(
                          //         onPressed: () async {
                          //           _loginGoogle();
                          //         },
                          //         icon: Image.asset(
                          //           "assets/logo/socials/Group380.png",
                          //         ),
                          //         padding: EdgeInsets.all(5.0),
                          //       ),
                          //     ),
                          //     Container(
                          //       alignment: FractionalOffset(0.5, 0.5),
                          //       height: 50.0,
                          //       width: 50.0,
                          //       child: IconButton(
                          //         onPressed: () async {
                          //           var obj = await loginLine();
                          //           final idToken = obj.accessToken.idToken;
                          //           final userEmail = (idToken != null)
                          //               ? idToken['email'] != null
                          //                   ? idToken['email']
                          //                   : ''
                          //               : '';
                          //           var model = {
                          //             "username": userEmail == ''
                          //                 ? obj.userProfile?.userId
                          //                 : userEmail,
                          //             "email": userEmail,
                          //             "imageUrl": obj.userProfile?.pictureUrl,
                          //             "firstName": obj.userProfile?.displayName,
                          //             "lastName": '',
                          //             "lineID": obj.userProfile?.userId
                          //           };
                          //           Dio dio = Dio();
                          //           var response = await dio.post(
                          //             '${server}m/v2/register/line/login',
                          //             data: model,
                          //           );
                          //           createStorageApp(
                          //             model: response.data['objectData'],
                          //             category: 'line',
                          //           );
                          //           Navigator.pushReplacement(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) => Menu(
                          //                 pageIndex: null,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //         icon: Image.asset(
                          //           "assets/logo/socials/Group381.png",
                          //         ),
                          //         padding: EdgeInsets.all(5.0),
                          //       ),
                          //     ),
                          //     Container(
                          //       alignment: FractionalOffset(0.5, 0.5),
                          //       height: 50.0,
                          //       width: 50.0,
                          //       child: IconButton(
                          //         onPressed: () async {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       LoginPhone()));
                          //         },
                          //         icon: Image.asset(
                          //           "assets/logo/phone.png",
                          //         ),
                          //         padding: EdgeInsets.all(5.0),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        var headers = {'Content-Type': 'application/json'};
        var dio = Dio();
        var response = await dio.post(
          'http://110.78.211.156:3001/api/v1/signin',
          options: Options(headers: headers),
          data: json.encode({
            "username": txtUsername.text,
            "password": txtPassword.text,
          }),
        );
        if (response.statusCode == 200) {
          var token = response.data["token"];
          var info_id = response.data['info_id'];

          if (token != null && token is String && token.isNotEmpty) {
            storage.write(key: 'token', value: token);

            await _readProfile(token: token, info_id: info_id);
            print('---------------- Start LogIn ------------------');

            if (profile['affiliation_id'] == 2) {
              print('---------------masseuse-------------------');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => Menu(
                          modelprofile: profile,
                        )),
                (Route<dynamic> route) => false,
              );
            } else if (profile['affiliation_id'] == 6) {
              print('---------------Client-------------------');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeClient(),
                ),
              );
            }
          } else {
            // token เป็น null หรือว่าง -> รหัสผ่านผิด
            print("❌ SignIn Failed: Invalid credentials");
            showErrorDialog(
              context: context,
              title: "แจ้งเตือน",
              message: "Username หรือ Password \nของคุณไม่ถูกต้อง",
              barrierDismissible: true,
            );
          }
        } else {
          print("❌ SignIn Failed: ${response.statusMessage}");
        }
      } catch (e) {
        print("❌ Error in SignIn: $e");
      }
    }
  }

  _readProfile({
    required String token,
    required String info_id,
  }) async {
    var headers = {'Authorization': 'Bearer $token'};
    var dio = Dio();
    var response = await dio.request(
      'http://110.78.211.156:3001/api/v1/user/$info_id',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        profile = response.data['data'];
      });

      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = "ตกลง",
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Sarabun',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: message != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Sarabun',
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                child: Text(
                  confirmText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Sarabun',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void checkStatus() async {
  //   final storage = new FlutterSecureStorage();
  //   String? value = await storage.read(key: 'dataUserLoginDDPM');
  //   if (value != null && value != '') {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => Menu(
  //           pageIndex: null,
  //         ),
  //       ),
  //       (Route<dynamic> route) => false,
  //     );
  //   }
  // }

  // //login username / password
  // Future<dynamic> login() async {
  //   if ((_username == '') && _category == 'guest') {
  //     return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => new CupertinoAlertDialog(
  //         title: new Text(
  //           'กรุณากรอกชื่อผู้ใช้',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontFamily: 'Sarabun',
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         content: Text(" "),
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: new Text(
  //               "ตกลง",
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontFamily: 'Sarabun',
  //                 color: Color(0xFF000070),
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if ((_password == '') && _category == 'guest') {
  //     return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => new CupertinoAlertDialog(
  //         title: new Text(
  //           'กรุณากรอกรหัสผ่าน',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontFamily: 'Sarabun',
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         content: Text(" "),
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: new Text(
  //               "ตกลง",
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontFamily: 'Sarabun',
  //                 color: Color(0xFF000070),
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     String url = _category == 'guest'
  //         ? 'm/Register/login'
  //         : 'm/Register/${_category}/login';

  //     final result = await postLoginRegister(url, {
  //       'username': _username.toString(),
  //       'password': _password.toString(),
  //       'category': _category.toString(),
  //       'email': _email.toString(),
  //     });

  //     if (result.status == 'S' || result.status == 's') {
  //       await storage.write(
  //           key: 'dataUserLoginDDPM', value: jsonEncode(result.objectData));
  //       storage.write(key: 'profileCode3', value: result.objectData?.code);
  //       storage.write(key: 'username', value: result.objectData?.username);
  //       storage.write(
  //           key: 'profileImageUrl', value: result.objectData?.imageUrl);

  //       storage.write(key: 'idcard', value: result.objectData?.idcard);

  //       storage.write(key: 'profileCategory', value: 'guest');
  //       storage.write(
  //           key: 'profileFirstName', value: result.objectData?.firstName);
  //       storage.write(
  //           key: 'profileLastName', value: result.objectData?.lastName);

  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //           builder: (context) => Menu(
  //             pageIndex: null,
  //           ),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //     } else {
  //       if (_category == 'guest') {
  //         return showDialog(
  //           barrierDismissible: false,
  //           context: context,
  //           builder: (BuildContext context) => new CupertinoAlertDialog(
  //             title: new Text(
  //               result.message,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontFamily: 'Sarabun',
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             content: Text(" "),
  //             actions: [
  //               CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 child: new Text(
  //                   "ตกลง",
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     fontFamily: 'Sarabun',
  //                     color: Color(0xFF000070),
  //                     fontWeight: FontWeight.normal,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       } else {
  //         register();
  //       }
  //     }
  //   }
  // }

  // Future<dynamic> register() async {
  //   final result = await postLoginRegister('m/Register/create', {
  //     'username': _username,
  //     'password': _password,
  //     'category': _category,
  //     'email': _email,
  //     'facebookID': _facebookID,
  //     'appleID': _appleID,
  //     'googleID': _googleID,
  //     'lineID': _lineID,
  //     'imageUrl': _imageUrl,
  //     'prefixName': _prefixName,
  //     'firstName': _firstName,
  //     'lastName': _lastName,
  //     'status': "N",
  //     'platform': Platform.operatingSystem.toString(),
  //     'birthDay': "",
  //     'phone': "",
  //     'countUnit': "[]"
  //   });
  //   if (result.status == 'S') {
  //     await storage.write(
  //       key: 'dataUserLoginDDPM',
  //       value: jsonEncode(result.objectData),
  //     );
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (context) => Menu(
  //           pageIndex: null,
  //         ),
  //       ),
  //       (Route<dynamic> route) => false,
  //     );
  //   } else {
  //     return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => new CupertinoAlertDialog(
  //         title: new Text(
  //           result.message,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontFamily: 'Sarabun',
  //             color: Colors.black,
  //             fontWeight: FontWeight.normal,
  //           ),
  //         ),
  //         content: Text(" "),
  //         actions: [
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: new Text(
  //               "ตกลง",
  //               style: TextStyle(
  //                 fontSize: 13,
  //                 fontFamily: 'Sarabun',
  //                 color: Color(0xFF000070),
  //                 fontWeight: FontWeight.normal,
  //               ),
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // //login guest
  // void loginWithGuest() async {
  //   setState(() {
  //     _category = 'guest';
  //     _username = txtUsername.text;
  //     _password = txtPassword.text;
  //     _facebookID = "";
  //     _appleID = "";
  //     _googleID = "";
  //     _lineID = "";
  //     _email = "";
  //     _imageUrl = "";
  //     _prefixName = "";
  //     _firstName = "";
  //     _lastName = "";
  //   });
  //   login();
  // }

  // TextStyle style = TextStyle(
  //   fontFamily: 'Sarabun',
  //   fontSize: 18.0,
  // );

  // _loginApple() async {
  //   var obj = await signInWithApple();

  //   // print(
  //   //     '----- email ----- ${obj.credential}');
  //   // print(obj.credential.identityToken[4]);
  //   // print(obj.credential.identityToken[8]);

  //   var model = {
  //     "username": obj.user?.email != null ? obj.user?.email : obj.user?.uid,
  //     "email": obj.user?.email != null ? obj.user!.email : '',
  //     "imageUrl": '',
  //     "firstName": obj.user?.email,
  //     "lastName": '',
  //     "appleID": obj.user?.uid
  //   };

  //   Dio dio = new Dio();
  //   var response = await dio.post(
  //     '${server}m/v2/register/apple/login',
  //     data: model,
  //   );

  //   // print(
  //   //     '----- code ----- ${response.data['objectData']['code']}');

  //   createStorageApp(
  //     model: response.data['objectData'],
  //     category: 'apple',
  //   );

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       // builder: (context) =>
  //       //     PermissionRegisterPage(),
  //       builder: (context) => Menu(
  //         pageIndex: null,
  //       ),
  //     ),
  //   );
  // }

  // _loginFacebook() async {
  //   var obj = await signInWithFacebook();
  //   print('----- Login Facebook ----- ' + obj.toString());
  //   if (obj != null) {
  //     var model = {
  //       "username": obj.user?.email,
  //       "email": obj.user?.email,
  //       "imageUrl": obj.user?.photoURL != null ? obj.user?.photoURL : '',
  //       "firstName": obj.user?.displayName,
  //       "lastName": '',
  //       "facebookID": obj.user?.uid
  //     };

  //     Dio dio = new Dio();
  //     var response = await dio.post(
  //       '${server}m/v2/register/facebook/login',
  //       data: model,
  //     );

  //     await storage.write(key: 'categorySocial', value: 'Facebook');
  //     await storage.write(
  //       key: 'imageUrlSocial',
  //       value: obj.user?.photoURL != null ? obj.user?.photoURL : '',
  //     );

  //     createStorageApp(
  //       model: response.data['objectData'],
  //       category: 'facebook',
  //     );

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Menu(
  //           pageIndex: null,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // _loginGoogle() async {
  //   var obj = await signInWithGoogle();
  //   // print('----- Login Google ----- ' + obj.toString());
  //   var model = {
  //     "username": obj.user?.email,
  //     "email": obj.user?.email,
  //     "imageUrl": obj.user?.photoURL != null ? obj.user?.photoURL : '',
  //     "firstName": obj.user?.displayName,
  //     "lastName": '',
  //     "googleID": obj.user?.uid
  //   };

  //   Dio dio = new Dio();
  //   var response = await dio.post(
  //     '${server}m/v2/register/google/login',
  //     data: model,
  //   );

  //   await storage.write(
  //     key: 'categorySocial',
  //     value: 'Google',
  //   );

  //   await storage.write(
  //     key: 'imageUrlSocial',
  //     value: obj.user?.photoURL != null ? obj.user?.photoURL : '',
  //   );

  //   createStorageApp(
  //     model: response.data['objectData'],
  //     category: 'google',
  //   );

  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Menu(
  //         pageIndex: null,
  //       ),
  //     ),
  //   );
  // }
}
