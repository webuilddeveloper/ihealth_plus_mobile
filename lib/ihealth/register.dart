// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/shared/api_provider_ihealth.dart';
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
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

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

  Future<void> signUpCustomer() async {
    print('-----------signUpCustomer--------------');
    print('Email: ${txtEmail.text}');
    print('Name: ${txtName.text}');
    print('Password: ${txtPassword.text}');

    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    var data = {
      "email": txtEmail.text,
      "fullname": txtName.text,
      "password": txtPassword.text
    };

    try {
      // เปลี่ยนมาใช้ getInstance() ที่เป็น async
      final apiProvider = await ApiProviderIhealth.getInstance();
      var response = await apiProvider.post('v1/customer/signup', data: data);

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

  Future<void> signUpTherapists() async {
    print('-----------signUpCustomer--------------');
    print('Email: ${txtLicenseNumber.text}');
    print('Name: ${txtName.text}');
    print('Password: ${txtPassword.text}');

    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    var data = {
      "license_number": txtLicenseNumber.text,
      "username": txtName.text,
      "password": txtPassword.text
    };

    try {
      // เปลี่ยนมาใช้ getInstance() ที่เป็น async
      final apiProvider = await ApiProviderIhealth.getInstance();
      var response = await apiProvider.post('v1/therapists/signup', data: data);

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
                                child: labelTextihealt('* ชื่อ-นามสกุล'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtName,
                                  'ชื่อ-นามสกุล',
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
                                  obscureText: _isPasswordObscured,
                                  validator: passwordValidator,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() => _isPasswordObscured =
                                          !_isPasswordObscured);
                                    },
                                  ),
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
                                  obscureText: _isConfirmPasswordObscured,
                                  validator: (value) =>
                                      confirmPasswordValidator(
                                          value, txtPassword.text),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() =>
                                        _isConfirmPasswordObscured =
                                            !_isConfirmPasswordObscured),
                                  ),
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
                                child: labelTextihealt('* ผู้ชื่อใช้'),
                              ),
                              Container(
                                child: ihealtTextFormField(
                                  txtName,
                                  'ชื่อผู้ใช้',
                                  true,
                                  // validator: emailValidator,
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
                                  obscureText: _isPasswordObscured,
                                  validator: passwordValidator,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() =>
                                        _isPasswordObscured =
                                            !_isPasswordObscured),
                                  ),
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
                                  obscureText: _isConfirmPasswordObscured,
                                  validator: (value) =>
                                      confirmPasswordValidator(
                                          value, txtPassword.text),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () => setState(() =>
                                        _isConfirmPasswordObscured =
                                            !_isConfirmPasswordObscured),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    print('-----------หมอนวด--------------');
                                    setState(() {
                                      signUpTherapists();
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
