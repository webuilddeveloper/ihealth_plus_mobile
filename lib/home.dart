// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/pages/check_security_license.dart';
import 'package:ihealth_2025_mobile/pages/ihealth/apply/apply-detail.dart';
import 'package:ihealth_2025_mobile/pages/ihealth/apply/apply.dart';
import 'package:ihealth_2025_mobile/pages/ihealth/course/course-detail.dart';
import 'package:ihealth_2025_mobile/pages/ihealth/course/course.dart';
import 'package:ihealth_2025_mobile/pages/qa_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ihealth_2025_mobile/pages/Complaint.dart';
import 'package:ihealth_2025_mobile/component/material/check_avatar.dart';
import 'package:ihealth_2025_mobile/component/menu/build_verify_ticket.dart';
import 'package:ihealth_2025_mobile/component/menu/color_item.dart';
import 'package:ihealth_2025_mobile/component/menu/image_item.dart';
import 'package:ihealth_2025_mobile/component/v2/button_menu_full.dart';
import 'package:ihealth_2025_mobile/login.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/blank_loading.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/toast_fail.dart';
import 'package:ihealth_2025_mobile/pages/dispute_an_allegation.dart';
import 'package:ihealth_2025_mobile/pages/matching_job.dart';
import 'package:ihealth_2025_mobile/pages/my_qr_code.dart';
import 'package:ihealth_2025_mobile/pages/news/news_form.dart';
import 'package:ihealth_2025_mobile/pages/reporter/reporter_main.dart';
import 'package:ihealth_2025_mobile/pages/store_productlist.dart';
import 'package:ihealth_2025_mobile/pages/warning/warning_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ihealth_2025_mobile/component/carousel_banner.dart';
import 'package:ihealth_2025_mobile/pages/about_us/about_us_form.dart';
import 'package:ihealth_2025_mobile/pages/menu_grid_item.dart';
import 'package:ihealth_2025_mobile/pages/notification/notification_list.dart';
import 'package:ihealth_2025_mobile/pages/poi/poi_list.dart';
import 'package:ihealth_2025_mobile/pages/poll/poll_list.dart';
import 'package:ihealth_2025_mobile/pages/welfare/welfare_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ihealth_2025_mobile/component/link_url_in.dart';
import 'package:ihealth_2025_mobile/pages/contact/contact_list_category.dart';
import 'package:ihealth_2025_mobile/pages/news/news_list.dart';
import 'package:ihealth_2025_mobile/pages/privilege/privilege_main.dart';
import 'package:ihealth_2025_mobile/pages/profile/user_information.dart';
import 'package:ihealth_2025_mobile/pages/register_permission_mian.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/component/carousel_form.dart';
import 'component/carousel_rotation.dart';
import 'pages/event_calendar/event_calendar_main.dart';
import 'pages/knowledge/knowledge_list.dart';
import 'pages/main_popup/dialog_main_popup.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.changePage}) : super(key: key);

  Function changePage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = new FlutterSecureStorage();
  late DateTime currentBackPressTime;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureNews;
  late Future<dynamic> _futureMenu;
  late Future<dynamic> _futureRotation;
  late Future<dynamic> _futureAboutUs;
  late Future<dynamic> _futureMainPopUp;
  late Future<dynamic> _futureVerifyTicket;

  String profileCode = '';
  String currentLocation = '-';
  final seen = Set<String>();
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;

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
            SizedBox(height: 12),
            _buildService(),
            _buildCourse(),
            _buildApply(),
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
                child: Image.asset(
                  'assets/ihealth/bg.jpg',
                  fit: BoxFit.cover,
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
            child: Image.asset(
              'assets/images/user_not_found.png',
              color: AppColors.primary,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: spacing),

        // Content Section
        Expanded(
          child: isLoggedIn == true
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
          child: RichText(
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
            'นวดเพื่อสุขภาพ',
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
              'หลักสูตรของเรา',
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
                    print(mockCourse[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetail(
                          course: course,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 220,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: Offset(0, 2),
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
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: AssetImage(course['img']),
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
                                style: TextStyle(
                                  fontFamily: "sarabun",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    color: AppColors.textdark,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${course['time']}',
                                    style: TextStyle(
                                      color: AppColors.textdark,
                                      fontFamily: "sarabun",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '฿ ${course['price']}',
                                style: TextStyle(
                                  color: AppColors.primary_gold,
                                  fontFamily: "sarabun",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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

  Widget _buildApply() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              'ประกาศรับสมัครงาน',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: jobList.length,
            itemBuilder: (context, index) {
              final job = jobList[index];
              return _buildJobCard(context, job);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () {
        print(job['title']);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApplyDetail(
                job: job,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: job['imgUrl'] != null && job['imgUrl'].isNotEmpty
                      ? Image.network(
                          job['imgUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 32,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[100],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.work_outline,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job['title'] ?? 'ไม่ระบุตำแหน่ง',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "Sarabun",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      if (job['working_hours'] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: AppColors.textdark,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${job['working_hours']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textdark,
                                  fontFamily: "Sarabun",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (job['salary'] != null)
                        Text(
                          '฿ ${(job['salary'])}',
                          style: TextStyle(
                            color: AppColors.primary_gold,
                            fontFamily: "Sarabun",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                        job: jobList,
                      ),
                    ),
                  );
                },
              ),
              _buildServiceIcon(
                path: 'assets/icons/service_3.png',
                title: 'หลักสูตร',
                callBack: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Course(
                        course: mockCourse,
                      ),
                    ),
                  );
                },
              ),
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

  _buildNews() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 30, bottom: 60),
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ข่าวประชาสัมพันธ์',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsList(
                          title: 'ข่าวประชาสัมพันธ์',
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      Text(
                        'ดูทั้งหมด',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                          color: Color(0XFF27544F),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 17,
                        color: Color(0XFF27544F),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            FutureBuilder<dynamic>(
              future: _futureNews,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null && snapshot.data.length > 0) {
                    _newsList = snapshot.data;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero, // ปิด padding เพื่อให้ชิดขอบบนสุด
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: _newsList.length,
                    itemBuilder: (context, index) {
                      var data = _newsList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsForm(
                                url: data['url'] ?? '',
                                code: data['code'] ?? '',
                                model: data ?? '',
                                urlComment: newsApi,
                                urlGallery: newsGalleryApi,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.transparent,
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: data['imageUrl'] != null &&
                                            data['imageUrl']
                                                .toString()
                                                .isNotEmpty
                                        ? Image.network(
                                            data['imageUrl'],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : BlankLoading(
                                            height: double.infinity,
                                            width: double.infinity,
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${data['title']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sarabun',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return BlankLoading(
                    width: null,
                    height: null,
                  );
                } else {
                  return const Center(
                    child: Text(
                      'ไม่พบข้อมูล',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildGridMenu1() {
    return FutureBuilder<dynamic>(
      future: _futureMenu, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              MenuGridItem(
                title: snapshot.data[0]['title'],
                imageUrl: snapshot.data[0]['imageUrl'],
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventCalendarMain(
                        title: snapshot.data[0]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => EventCalendarMain(
                  //         title: snapshot.data[0]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[1]['title'] != ''
                    ? snapshot.data[1]['title']
                    : '',
                imageUrl: snapshot.data[1]['imageUrl'],
                subTitle: '',
                isCenter: true,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowledgeList(
                        title: snapshot.data[1]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => KnowledgeList(
                  //         title: snapshot.data[1]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _Direction();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[2]['title'] != ''
                    ? snapshot.data[2]['title']
                    : '',
                imageUrl: snapshot.data[2]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReporterMain(
                        title: snapshot.data[2]['title'],
                        key: null,
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ReporterMain(
                  //         title: snapshot.data[2]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildGridMenu2() {
    return FutureBuilder<dynamic>(
      future: _futureMenu, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              MenuGridItem(
                title: snapshot.data[3]['title'] != ''
                    ? snapshot.data[3]['title']
                    : '',
                imageUrl: snapshot.data[3]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WarningList(
                        title: snapshot.data[3]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => WarningList(
                  //         title: snapshot.data[3]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[4]['title'] != ''
                    ? snapshot.data[4]['title']
                    : '',
                imageUrl: snapshot.data[4]['imageUrl'],
                subTitle: '',
                isCenter: true,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelfareList(
                        title: snapshot.data[4]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => WelfareList(
                  //         title: snapshot.data[4]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[5]['title'] != ''
                    ? snapshot.data[5]['title']
                    : '',
                imageUrl: snapshot.data[5]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsList(
                        title: snapshot.data[5]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => NewsList(
                  //         title: snapshot.data[5]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildRotation() {
    return CarouselRotation(
      model: _futureRotation,
      nav: (String path, String action, dynamic model, String code) {
        if (action == 'out') {
          launchInWebViewWithJavaScript(path);
          // launchURL(path);
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarouselForm(
                code: code,
                model: model,
                url: mainBannerApi,
                urlGallery: bannerGalleryApi,
              ),
            ),
          );
        }
      },
    );
  }

  // _buildProfile() {
  //   return Container(
  //     height: 310,
  //     child: Stack(
  //       children: [
  //         Container(
  //           height: 240,
  //           // color: Colors.amber,
  //           child: Image.asset(
  //             'assets/icons/background-home.png',
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Positioned.fill(
  //           top: 150,
  //           bottom: 20,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 20,
  //             ),
  //             child: Container(
  //               height: 40,
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(16),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     offset: const Offset(0, 3),
  //                     color: Colors.black.withOpacity(0.1),
  //                     blurRadius: 6,
  //                   ),
  //                 ],
  //               ),
  //               child: FutureBuilder<dynamic>(
  //                 future: _futureProfile,
  //                 builder:
  //                     (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //                   final item = snapshot.data ?? {}; // ป้องกัน Null
  //                   final queryParameters =
  //                       item.map<String, String?>((key, value) {
  //                     if (key is! String) return MapEntry(key.toString(), null);
  //                     if (value == null) return MapEntry(key, null);
  //                     return MapEntry(key, value.toString());
  //                   })
  //                         ..removeWhere((key, value) => value == null);
  //                   final Uri qrUri = Uri(
  //                     scheme: "http",
  //                     host: "gateway.we-builds.com",
  //                     path: "security_information.html",
  //                     queryParameters: queryParameters,
  //                   );
  //                   if (snapshot.hasData) {
  //                     if (profileCode == snapshot.data['code']) {
  //                       return Row(
  //                         children: [
  //                           SizedBox(
  //                             height: 60,
  //                             width: 60,
  //                             child: checkAvatar(
  //                                 context, '${snapshot.data['imageUrl']}'),
  //                           ),
  //                           const SizedBox(
  //                             width: 20,
  //                           ),
  //                           Expanded(
  //                             child: Container(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     '${snapshot.data['firstName'] ?? ''} ${snapshot.data['lastName'] ?? ''}',
  //                                     style: TextStyle(
  //                                       fontSize: 18.0,
  //                                       // color: Color(0xFF0C387D),
  //                                       color: Theme.of(context).primaryColor,
  //                                       fontFamily: 'Kanit',
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   Text(
  //                                     'ผู้ให้บริการ',
  //                                     style: TextStyle(
  //                                       fontSize: 24.0,
  //                                       color: Theme.of(context).primaryColor,
  //                                       fontFamily: 'Kanit',
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(width: 10),
  //                           const VerticalDivider(
  //                             thickness: 1,
  //                             endIndent: 0,
  //                             color: Color(0xFFD5E7D7),
  //                           ),
  //                           const SizedBox(width: 10),
  //                           GestureDetector(
  //                             onTap: () {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => MyQrCode(
  //                                     model: snapshot.data,
  //                                   ),
  //                                 ),
  //                               );
  //                             },
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(12),
  //                               ),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   QrImageView(
  //                                     data: qrUri.toString(),
  //                                     size: 80,
  //                                     backgroundColor: Colors.white,
  //                                     foregroundColor:
  //                                         Theme.of(context).primaryColor,
  //                                   ),
  //                                   Text(
  //                                     'my qrcode',
  //                                     style: TextStyle(
  //                                       fontSize: 11.0,
  //                                       color: Theme.of(context).primaryColor,
  //                                       fontFamily: 'Kanit',
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     } else {
  //                       return Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 20, horizontal: 10),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(15),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               height: 60,
  //                               width: 60,
  //                               padding: const EdgeInsets.only(right: 10),
  //                               child: Image.asset(
  //                                 'assets/images/user_not_found.png',
  //                                 color: const Color(0XFF0C387D),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               child: Container(
  //                                 decoration: const BoxDecoration(
  //                                   border: Border(
  //                                     right: BorderSide(
  //                                       color: Color(0XFFD5E7D7),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 child: const Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       'ไม่พบข้อมูล',
  //                                       style: TextStyle(
  //                                         fontSize: 16.0,
  //                                         color: Color(0XFF0C387D),
  //                                         fontFamily: 'IBM Plex Mono',
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 10),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 Container(
  //                                   padding: const EdgeInsets.all(10.0),
  //                                   child: Image.asset(
  //                                     'assets/icons/qr_code.png',
  //                                     height: 33,
  //                                   ),
  //                                 ),
  //                                 const Text(
  //                                   'my qrcode',
  //                                   style: TextStyle(
  //                                     fontSize: 11.0,
  //                                     color: Color(0XFF59ACD4),
  //                                     fontFamily: 'IBM Plex Mono',
  //                                     fontWeight: FontWeight.w500,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     }
  //                   } else if (snapshot.hasError) {
  //                     return BlankLoading(
  //                       width: null,
  //                       height: null,
  //                     );
  //                   } else {
  //                     return Container(
  //                       padding: const EdgeInsets.symmetric(
  //                           vertical: 20, horizontal: 10),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(15),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Container(
  //                             height: 60,
  //                             width: 60,
  //                             padding: const EdgeInsets.only(right: 10),
  //                             child: Image.asset(
  //                               'assets/images/user_not_found.png',
  //                               color: const Color(0XFF0C387D),
  //                             ),
  //                           ),
  //                           Expanded(
  //                             child: Container(
  //                               // color: Colors.red,
  //                               decoration: const BoxDecoration(
  //                                 border: Border(
  //                                   right: BorderSide(
  //                                     color: Color(0XFFD5E7D7),
  //                                   ),
  //                                 ),
  //                               ),
  //                               child: const Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     'กำลังโหลด',
  //                                     style: TextStyle(
  //                                       fontSize: 16.0,
  //                                       color: Color(0XFF0C387D),
  //                                       fontFamily: 'IBM Plex Mono',
  //                                       fontWeight: FontWeight.w600,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const SizedBox(width: 10),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 padding: const EdgeInsets.all(10.0),
  //                                 child: Image.asset(
  //                                   'assets/icons/qr_code.png',
  //                                   height: 33,
  //                                 ),
  //                               ),
  //                               const Text(
  //                                 'my qrcode',
  //                                 style: TextStyle(
  //                                   fontSize: 11.0,
  //                                   color: Color(0XFF27544F),
  //                                   fontFamily: 'IBM Plex Mono',
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   }
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _buildMenuOld() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.symmetric(horizontal: 20),
  //     child: ListView(
  //       children: [
  //         _buildBanner(),
  //         _buildCurrentLocationBar(),
  //         // SizedBox(height: 1),
  //         _buildProfile(),
  //         _buildVerifyTicket(),
  //         _buildDispute(),
  //         SizedBox(height: 5),
  //         // _buildGridMenu1(),
  //         // SizedBox(height: 1),
  //         // _buildGridMenu2(),
  //         _buildRotation(),
  //         SizedBox(height: 5),
  //         _buildCardFirst(),
  //         _buildCardSecond(),
  //         _buildCardThird(),
  //         _buildRotation(),
  //         _buildFooter(),
  //       ],
  //     ),
  //   );
  // }

  // _buildHeader() {
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(70 + MediaQuery.of(context).padding.top),
  //     child: AppBar(
  //       flexibleSpace: Container(
  //         width: double.infinity,
  //         // height: double.infinity,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage('assets/background/background_header.png'),
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Text(
  //               'สำนักงานตำรวจแห่งชาติ',
  //               style: TextStyle(
  //                   fontSize: 22.0, color: Colors.white, fontFamily: 'Mitr'),
  //             ),
  //             SizedBox(
  //               height: 10,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.end,
  //               children: [
  //                 Expanded(
  //                   child: Container(
  //                     padding: EdgeInsets.all(5),
  //                     alignment: Alignment.centerLeft,
  //                     height: 50,
  //                     child: Image.asset(
  //                       'assets/logo/headlogo.png',
  //                     ),
  //                   ),
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => NotificationList(
  //                           title: 'แจ้งเตือน',
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   child: Container(
  //                     height: 30,
  //                     child: Image.asset('assets/icons/bell.png'),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 InkWell(
  //                   onTap: () async {
  //                     final msg = await Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => UserInformationPage(),
  //                       ),
  //                     );
  //                     if (!msg) {
  //                       _read();
  //                     }
  //                   },
  //                   child: FutureBuilder<dynamic>(
  //                     future: _futureProfile,
  //                     builder: (BuildContext context,
  //                         AsyncSnapshot<dynamic> snapshot) {
  //                       if (snapshot.hasData) {
  //                         if (profileCode == snapshot.data['code']) {
  //                           return Container(
  //                             height: 50,
  //                             padding: EdgeInsets.only(right: 10),
  //                             child: checkAvatar(
  //                                 context, '${snapshot.data['imageUrl']}'),
  //                           );
  //                         } else {
  //                           return BlankLoading(
  //                             width: 20,
  //                             height: 20,
  //                           );
  //                         }
  //                       } else if (snapshot.hasError) {
  //                         return BlankLoading(
  //                           width: null,
  //                           height: null,
  //                         );
  //                       } else {
  //                         return BlankLoading(
  //                           width: null,
  //                           height: null,
  //                         );
  //                       }
  //                     },
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _buildDispute() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DisputeAnAllegation(),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       height: 120,
  //       padding: EdgeInsets.symmetric(horizontal: 25),
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Colors.grey,
  //         image: DecorationImage(
  //           // image: NetworkImage('${model['imageUrl']}'),
  //           image: AssetImage('assets/background/background_dispute.png'),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text(
  //                   'ยื่นอุทธรณ์',
  //                   style: TextStyle(
  //                     fontFamily: 'Sarabun',
  //                     color: Colors.white,
  //                     fontSize: 16.0,
  //                   ),
  //                   maxLines: 1,
  //                   overflow: TextOverflow.fade,
  //                 ),
  //                 Text(
  //                   '(Dispute)',
  //                   style: TextStyle(
  //                       fontFamily: 'Sarabun',
  //                       color: Colors.white,
  //                       fontSize: 15.0),
  //                 ),
  //                 SizedBox(height: 5),
  //                 Text(
  //                   'สำนักงานตำรวจแห่งชาติอำนวยความสะดวกให้ท่าน สามารถตรวจสอบใบสั่งย้อนหลังได้สูงสุด 1 ปี',
  //                   style: TextStyle(
  //                     fontFamily: 'Sarabun',
  //                     color: Colors.white,
  //                     fontSize: 11.0,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _buildCardFirst() {
  //   return Container(
  //     height: 125,
  //     color: Colors.white,
  //     child: Row(
  //       children: [
  //         imageItem('ข่าวประชาสัมพันธ์', '(News)',
  //             'assets/background/news_background.png', 2, titleStart: true,
  //             callback: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => NewsList(
  //                 title: 'ข่าวประชาสัมพันธ์',
  //               ),
  //             ),
  //           );
  //         }),
  //         imageItem(
  //             'เบอร์โทรฉุกเฉิน', '(SOS)', 'assets/background/hotline.png', 1,
  //             callback: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ContactListCategory(
  //                 title: 'เบอร์โทรฉุกเฉิน',
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  // _buildCardSecond() {
  //   return Container(
  //     height: 125,
  //     color: Colors.white,
  //     child: Row(
  //       children: [
  //         colorItem('ปฏิทินกิจกรรม', '(Calendar)',
  //             'assets/icons/icon_calendar.png', 1, callback: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => EventCalendarMain(
  //                 title: 'ปฏิทินกิจกรรม',
  //               ),
  //             ),
  //           );
  //         }),
  //         imageItem('ความรู้คู่การขับขี่', '(Driving Knowledge)',
  //             'assets/background/info_background.png', 2, callback: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => KnowledgeList(
  //                 title: 'ความรู้คู่การขับขี่',
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  // _buildCardThird() {
  //   return Container(
  //     height: 125,
  //     color: Colors.white,
  //     child: Row(
  //       children: [
  //         imageItem(
  //           'จุดบริการ',
  //           '(Service Station)',
  //           'assets/background/service_background.png',
  //           2,
  //           callback: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => PoiList(
  //                   title: 'จุดบริการ',
  //                   latLng: latLng,
  //                   key: null,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         colorItem(
  //             'ติดต่อเรา', '(Contact us)', 'assets/images/icon_info.png', 1,
  //             linearGradient: LinearGradient(
  //               colors: [
  //                 Color(0xFF5B1800),
  //                 Color(0xFF5B1800),
  //               ],
  //               begin: Alignment.centerRight,
  //               end: Alignment.centerLeft,
  //             ), callback: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => AboutUsForm(
  //                 model: _futureAboutUs,
  //                 title: 'ติดต่อเรา',
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  // _buildVerifyTicket() {
  //   return VerifyTicket(
  //     model: _futureVerifyTicket,
  //   );
  // }

  _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CarouselBanner(
        model: _futureBanner,
        nav: (String path, String action, dynamic model, String code,
            String urlGallery) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
            // launchURL(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarouselForm(
                  code: code,
                  model: model,
                  url: mainBannerApi,
                  urlGallery: bannerGalleryApi,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // _buildCurrentLocationBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         // color: Color(0xFF000070),
  //         // padding: EdgeInsets.symmetric(horizontal: 5),
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.only(left: 10),
  //         child: Row(
  //           children: [
  //             Icon(Icons.credit_card),
  //             Text(
  //               ' ใบอนุญาตขับขี่',
  //               style: TextStyle(
  //                 fontFamily: 'Sarabun',
  //                 // fontSize: 10,
  //                 // color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         // color: Color(0xFF000070),
  //         // padding: EdgeInsets.symmetric(horizontal: 5),
  //         alignment: Alignment.center,
  //         padding: EdgeInsets.only(right: 10),
  //         height: 40,
  //         child: Row(
  //           children: [
  //             Icon(
  //               Icons.pin_drop,
  //               color: Colors.orange[400],
  //             ),
  //             Text(
  //               ' ' + currentLocation,
  //               style: TextStyle(
  //                 fontFamily: 'Sarabun', color: Colors.orange[400],
  //                 // fontSize: 10,
  //                 // color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  _buildPrivilegeMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[7]['title'] != ''
                  ? snapshot.data[7]['title']
                  : '',
              imageUrl: snapshot.data[7]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivilegeMain(
                      title: snapshot.data[7]['title'],
                      fromPolicy: false,
                    ),
                  ),
                );
                // if (!checkDirection) {
                //   _showDialogDirection();
                // } else if (_dataPolicy.length > 0) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PolicyPrivilege(
                //         title: snapshot.data[4]['title'],
                //         username: userData.username,
                //         fromPolicy: true,
                //       ),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PrivilegeMain(
                //         title: snapshot.data[7]['title'],
                //         fromPolicy: false,
                //       ),
                //     ),
                //   );
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildContactMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[6]['title'] != ''
                  ? snapshot.data[6]['title']
                  : '',
              imageUrl: snapshot.data[6]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactListCategory(
                      title: snapshot.data[6]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ContactListCategory(
                //         title: snapshot.data[6]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildPoiMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[8]['title'] != ''
                  ? snapshot.data[8]['title']
                  : '',
              imageUrl: snapshot.data[8]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoiList(
                      title: snapshot.data[8]['title'],
                      latLng: null,
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PoiList(
                //         title: snapshot.data[8]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildPollMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[9]['title'] != ''
                  ? snapshot.data[9]['title']
                  : '',
              imageUrl: snapshot.data[9]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollList(
                      title: snapshot.data[9]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PollList(
                //         title: snapshot.data[9]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildFooter() {
    return Container(
      // height: 70,
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      child: Image.asset(
        'assets/background/background_mics_webuilds.png',
        fit: BoxFit.cover,
      ),
    );
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

  // mainFooter() {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Container(
  //     height: height * 15 / 100,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Color(0xFFFF7514),
  //           Color(0xFFF7E834),
  //         ],
  //         begin: Alignment.topLeft,
  //         end: new Alignment(1, 0.0),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           alignment: Alignment.center,
  //           child: Text(
  //             userData.status == 'N'
  //                 ? 'ท่านยังไม่ได้ยืนยันตัวตน กรุณายืนยันตัวตน'
  //                 : 'ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
  //             style: TextStyle(
  //               // color: Colors.white,
  //               fontFamily: 'Sarabun',
  //               fontSize: 13,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: height * 1.5 / 100,
  //         ),
  //         userData.status == 'N'
  //             ? Container(
  //                 margin: EdgeInsets.symmetric(horizontal: width * 34 / 100),
  //                 height: height * 6 / 100,
  //                 child: Material(
  //                   elevation: 5.0,
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5.0),
  //                       color: Theme.of(context).primaryColorDark,
  //                     ),
  //                     child: MaterialButton(
  //                       minWidth: MediaQuery.of(context).size.width,
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => IdentityVerificationPage(),
  //                           ),
  //                         );
  //                       },
  //                       child: Text(
  //                         'ยืนยันตัวตน',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontFamily: 'Sarabun',
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }

  List<Map<String, dynamic>> mockCourse = [
    {
      "title": "หลักสูตรนวดฝ่าเท้าเพื่อสุขภาพ",
      "category": "นวดเท้า",
      "price": "350",
      "time": "20 ชั่วโมง",
      "img": "assets/ihealth/bg.jpg",
      "description":
          "เรียนรู้เทคนิคการนวดฝ่าเท้าเพื่อกระตุ้นระบบไหลเวียนโลหิต บรรเทาอาการเมื่อยล้า และเพิ่มความผ่อนคลายให้กับร่างกาย",
    },
    {
      "title": "หลักสูตรนวดแผนไทยขั้นพื้นฐาน",
      "category": "นวดแผนไทย",
      "price": "1,800",
      "time": "30 ชั่วโมง",
      "img": "assets/ihealth/bg.jpg",
      "description":
          "ศึกษาเทคนิคการนวดแผนไทยแบบดั้งเดิม เช่น การกดจุด การยืดเส้น เพื่อบรรเทาอาการปวดเมื่อย และฟื้นฟูสุขภาพร่างกาย",
    },
    {
      "title": "หลักสูตรนวดน้ำมันอโรม่า",
      "category": "นวดอโรม่า",
      "price": "2,500",
      "time": "40 ชั่วโมง",
      "img": "assets/ihealth/bg.jpg",
      "description":
          "ฝึกทักษะการนวดผ่อนคลายด้วยน้ำมันหอมระเหย พร้อมเทคนิคการสร้างบรรยากาศที่ช่วยให้ลูกค้ารู้สึกผ่อนคลายทั้งกายและใจ",
    },
  ];

  final List<Map<String, dynamic>> jobList = [
    {
      "id": 1,
      "imgUrl":
          "https://img.wongnai.com/p/1920x0/2018/06/30/f73e248f9f9647938f00c183508ca277.jpg",
      "title": "หมอนวดแผนไทย",
      "company": "ร้านนวดไทยดี",
      "type": "นวดเพื่อสุขภาพ",
      "location": "กรุงเทพฯ",
      "salary": "12,000 - 18,000 บาท",
      "working_hours": "10.00 - 20.00 น.",
      "postedDate": "25/07/2025",
    },
    {
      "id": 2,
      "imgUrl":
          "https://thethaiger.com/th/wp-content/uploads/2023/04/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%99%E0%B8%A7%E0%B8%94-diora.jpg",
      "title": "หมอนวดสปา",
      "company": "Wellness Spa Chiang Mai",
      "type": "บริการเพื่อความงาม",
      "location": "เชียงใหม่",
      "salary": "15,000 - 22,000 บาท",
      "working_hours": "09.00 - 19.00 น.",
      "postedDate": "25/07/2025",
    },
  ];
}
