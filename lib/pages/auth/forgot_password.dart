import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/component/header.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/widget/text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final txtEmail = TextEditingController();

  @override
  void dispose() {
    txtEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitForgotPassword() async {
    await postObjectData('m/Register/forgot/password', {
      'email': txtEmail.text,
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(
            'ส่งคำขอสำเร็จ',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Sarabun', fontWeight: FontWeight.w600),
          ),
          content: Text(
            'เราได้ส่งรหัสผ่านใหม่ไปที่อีเมล\n${txtEmail.text}\nเรียบร้อยแล้ว',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Sarabun', fontSize: 14),
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                ),
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                      fontFamily: 'Sarabun',
                      color: Colors.white,
                      fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Go back to the previous page
                },
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
    setState(() {
      txtEmail.text = '';
    });
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:
            header(context, goBack, title: 'ลืมรหัสผ่าน', rightButton: null),
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Container(
              child: ListView(
                children: <Widget>[
                  new Container(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Text(
                                    'กรอกอีเมลเพื่อรับรหัสผ่านใหม่ ระบบจะส่งรหัสผ่านใหม่ไปยังอีเมลของคุณ',
                                    style: TextStyle(
                                      fontSize: 18.00,
                                      fontFamily: 'Sarabun',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                labelTextFormField('อีเมล'),
                                ihealtTextFormField(
                                  txtEmail,
                                  'กรอกอีเมล',
                                  true,
                                  validator: emailValidator,
                                ),
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    margin: EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 10.0,
                                    ),
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).primaryColor,
                                      child: MaterialButton(
                                        height: 40,
                                        onPressed: () {
                                          final form = _formKey.currentState;
                                          if (form!.validate()) {
                                            form.save();
                                            submitForgotPassword();
                                          }
                                        },
                                        child: new Text(
                                          'ยืนยัน',
                                          style: new TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Sarabun',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
