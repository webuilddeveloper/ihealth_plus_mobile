import 'dart:ui';
import 'package:ihealth_2025_mobile/client/menu_client.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/edit_user_information_client.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/personalskills.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/dialog_fail.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/company.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/edit_user_information.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'change_password.dart';

class UserInformationClientPage extends StatefulWidget {
  final Function(int)? changePage;
  const UserInformationClientPage({Key? key, this.changePage})
      : super(key: key);
  @override
  _UserInformationClientPageState createState() =>
      _UserInformationClientPageState();
}

class _UserInformationClientPageState extends State<UserInformationClientPage> {
  final storage = new FlutterSecureStorage();
  Future<dynamic> _futureProfile = Future.value();
  dynamic _tempData = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureProfile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return card(snapshot.data);
          } else if (snapshot.hasError) {
            return dialogFail(context);
          } else {
            return card(_tempData);
          }
        },
      ),
    );
  }

  _read() async {
    // var profileCode = await storage.read(key: 'profileCode3');
    // if (profileCode != '' && profileCode != null)
    //   setState(() {
    //     _futureProfile = post(api+, {"code": profileCode});
    //   });
    var profileCode = await storage.read(key: 'customer_id');

    if (profileCode != '') {
      setState(() {
        _futureProfile = get("${api}/api/v1/customer/user/${profileCode}");
      });
    }
  }

  card(dynamic model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Stack(
                children: [
                  Container(
                    height: 270,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/ihealth/bg_client.jpg',
                          fit: BoxFit.cover,
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 146,
                width: 146,
                margin: EdgeInsets.only(top: 70),
                padding: EdgeInsets.all(10.0),
                child: model?['image'] != ''
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: model?['image'] != null
                            ? NetworkImage(
                                api + model?['image'],
                              )
                            : null,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: Container(
                          color: Colors.white12,
                          padding: EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/user_not_found.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(
                    top: 200.0, left: 20.0, right: 20.0, bottom: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          model?['fullname'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 270.0, bottom: 30.0),
                constraints: BoxConstraints(
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditUserInformationClientPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                            'assets/icons/person.png', 'ข้อมูลผู้ใช้งาน'),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.changePage != null) {
                            widget.changePage!(3);
                          }
                        },
                        child: buttonMenuUser(
                            'assets/ihealth/icon/heart1.png', 'รายการโปรด'),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.changePage != null) {
                            widget.changePage!(1);
                          }
                        },
                        child: buttonMenuUser(
                            'assets/ihealth/calendar_icon.png',
                            'ประวัติการนวด'),
                      ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => PersonalSkill(),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/person.png', 'ทักษะส่วนตัว'),
                      // ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CompanyPage()),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/service_7.png', 'สถานประกอบการ'),
                      // ),

                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ChangePasswordPage(),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/lock.png', 'เปลี่ยนรหัสผ่าน'),
                      // ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          versionName,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => logout(context),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () => logout(context),
                                child: Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(
                                    fontFamily: 'Sarabun',
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buttonMenuUser(String image, String title) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grayligh,
            width: 0.5,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(
              image,
              width: 25,
              height: 20,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15.0,
                  color: AppColors.textdark,
                ),
              ),
            ),
          ),
          Container(
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primary_gold,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
