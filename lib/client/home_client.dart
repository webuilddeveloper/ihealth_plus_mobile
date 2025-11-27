// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:ihealth_2025_mobile/client/booking/booking.dart';
import 'package:ihealth_2025_mobile/client/shop_details.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/ihealth/apply/apply-detail.dart';
import 'package:ihealth_2025_mobile/ihealth/apply/apply.dart';
import 'package:ihealth_2025_mobile/ihealth/course/course-detail.dart';
import 'package:ihealth_2025_mobile/ihealth/course/course.dart';
import 'package:ihealth_2025_mobile/ihealth/main_popup/dialog_main_popup.dart';
import 'package:ihealth_2025_mobile/pages/Complaint.dart';
import 'package:ihealth_2025_mobile/ihealth/login.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/toast_fail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ihealth_2025_mobile/pages/privilege/privilege_main.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeClient extends StatefulWidget {
  HomeClient({Key? key, required this.changePage}) : super(key: key);
  Function changePage;

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient>
    with SingleTickerProviderStateMixin {
  final storage = new FlutterSecureStorage();
  late DateTime currentBackPressTime;

  late AnimationController _controller;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureNews;
  late Future<dynamic> _futureMenu;
  late Future<dynamic> _futureRotation;
  late Future<dynamic> _futureAboutUs;
  late Future<dynamic> _futureMainPopUp;
  late Future<dynamic> _futureVerifyTicket;

  dynamic profileModel = {};

  String profileCode = '';
  String currentLocation = '-';
  final seen = Set<String>();
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;

  final medalMap = {
    1: {'color': Colors.amber, 'text': '1'},
    2: {'color': Colors.grey, 'text': '2'},
    3: {'color': Colors.brown, 'text': '3'},
  };

  RefreshController _refreshController = RefreshController(
      initialRefresh: false,
      initialRefreshStatus: RefreshStatus.idle,
      initialLoadStatus: LoadStatus.idle);

  LatLng latLng = LatLng(13.743989326935178, 100.53754006134743);

  int _currentNewsPage = 0;
  int _newsLimit = 4;
  List<dynamic> _newsList = [];
  bool _hasMoreNews = true;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _newsList = [];
    _read();
    currentBackPressTime = DateTime.now();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // 1 วินาทีต่อรอบ
    )..repeat(reverse: true); // กลับไปกลับมา

    _callReadShop();
    _callReadCourse();
    _readProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0XFFF3F5F5),
      backgroundColor: Colors.white,
      body: WillPopScope(
        child: _buildBackground(),
        onWillPop: confirmExit,
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _buildBackground() {
    return Container(
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildSmartRefresher(),
    );
  }

  _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(),
      footer: ClassicFooter(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      physics: BouncingScrollPhysics(),
      child: _buildMenu(context),
    );
  }

  _buildMenu(context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _buildhead(),
            SizedBox(height: 15),
            _buildBooking(),
            SizedBox(height: 15),

            _buildShop(),
            SizedBox(height: 15),
            _buildCourse(),
            SizedBox(
              height: 60,
            )

            // _build
            // _buildProfile(),
            // _buildBanner(),
            // _buildNews(),
          ],
        ),
      ),
    );
  }

  bool isLoggedIn = false;
  String userName = "Dev Tester";

  _buildhead() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Responsive values based on screen size
        final isSmallScreen = screenWidth < 360;
        final isMediumScreen = screenWidth >= 360 && screenWidth < 414;
        final isLargeScreen = screenWidth >= 414;

        // Dynamic sizing
        final headerHeight =
            isSmallScreen ? 240.0 : (isMediumScreen ? 260.0 : 280.0);
        final backgroundHeight =
            isSmallScreen ? 180.0 : (isMediumScreen ? 200.0 : 220.0);
        final cardTopPosition =
            isSmallScreen ? 125.0 : (isMediumScreen ? 135.0 : 145.0);
        final horizontalPadding = isSmallScreen ? 12.0 : 15.0;
        final cardPadding =
            isSmallScreen ? 15.0 : (isMediumScreen ? 18.0 : 20.0);

        return Container(
          height: headerHeight,
          child: Stack(
            children: [
              Container(
                height: backgroundHeight,
                width: double.infinity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Image.asset(
                    'assets/ihealth/bg_client.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                top: cardTopPosition,
                left: horizontalPadding,
                right: horizontalPadding,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(isSmallScreen ? 16 : 20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 25,
                        spreadRadius: 0,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey[100]!,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: _buildCardContent(
                        screenWidth, isSmallScreen, isMediumScreen),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _buildCardContent(
      double screenWidth, bool isSmallScreen, bool isMediumScreen) {
    // Profile image size based on screen size
    final profileSize = isSmallScreen ? 70.0 : (isMediumScreen ? 80.0 : 85.0);
    final profilePadding = isSmallScreen ? 8.0 : 10.0;
    final spacing = isSmallScreen ? 15.0 : 20.0;

    return Row(
      children: [
        Container(
          height: profileSize,
          width: profileSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightgreen,
                AppColors.lightgreen.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 12,
                spreadRadius: 0,
                offset: Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(profilePadding),
            child: (profileModel['token'] ?? "") != ""
                ? Container(
                    // height: MediaQuery.of(context).size.height * 0.12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      // image: DecorationImage(
                      //   image: AssetImage(shop['imgUrl']),
                      //   fit: BoxFit.cover,
                      // ),
                      image: DecorationImage(
                        image: NetworkImage('${api}/${profileModel['image']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                //  Image.network(
                //     '${api}/uploads/user/${profileModel['image']}',
                //     // color: AppColors.primary,
                //     fit: BoxFit.contain,
                //   )
                : Image.asset(
                    'assets/images/user_not_found.png',
                    color: AppColors.primary,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        SizedBox(width: spacing),

        // Content Section
        Expanded(
          // child: isLoggedIn == true
          child: (profileModel['token'] ?? "") != ""
              ? _buildLoggedInContent(isSmallScreen, isMediumScreen)
              : _buildNotLoggedInContent(isSmallScreen, isMediumScreen),
        ),
      ],
    );
  }

  _buildLoggedInContent(bool isSmallScreen, bool isMediumScreen) {
    // Responsive font sizes
    final titleFontSize = isSmallScreen ? 18.0 : (isMediumScreen ? 22.0 : 24.0);
    final subtitleFontSize =
        isSmallScreen ? 15.0 : (isMediumScreen ? 18.0 : 20.0);
    final badgeFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 15.0);
    final badgePaddingH = isSmallScreen ? 10.0 : 12.0;
    final badgePaddingV = isSmallScreen ? 4.0 : 6.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: profileModel['loginType'] == "1"
              ? Text(
                  profileModel['fullname'] ?? '',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.2,
                    letterSpacing: -0.3,
                  ),
                  maxLines: isSmallScreen ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                )
              : RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: isSmallScreen ? 2 : 3,
                  text: TextSpan(
                    text: 'หมอนวด',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' รัชชานนท์ ',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: AppColors.primary_gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: badgePaddingH, vertical: badgePaddingV),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
            border: Border.all(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          child: Text(
            profileModel['loginType'] == "1"
                ? 'ผู้รับบริการ'
                : 'นวดเพื่อสุขภาพ',
            style: TextStyle(
              fontFamily: 'Sarabun',
              fontSize: badgeFontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  _buildNotLoggedInContent(bool isSmallScreen, bool isMediumScreen) {
    // Responsive font sizes
    final titleFontSize = isSmallScreen ? 20.0 : (isMediumScreen ? 22.0 : 24.0);
    final subtitleFontSize =
        isSmallScreen ? 12.0 : (isMediumScreen ? 13.0 : 14.0);
    final linkFontSize = isSmallScreen ? 14.0 : (isMediumScreen ? 15.0 : 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'iHealth',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '+',
                  style: TextStyle(color: AppColors.primary_gold),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Sarabun',
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
              height: 1.3,
            ),
            children: [
              TextSpan(text: 'ท่านยังไม่ได้เป็นสมาชิก '),
              TextSpan(
                text: 'สมัครสมาชิก',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary_gold,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary_gold,
                  decorationThickness: 1.5,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print('สมัครสมาชิก');
                  },
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

  _buildBooking() {
    return Center(
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'iHealth +',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF006D3E),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'จองง่าย สะดวกรวดเร็ว: จองนวดได้ในไม่กี่คลิก เลือกวันเวลาและประเภทนวดได้ทันใจ ไม่ต้องโทรหรือรอคิว',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1F2937),
                fontFamily: 'Kanit',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD9A825), // สีเหลืองทอง
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Booking(),
                  ),
                );
              },
              child: Text(
                'จองเลย !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildShop() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ร้านเด่นประจำเดือนนี้',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockShop.length,
              itemBuilder: (context, index) {
                final shop = mockShop[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetail(
                          shopId: shop['uuid'],
                          // course: shop,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 220,
                    margin:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            // รูปคอร์ส
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                // image: DecorationImage(
                                //   image: AssetImage(shop['imgUrl']),
                                //   fit: BoxFit.cover,
                                // ),
                                image: DecorationImage(
                                  image: NetworkImage(api + shop['image']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            if (index == 0)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: _buildMedal(Colors.amber, "1"),
                              )
                            else if (index == 1)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: _buildMedal(Colors.grey, "2"),
                              )
                            else if (index == 2)
                              Positioned(
                                top: 5,
                                right: 5,
                                child: _buildMedal(Colors.brown, "3"),
                              ),
                          ],
                        ),

                        // ส่วนข้อความ
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop['massage_name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: "sarabun",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF07663a)),
                              ),
                              // Row(
                              //   children: [
                              //     const Icon(
                              //       Icons.timer_outlined,
                              //       color: Colors.black87,
                              //       size: 16,
                              //     ),
                              //     const SizedBox(width: 8),
                              //     Text('${widget.course['time']}'),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  _buildCourse() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'สนใจเรียนคอร์สนวด',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockCourse.length,
              itemBuilder: (context, index) {
                final course = mockCourse[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CourseDetail(
                    //       course: course,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: 220,
                    margin:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(api +
                                  '/uploads/school/course/' +
                                  course['smallImage']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // ส่วนข้อความ
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: "sarabun",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF07663a)),
                              ),
                              Row(
                                children: [
                                  Text('ระยะเวลาเรียน'),
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: Colors.black87,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(': ${course['hours']} นาที'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMedal(Color color, String text) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double t = _controller.value;
        return Transform.scale(
          scale: 1.0 + 0.15 * t, // ซูมเข้าออก
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(
                color: Colors.white, // ขอบสีขาวทำให้ตัดกับพื้นหลัง
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.8),
                  blurRadius: 8 + (4 * t), // ขยาย/หด blur
                  spreadRadius: 1 + t, // ขยาย/หด spread
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildService() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceIcon(
                path: 'assets/icons/service_1.png',
                title: 'สมัครงาน',
                callBack: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Apply(
                        job: mockCourse,
                      ),
                    ),
                  );
                },
              ),
              // _buildServiceIcon(
              //   path: 'assets/icons/service_3.png',
              //   title: 'หลักสูตร',
              //   callBack: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => Course(
              //           course: mockCourse,
              //         ),
              //       ),
              //     );
              //   },
              // ),
              _buildServiceIcon(
                path: 'assets/icons/service_5.png',
                title: 'ร้องเรียน',
                callBack: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintForm(),
                    ),
                  );
                },
              ),
              _buildServiceIcon(
                path: 'assets/icons/service_8.png',
                title: 'สิทธิประโยชน์',
                callBack: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivilegeMain(
                        title: "สิทธิประโยชน์",
                        fromPolicy: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildServiceIcon(
      {required String path,
      required String title,
      required Function callBack}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => callBack(),
          child: Container(
            alignment: Alignment.center,
            width: 53,
            height: 54,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              child: Image.asset(
                path,
                width: 33,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w400,
            color: Color(0XFF224B45),
          ),
        ),
      ],
    );
  }

  _readProfile() async {
    await storage.read(key: 'fullname').then((v) => setState(() {
          profileModel['fullname'] = v;
        }));
    await storage.read(key: 'mobile').then((v) => setState(() {
          profileModel['mobile'] = v;
        }));
    await storage.read(key: 'image').then((v) => setState(() {
          
          profileModel['image'] = v ??
              'uploads/user/image_picker_59134153-C405-4B7A-A5DB-DD097DAC3FDD-44179-000000520CA52D69-1764139168877-370813615.jpg';
        }));
    await storage.read(key: 'token').then((v) => setState(() {
          profileModel['token'] = v;
        }));
    await storage.read(key: 'loginType').then((v) => setState(() {
          profileModel['loginType'] = v;
        }));
  }

  _read() async {
    // print('-------------start response------------');
    _getLocation();
    //read profile
    profileCode = (await storage.read(key: 'profileCode3'))!;
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
      _futureMenu = postDio('${menuApi}read', {'limit': 10});
      _futureBanner = postDio('${mainBannerApi}read', {
        'limit': 10,
        'app': 'massage',
      });
      _futureRotation = postDio('${mainRotationApi}read', {'limit': 10});
      _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
      _futureAboutUs = postDio('${aboutUsApi}read', {});

      _currentNewsPage = 0;
      _futureNews = postDio('${newsApi}read', {
        'skip': _currentNewsPage * _newsLimit,
        'limit': _newsLimit,
        'app': 'massage',
      });

      _futureVerifyTicket = postDio(getNotpaidTicketListApi,
          {"createBy": "createBy", "updateBy": "updateBy"});
      // getMainPopUp();
      // _getLocation();
      // print('-------------end response------------');
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  getMainPopUp() async {
    var result =
        await post('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          this.setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp,
                  type: 'mainPopup',
                  key: null,
                  url: '',
                  urlGallery: '',
                  username: '',
                ),
              );
            },
          );
        } else {
          this.setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        this.setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp,
                type: 'mainPopup',
                key: null,
                url: '',
                urlGallery: '',
                username: '',
              ),
            );
          },
        );
      }
    }
  }

  void _onLoading() async {
    if (!_hasMoreNews) {
      _refreshController.loadComplete();
      return;
    }
    _currentNewsPage++;
    final moreNews = await postDio('${newsApi}read', {
      'skip': _currentNewsPage * _newsLimit,
      'limit': _newsLimit,
      'app': 'massage',
    });
    if (moreNews != null && moreNews.length < _newsLimit) {
      _hasMoreNews = false;
    }
    if (moreNews == null || moreNews.isEmpty) {
      _hasMoreNews = false;
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      if (_newsList.isEmpty) {
        _newsList = moreNews;
      } else {
        _newsList.addAll(moreNews);
      }
    });
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    print("เริ่มรีเฟรช");
    _currentNewsPage = 0;
    _hasMoreNews = true;

    try {
      var newsData = await postDio('${newsApi}read', {
        'skip': 0,
        'limit': _newsLimit,
        'app': 'massage',
      });

      setState(() {
        _newsList = newsData ?? [];
      });

      if (newsData == null || newsData.length < _newsLimit) {
        _hasMoreNews = false;
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการรีเฟรช: $e");
    }

    _refreshController.refreshCompleted();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    print('🔍 กำลังตรวจสอบสิทธิ์ GPS...');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ กรุณาเปิด GPS ก่อนใช้งาน");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ ผู้ใช้ปฏิเสธสิทธิ์ Location");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ ผู้ใช้ปฏิเสธถาวร ต้องไปเปิดที่ Settings");
      openAppSettings();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      print("📍 พิกัดที่ได้: ${position.latitude}, ${position.longitude}");
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        print("🏙️ ตำแหน่ง: ${place.administrativeArea}, ${place.country}");

        setState(() {
          latLng = LatLng(position.latitude, position.longitude);
          currentLocation = (placemarks.isNotEmpty &&
                  placemarks.first.administrativeArea != null)
              ? placemarks.first.administrativeArea!
              : "ไม่ทราบที่อยู่";
        });
      } else {
        print("❌ ไม่พบข้อมูลสถานที่จากพิกัดนี้");
      }
    } catch (e) {
      print("❌ เกิดข้อผิดพลาด: $e");
    }
  }

  _callReadShop() async {
    get(api + '/api/v1/shop/featured-shop').then(
      (v) => {
        setState(() {
          mockShop = v;
        }),
      },
    );
  }

  _callReadCourse() async {
    get(api + '/api/v1/shop/massage-course').then(
      (v) => {
        setState(() {
          mockCourse = v;
        }),
      },
    );
  }

  List<dynamic> mockShop = [
    // {
    //   "title": "ร้านนวดสบายใจ",
    //   "category": "นวดเท้า",
    //   "province": "กรุงเทพมหานคร",
    //   "district": "บางรัก",
    //   "imgUrl": "assets/ihealth/shop1.jpg",
    //   "booking": 144
    // },
    // {
    //   "title": "ร้านผ่อนคลาย",
    //   "category": "นวดอโรมา",
    //   "province": "เชียงใหม่",
    //   "district": "เมืองเชียงใหม่",
    //   "imgUrl": "assets/ihealth/shop2.jpg",
    //   "booking": 345
    // },
    // {
    //   "title": "ร้านสุขใจ",
    //   "category": "นวดไทย",
    //   "province": "ภูเก็ต",
    //   "district": "เมืองภูเก็ต",
    //   "imgUrl": "assets/ihealth/shop3.jpg",
    //   "booking": 213
    // },
  ];

  List<dynamic> mockCourse = [];
}
