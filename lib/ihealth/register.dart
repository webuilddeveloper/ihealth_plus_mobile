// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/widget/text_form_field.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String selectType = '1';
  final txtLicenseNumber = TextEditingController();
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  @override
  void dispose() {
    txtLicenseNumber.dispose();
    txtName.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future dialogSuccess() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'ลงทะเบียนเรียบร้อยแล้ว',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: AppColors.primary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    goBack();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        var headers = {'Content-Type': 'application/json'};
        var data = json.encode({
          // "license_number": txtLicenseNumber.text,
          "username": txtName.text,
          "password": txtPassword.text,
          "confirm_password": txtConPassword.text,
          "affiliation_id": 1, // ร้านนวด 1, หมอนวด 2 , ผู้ดำเนินการสปา 3
        });

        var dio = Dio();
        var response = await dio.post(
          'http://110.78.211.156:3001/api/v1/signup',
          options: Options(headers: headers),
          data: data,
        );

        if (response.statusCode == 200) {
          dialogSuccess();
          // print("✅ SignUp Success: ${response.data}");
          // await _signIn(txtName.text, txtPassword.text);
        } else {
          print("❌ SignUp Failed: ${response.statusMessage}");
        }
      } catch (e) {
        print("❌ Error in SignUp: $e");
      }
    }
  }

  // Future<void> _signIn(String username, String password) async {
  //   try {
  //     var headers = {'Content-Type': 'application/json'};
  //     var dio = Dio();
  //     var response = await dio.post(
  //       'http://110.78.211.156:3001/api/v1/signin',
  //       options: Options(headers: headers),
  //       data: json.encode({
  //         "username": username,
  //         "password": password,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       print("✅ SignIn Success: ${response.data}");
  //       String token = response.data["token"];
  //       storage.write(key: 'token', value: token);
  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => Menu()),
  //         (Route<dynamic> route) => false,
  //       );
  //     } else {
  //       print("❌ SignIn Failed: ${response.statusMessage}");
  //     }
  //   } catch (e) {
  //     print("❌ Error in SignIn: $e");
  //   }
  // }

  Future<void> signUpCustomer() async {
    print('-----------signUpCustomer--------------');
    print('Email: ${txtEmail.text}');
    print('Name: ${txtName.text}');
    print('Password: ${txtPassword.text}');

    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'sid=s%3AWYIZXxrcS3i4K557SyYJMoImJRVo1Anb.SNIAawcnz05zEL5cuujBAuORyod1Lqf49mrHNwmO6vE'
    };

    var data = {
      "email": txtEmail.text,
      "fullname": txtName.text,
      "password": txtPassword.text
    };

    var dio = Dio();

    try {
      var response = await dio.post(
        'https://api-ihealth.spl-system.com/api/v1/customer/signup',
        data: data,
        options: Options(headers: headers),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dialogSuccess();
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} - ${e.response?.data}');
      // ถ้าอยากโชว์ error ให้ user
      // dialogError(e.response?.data.toString() ?? 'เกิดข้อผิดพลาด');
      print(
          'Error during sign up: ${e.response?.data.toString() ?? 'เกิดข้อผิดพลาด'}');
    }
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ลงทะเบียน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tabController(),
                  SizedBox(height: 16),
                  selectType == '1'
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: labelTextihealt('* อีเมล'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtEmail,
                                  'อีเมล',
                                  true,
                                  validator: emailValidator,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* ชื่อผู้ใช้บริการ'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtName,
                                  'ชื่อผู้ใช้บริการ',
                                  true,
                                  // validator: passwordValidator,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* รหัสผ่าน'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtPassword,
                                  'รหัสผ่าน',
                                  true,
                                  validator: passwordValidator,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* ยืนยันรหัสผ่าน'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtConPassword,
                                  'ยืนยันรหัสผ่าน',
                                  true,
                                  validator: (value) =>
                                      confirmPasswordValidator(
                                          value, txtPassword.text),
                                ),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        '-----------ผู้ใช้บริการ--------------');
                                    setState(() {
                                      signUpCustomer();
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary_gold,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text(
                                        'ลงทะเบียน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: labelTextihealt('* เลขที่ใบรับรอง'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtLicenseNumber,
                                  'เลขที่ใบรับรอง',
                                  true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'กรุณากรอกเลขที่ใบรับรอง';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* อีเมล'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtName,
                                  'อีเมล',
                                  true,
                                  validator: emailValidator,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* รหัสผ่าน'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtPassword,
                                  'รหัสผ่าน',
                                  true,
                                  validator: passwordValidator,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                child: labelTextihealt('* ยืนยันรหัสผ่าน'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtConPassword,
                                  'ยืนยันรหัสผ่าน',
                                  true,
                                  validator: (value) =>
                                      confirmPasswordValidator(
                                          value, txtPassword.text),
                                ),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    print('-----------หมอนวด--------------');
                                  },
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                        color: AppColors.primary_gold,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                      child: Text(
                                        'ลงทะเบียน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                ],
              )),
        ),
      ),
    );
  }

  tabController() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectType = '1';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectType == '1'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'ผู้รับบริการ',
                    style: TextStyle(
                      color:
                          selectType == '1' ? Colors.white : AppColors.textdark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectType = '2';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectType == '2'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'หมอนวด',
                    style: TextStyle(
                      color:
                          selectType == '2' ? Colors.white : AppColors.textdark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
