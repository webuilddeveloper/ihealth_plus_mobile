import 'package:ihealth_2025_mobile/client/notification/notification_client_form.dart';
import 'package:ihealth_2025_mobile/home_v2.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/pages/warning/warning_form.dart';
import 'package:ihealth_2025_mobile/pages/welfare/welfare_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/blank_loading.dart';
import 'package:ihealth_2025_mobile/pages/blank_page/toast_fail.dart';

import 'package:ihealth_2025_mobile/pages/knowledge/knowledge_form.dart';
import 'package:ihealth_2025_mobile/pages/news/news_form.dart';
import 'package:ihealth_2025_mobile/pages/poi/poi_form.dart';
import 'package:ihealth_2025_mobile/pages/poll/poll_form.dart';
import 'package:ihealth_2025_mobile/pages/privilege/privilege_form.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/shared/api_provider_ihealth.dart';
import 'package:ihealth_2025_mobile/shared/extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationClientList extends StatefulWidget {
  NotificationClientList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NotificationClientList createState() => _NotificationClientList();
}

class _NotificationClientList extends State<NotificationClientList> {
  Future<Map<String, dynamic>?>? _futureModel;

  @override
  void initState() {
    super.initState();
    _futureModel = _callRead();
  }

  Future<Map<String, dynamic>?> _callRead() async {
    try {
      final apiProvider = await ApiProviderIhealth.getInstance();
      var response = await apiProvider.get('v1/notify?role=customer');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching notifications: $e");
      return null;
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureModel,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            print('-----------${snapshot.data}');
            // แก้ไขการเข้าถึงข้อมูลให้ถูกต้อง
            final List<dynamic> notifications =
                snapshot.data?['data']?['notifications'] ?? [];

            if (notifications.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(), // 2nd
                // scrollDirection: Axis.horizontal,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  // ส่งข้อมูล notification ไปยัง card
                  return card(context, notifications[index]);
                },
              );
            } else {
              return Container(
                width: width,
                margin: EdgeInsets.only(top: height * 30 / 100),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: width,
                      child: Image.asset(
                        'assets/logo/logo_main.png',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 1 / 100),
                      alignment: Alignment.center,
                      width: width,
                      child: Text(
                        'ไม่พบข้อมูล',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Container(
              width: width,
              height: height,
              child: InkWell(
                onTap: () {
                  // โหลดข้อมูลใหม่เมื่อกด refresh
                  setState(() => _futureModel = _callRead());
                },
                child: Icon(Icons.refresh, size: 50.0, color: Colors.blue),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true, // 1st add
              physics: ClampingScrollPhysics(), // 2nd
              // scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return BlankLoading(
                  width: width,
                  height: height * 15 / 100,
                );
              },
            );
          }
        },
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationClientForm(url: '', code: '', urlComment: '', urlGallery: '',),
          ),
        ).then((value) => {_futureModel = _callRead()})
      },
      child: Slidable(
        // fixflutter2 actionPane: SlidableDrawerActionPane(),
        // fixflutter2 actionExtentRatio: 0.25,

        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.2 / 100),
          height: (height * 15) / 100,
          width: width,
          decoration: BoxDecoration(
            color: model['is_read'] ? Colors.white : Color(0xFFE7E7EE),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 1 / 100, vertical: height * 1.2 / 100),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.7 / 100, right: width * 1 / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 1 / 100),
                        color: model['is_read'] ? Colors.white : Colors.red,
                      ),
                      height: height * 2 / 100,
                      width: height * 2 / 100,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontSize: (height * 2) / 100,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.normal,
                            color: Color(0xFFFF7514),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 5 / 100, vertical: height * 1.5 / 100),
                child: Text(
                  '${dateStringToDate(model['createdAt'])}',
                  style: TextStyle(
                    fontSize: (height * 1.7) / 100,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // fixflutter2 secondaryActions: <Widget>[
        //   IconSlideAction(
        //     caption: 'Delete',
        //     color: Colors.red,
        //     icon: Icons.delete,
        //     onTap: () => {
        //       setState(() {
        //         postAny('${notificationApi}delete', {
        //           'category': '${model['category']}',
        //           "code": '${model['code']}'
        //         }).then((response) {
        //           if (response == 'S') {
        //             setState(() {
        //               _futureModel = postDio(
        //                   '${notificationApi}read', {'skip': 0, 'limit': 999});
        //             });
        //           }
        //         });
        //       })
        //     },
        //   ),
        // ],
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('ตัวเลือก'),
          // message: Text(''),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {},
            ),
            CupertinoActionSheetAction(
              child: Text(
                'ลบทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {},
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('ยกเลิก',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
