import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_favorite.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_history.dart';
import 'package:ihealth_2025_mobile/client/home_client.dart';
import 'package:ihealth_2025_mobile/client/notification/notification_client_list.dart';
import 'package:ihealth_2025_mobile/ihealth/profile/user_information_client.dart';
import 'package:ihealth_2025_mobile/shared/api_provider_ihealth.dart';
import '../shared/api_provider.dart';

class MenuClient extends StatefulWidget {
  const MenuClient({Key? key, this.pageIndex, this.modelprofile})
      : super(key: key);

  final int? pageIndex;
  final modelprofile;

  @override
  MenuClientState createState() => MenuClientState();
}

class MenuClientState extends State<MenuClient> {
  DateTime? currentBackPressTime;
  dynamic futureNotificationTire;
  int notiCount = 0;
  int _currentPage = 0;
  // String _profileCode = '';
  // String _imageProfile = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];
  bool notShowOnDay = false;
  // int _currentBanner = 0;
  List<dynamic> _ListNotiModel = [];

  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };

  GlobalKey<BookingFavoritePageState> favoritePageKey =
      GlobalKey<BookingFavoritePageState>();
  GlobalKey<NotificationClientListState> notificationPageKey =
      GlobalKey<NotificationClientListState>();

  @override
  void initState() {
    // _callRead();
    _readProfile();
    callReadNoti();
    pages = <Widget>[
      HomeClient(
        changePage: _changePage,
      ),
      BookingHistoryPage(),
      NotificationClientList(title: 'แจ้งเตือน', key: notificationPageKey, onReadAll: readAll),
      BookingFavoritePage(key: favoritePageKey),
      UserInformationClientPage(changePage: _onItemTapped),
    ];
    onSetPage();

    super.initState();
  }

  void readAll() {
    print("=========== -------- readAll() ถูกเรียกจาก NotificationPage");
    callReadNoti();
  }

  // MyQrCode(),
  @override
  void dispose() {
    super.dispose();
  }

  callReadNoti() async {
    try {
      final apiProvider = await ApiProviderIhealth.getInstance();
      var response = await apiProvider.get('v1/notify?role=customer');
      var data = response.data as Map<String, dynamic>;
      if (data["statusCode"] == 200) {
        setState(() {
          notiCount = data["data"]["count"];
        });
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return null;
    }
  }

  _changePage(index) {
    setState(() {
      _currentPage = index;
    });

    if (index == 0) {
      _callRead();
    }
  }

  onSetPage() {
    setState(() {
      _currentPage = widget.pageIndex ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _currentPage == 0) {
        _callRead();
      }
      // เรียกฟังก์ชันในหน้า
      _currentPage = index;
    });
    callReadNoti();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (index == 2) {
        notificationPageKey.currentState?.readNotiFromExPage();
      }
      if (index == 3) {
        favoritePageKey.currentState?.callFavorite();
      }
    });
  }

  _callRead() async {
    await storage.read(key: 'fullname');
    await storage.read(key: 'gender');
    await storage.read(key: 'mobile');
    await storage.read(key: 'nationality');
    await storage.read(key: 'mapLink');
    await storage.read(key: 'image');
    // var img = await DCCProvider.getImageProfile();
    // _readNotiCount();
    // setState(() => _imageProfile = img);
    // setState(() {
    //   if (_profileCode != '') {
    //     pages[4] = profilePage;
    //   }
    // });
  }

  _readProfile() async {
    await storage.read(key: 'customer_id').then((cus_id) => {
          get(api + 'api/v1/customer/user/${cus_id}').then(
            (v) async {
              await storage.write(key: 'fullname', value: v["fullname"]);
              await storage.write(key: 'mobile', value: v["mobile"]);
              await storage.write(key: 'image', value: v["image"]);
              await storage.write(key: 'gender', value: v["gender"]);
            },
          ),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E1E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(
            index: _currentPage,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'กดอีกครั้งเพื่อออก',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBottomNavBar() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 65 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.10),
              blurRadius: 4,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, // กระจายไอคอนให้ห่างกัน
          children: [
            _buildTap(
              0,
              '',
              icon: 'assets/ihealth/icon/home.png',
              iconActive: 'assets/ihealth/icon/home_active.png',
            ),
            _buildTap(
              1,
              '',
              icon: 'assets/ihealth/calendar_icon.png',
              iconActive: 'assets/ihealth/calendar_icon_active.png',
            ),
            _buildTap(
              2,
              '',
              icon: 'assets/ihealth/icon/noti.png',
              iconActive: 'assets/ihealth/icon/noti_active.png',
              isNoti: true,
            ),
            _buildTap(
              3,
              '',
              icon: 'assets/ihealth/icon/heart1.png',
              iconActive: 'assets/ihealth/icon/heart_active.png',
            ),
            _buildTap(
              4,
              '',
              icon: 'assets/ihealth/icon/profile.png',
              iconActive: 'assets/ihealth/icon/profile_active.png',
              isNetwork: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int? index,
    String title, {
    bool isNetwork = false,
    bool isIconsData = false,
    bool isNoti = false,
    bool isLicense = false,
    String? icon,
    String? iconActive,
  }) {
    Color color = _currentPage == index ? Color(0xFF252120) : Color(0XFFA49E9E);

    return Flexible(
      flex: 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _onItemTapped(index!),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 5), // ✅ เพิ่ม Padding
              decoration: _currentPage == index
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.50),
                          blurRadius: 4,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLicense)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF662968),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        _currentPage == index ? iconActive! : icon!,
                        height: 30,
                        fit: BoxFit.contain,
                        width: 30,
                      ),
                    )
                  else if (isNoti)
                    Stack(
                      children: [
                        Image.asset(
                          _currentPage == index ? iconActive! : icon!,
                          height: 30,
                          width: 30,
                        ),
                        if (notiCount > 0)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFE40000),
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    Image.asset(
                      _currentPage == index ? iconActive! : icon!,
                      height: 30,
                      width: 30,
                    ),
                  const SizedBox(height: 5), // ✅ เพิ่มระยะห่างจากไอคอน
                  // Text(
                  //   title,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: color,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
