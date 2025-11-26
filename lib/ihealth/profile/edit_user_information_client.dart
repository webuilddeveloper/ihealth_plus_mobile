import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ihealth_2025_mobile/client/menu_client.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/user_information.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/dialog_fail.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/widget/text_form_field.dart';
import 'package:mime/mime.dart';

class EditUserInformationClientPage extends StatefulWidget {
  @override
  _EditUserInformationClientPageState createState() =>
      _EditUserInformationClientPageState();
}

class _EditUserInformationClientPageState
    extends State<EditUserInformationClientPage> {
  final storage = FlutterSecureStorage();

  late String _imageUrl = '';
  bool isImageNetwork = true;

  final _formKey = GlobalKey<FormState>();

  List<String> _itemPrefixName = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': ''}
  ];
  late String _selectedSex;

  List<dynamic> _itemProvince = [];
  late String _selectedProvince;

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();

  final txtPrefixName = TextEditingController();
  final txtName = TextEditingController();
  final txtLastName = TextEditingController();

  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();

  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  String? selectGender;
  final txtNationality = TextEditingController();
  final txtMapLink = TextEditingController();

  final licensenumber = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  late XFile _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  final List<Map<String, String>> genderItems = [
    {'id': 'male', 'name': 'ชาย'},
    {'id': 'female', 'name': 'หญิง'},
    {'id': 'more', 'name': 'อื่นๆ'},
  ];

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futureModel = getUser();

    scrollController = ScrollController();
    var now = DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  Future<dynamic> getUser() async {
    var profileCode = await storage.read(key: 'customer_id');

    if (profileCode != '') {
      final result = await get("${api}/api/v1/customer/user/${profileCode}");

      if (result != null) {
        setState(() {
          _imageUrl = '${api}${result['image']}' ?? '';
          txtEmail.text = result['username'] ?? '';
          txtName.text = result['fullname'] ?? '';
          selectGender = result['gender'] ?? '';
          txtNationality.text = result['nationality'] ?? '';
          txtMapLink.text = result['mapLink'] ?? '';
          txtPhone.text = result['mobile'] ?? '';
        });
      }
    }
  }

  Future<dynamic> submitUpdateUser() async {
    var customer_id = await storage.read(key: 'customer_id');
    // var user = json.decode(value!);

    String mime = lookupMimeType(_image.path) ?? 'application/octet-stream';
    FormData formData = FormData.fromMap({
      "fullname": txtName.text,
      "gender": selectGender,
      "nationality": txtNationality.text,
      "mobile": txtPhone.text,
      "mapLink": txtMapLink.text,
      "image": await MultipartFile.fromFile(_image.path,
          filename: _image.name, contentType: DioMediaType.parse(mime)),
    });

    var response = await putUpdateProfile(
        '${api}api/v1/customer/user/${customer_id}', formData);

    
    if (response.statusCode == 200) {
      // await storage.write(
      //   key: 'dataUserLoginOPEC',
      //   value: jsonEncode(response['data']),
      // );

      await storage.write(key: 'fullname', value: response.data['data']["fullname"]);
      await storage.write(key: 'gender', value: response.data['data']["gender"]);
      await storage.write(key: 'mobile', value: response.data['data']["mobile"]);
      await storage.write(key: 'nationality', value: response.data['data']["nationality"]);
      await storage.write(key: 'mapLink', value: response.data['data']["mapLink"]);
      await storage.write(key: 'image', value: response.data['data']["image"]);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserInformationPage(),
      //   ),
      // );

      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: Text(
                'อัพเดตข้อมูลเรียบร้อยแล้ว',
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
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushAndRemoveUntil(
                    //   MaterialPageRoute(
                    //     builder: (context) => HomePageV2(),
                    //   ),
                    //   (Route<dynamic> route) => false,
                    // );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MenuClient(pageIndex: 4,),
                      ),
                      (Route<dynamic> route) => false,
                    );
                    // goBack();
                    // Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: Text(
                'อัพเดตข้อมูลไม่สำเร็จ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(
                response['message'].toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginOPEC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtEmail.text = user['email'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        _selectedPrefixName = user['prefixName'];
        txtPrefixName.text = user['prefixName'] ?? '';
        _selectedProvince = user['provinceCode'] ?? '';
        _selectedDistrict = user['amphoeCode'] ?? '';
        _selectedSubDistrict = user['tambonCode'] ?? '';
        _selectedPostalCode = user['postnoCode'] ?? '';
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }

      if (_selectedProvince != '') {
        getProvince();
        getDistrict();
        getSubDistrict();
        getPostalCode();
        // setState(() {
        //   futureModel = getUser();
        // });
      } else {
        getProvince();
        // setState(() {
        //   futureModel = getUser();
        // });
      }
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
    );
  }

  dialogOpenPickerDate() {
    dt_picker.DatePicker.showDatePicker(context,
        theme: dt_picker.DatePickerTheme(
          containerHeight: 210.0,
          itemStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        },
      );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: dt_picker.LocaleType.th);
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            // Text(
            //   'ข้อมูลผู้ใช้งาน',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Sarabun',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),
            // SizedBox(height: 5.0),

            labelTextFormField('อีเมล'),
            textFormFieldNoValidator(
              txtEmail,
              'อีเมล',
              false,
              false,
            ),

            labelTextFormField('* ชื่อ'),
            textFormField(
              txtName,
              null,
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
            ),

            labelTextFormField('เพศ'),
            dropdownSelect(
              context,
              selectGender,
              (String? newValue) {
                setState(() {
                  selectGender = newValue;
                });
              },
              'เลือกเพศ',
              true,
              genderItems,
            ),

            labelTextFormField('สัญชาติ'),
            textFormFieldNoValidator(
              txtNationality,
              'สัญชาติ',
              true,
              false,
            ),

            labelTextFormField('ตำแหน่งที่อยู่'),
            Row(
              children: [
                Expanded(
                  child: textFormFieldNoValidator(
                    txtMapLink,
                    'ตำแหน่งที่อยู่',
                    true,
                    false,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    Position position = await _getCurrentPosition();
                    print(
                        "Lat: ${position.latitude}, Lng: ${position.longitude}");
                    setState(() {
                      txtMapLink.text =
                          'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                    ),
                    child: Text(
                      'ดึงตำแหน่ง',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                )
              ],
            ),

            labelTextFormField('* เบอร์โทรศัพท์ (10 หลัก)'),
            textFormPhoneField(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              false,
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Center(
              child: Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: AppColors.primary,
                  child: MaterialButton(
                    height: 40,
                    onPressed: () {
                      // final form = _formKey.currentState;
                      // if (form!.validate()) {
                      //   form.save();
                      submitUpdateUser();
                      // }
                    },
                    child: Text(
                      'บันทึกข้อมูล',
                      style: TextStyle(
                        fontSize: 16.0,
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
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF9A1120),
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
      _imageUrl = image!.path;
      isImageNetwork = false;
    });
    // _upload();
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
      _imageUrl = image!.path;
      isImageNetwork = false;

      print('======>>>>>> ${_imageUrl}');
    });
    // _upload();
  }

  void _upload() async {
    // uploadImage(_image).then((res) {
    //   setState(() {
    //     _imageUrl = res;
    //   });
    // }).catchError((err) {
    //   print(err);
    // });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text(
                      'อัลบั้มรูปภาพ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('กรุณาเปิด GPS');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('ปฏิเสธการขอตำแหน่ง');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('ปิดสิทธิ์ถาวร ต้องไปเปิดใน Settings');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'แก้ไขข้อมูล',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Color(0xFFF5F8FB),
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Container(
              color: Colors.white,
              child: dialogFail(context),
            ));
          } else {
            return Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 96.0,
                          height: 96.0,
                          margin: EdgeInsets.only(top: 30.0),
                          padding: EdgeInsets.all(_imageUrl != '' ? 0.0 : 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showPickerImage(context);
                            },
                            child: _imageUrl != ''
                                ? CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: isImageNetwork
                                        ? NetworkImage(_imageUrl)
                                        : AssetImage(_imageUrl),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      'assets/images/user_not_found.png',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPickerImage(context);
                        },
                        child: Center(
                          child: Container(
                            width: 31.0,
                            height: 31.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context).primaryColor),
                            margin: EdgeInsets.only(top: 90.0, left: 70.0),
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child:
                                  Image.asset('assets/logo/icons/Group37.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: contentCard(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
