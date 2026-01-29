import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_confirm.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_coupon.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_shop.dart';
import 'package:ihealth_2025_mobile/client/review.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetail extends StatefulWidget {
  final String? massage_info_id;
  final String? booking_date;
  final String? province;

  const BookingDetail({
    required this.massage_info_id,
    required this.booking_date,
    required this.province,
    super.key,
  });

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay parse(String input) {
    final parts = input.split(":");
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class _BookingDetailState extends State<BookingDetail> {
  String? selectedCategory;
  String? selectedCourse;
  bool isSelectedTherapist = false;

  dynamic massageInfo;
  List filteredMassageLists = [];

  Map<String, dynamic> toggle = {};
  String? massage_info_id;
  String? booking_date;
  String? massageBookingDate;
  String? selectedService;
  Map<String, dynamic> servicesLists = {};
  List<dynamic> therapistsWorkList = [];
  List<dynamic> therapistWorks = [];

  List<dynamic> therapists = [];
  List<Map<String, dynamic>> allServices = [];

  int currentTab = 1;
  Map<String, dynamic>? selectedServiceData;
  dynamic selectedDuration;
  String? selectedTherapist;

  TextEditingController startTimeCtrl = TextEditingController();
  TextEditingController endTimeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    massage_info_id = widget.massage_info_id;
    booking_date = widget.booking_date;
    callRead();
  }

  callRead() async {
    final url = '$api/api/v1/customer/detail-massage'
        '?booking_date=$booking_date'
        '&massage_info_id=$massage_info_id';
    print('###############');
    print(url);
    final v = await get(url);

    if (v == null) return;

    setState(() {
      massageInfo = v['massage_info'] ?? {};
      massageBookingDate = v['booking_date'] ?? '';
      servicesLists = v['services_lists'] ?? {};

      therapistsWorkList = v['therapists_work'] ?? [];

      // 👉 รวม service ทั้งหมด
      allServices.clear();
      servicesLists.forEach((cat, list) {
        for (var s in list) {
          allServices.add(s);
        }
      });
    });
  }

  _toggleFavorite() async {
    // print('------ Adding to favorites... ------');
    // final storage = FlutterSecureStorage();
    // final token = await storage.read(key: 'token');
    // var headers = {'Authorization': 'Bearer $token'};

    // final dioService = DioService();
    // await dioService.init();
    // final dio = dioService.dio;
    // final cookieJar = dioService.cookieJar;

    // var cookies = await cookieJar.loadForRequest(
    //   Uri.parse('https://api-ihealth.spl-system.com'),
    // );
    // print("Cookies: $cookies");
    // var data = json
    //     .encode({"massage_info_id": "645c9a68-d89f-41e9-b9d9-414e25c04a7e"});

    // var response = await dio.request(
    //   'https://api-ihealth.spl-system.com/api/v1/customer/favorites',
    //   options: Options(
    //     method: 'POST',
    //     headers: headers,
    //   ),
    //   data: data,
    // );

    // if (response.statusCode == 200) {
    //   print('✅ Added to favorites successfully');

    //   setState(() {
    //     toggle = response.data['data'];
    //   });
    //   SnackBar snackBar = SnackBar(
    //     backgroundColor: toggle['isFavorite'] ? Colors.green : Colors.red,
    //     content: toggle['isFavorite']
    //         ? Text(' เพิ่มลงรายการโปรดเรียบร้อยแล้ว')
    //         : Text(' ลบออกจากรายการโปรดเรียบร้อยแล้ว'),
    //     duration: Duration(seconds: 2),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // } else {
    //   print(response.statusMessage);
    // }

    final res = await post(
      "$api/api/v1/customer/favorites",
      {
        "massage_info_id": massage_info_id,
      },
    );

    setState(() {
      massageInfo['is_favorite'] = !(massageInfo['is_favorite'] ?? false);
    });
  }

  Widget buildInfoRow(String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 6,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(value, textAlign: TextAlign.right),
              ),
            ),
          ],
        ),
        const Divider(thickness: 1, height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (massageInfo == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("จองบริการนวด"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปโปรไฟล์ร้าน (tap → fullscreen)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullscreenImage(
                      imageUrl: "$api/${massageInfo['image']}",
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "$api/${massageInfo['image']}",
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // แกลเลอรีรูป
            Container(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: massageInfo['images']?.length ?? 0,
                itemBuilder: (context, index) {
                  final imgUrl = "$api/${massageInfo['images'][index]}";
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullscreenImage(imageUrl: imgUrl),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imgUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    massageInfo["massage_name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'คะแนนรีวิว:',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ReviewPage()),
                          // );
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "${massageInfo["avg_score"]} (${massageInfo["review_count"]} รีวิว)",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      Text(
                        'รายละเอียด:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 40),
                      // Content
                      Expanded(
                        child: Text(
                          massageInfo["details"] ?? "-",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.45, // ระยะห่างบรรทัดให้อ่านง่าย
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'วันเปิดทำการ:',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(massageInfo["day_of_week_text"],
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'เวลาเปิด - ปิด:',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(massageInfo["time_text"],
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Section Booking
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: Color(0xFF07663a), width: 4),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title row
                  Row(
                    children: const [
                      Icon(Icons.access_time,
                          color: Color(0xFF07663a), size: 20),
                      SizedBox(width: 6),
                      Text(
                        "รายละเอียดการจองเบื้องต้น",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF07663a),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // วัน
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text(
                        "วันที่จอง:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                        massageBookingDate ?? "",
                      )),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ปุ่ม

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final url = massageInfo['mapLink'];
                        if (url != null && url.toString().isNotEmpty) {
                          launchUrl(Uri.parse(url));
                        }
                      },
                      icon: const Icon(Icons.map),
                      label: const Text(
                        "ดูตำแหน่งร้าน",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: massageInfo?['is_favorite'] == true
                            ? const Color.fromARGB(
                                255, 174, 5, 5) // ถ้าเคย fav = ปุ่มสีเทา
                            : Colors.red, // ถ้ายังไม่ fav = เขียวหลัก
                      ),
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        massageInfo?['is_favorite'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      label: Text(
                        massageInfo?['is_favorite'] == true
                            ? "เอาออกจากรายการโปรด"
                            : "เพิ่มลงรายการโปรด",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            massageInfo['is_open'] == false // true: ร้านเปิด  false: ร้านปิด
                ? SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D4D),
                        foregroundColor: Colors.white, // สีตัวอักษร
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0, // แบบ flat
                      ),
                      child: const Text(
                        "ร้านปิดทำการ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : currentTab == 1
                    ? _tab1()
                    : _tab2(),

            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildSelection(),
            //     ),
            //     const SizedBox(width: 10),
            //     TextButton.icon(
            //       onPressed: () {
            //         setState(() {
            //           selectedService = null;
            //         });
            //       },
            //       style: TextButton.styleFrom(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 14, vertical: 17),
            //         foregroundColor: const Color(0xFF07663a),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //           side: const BorderSide(
            //               color: Color(0xFF07663a), width: 1.5),
            //         ),
            //       ),
            //       icon: const Icon(Icons.refresh_rounded),
            //       label: const Text(
            //         "ล้างข้อมูล",
            //         style: TextStyle(fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20),
            // _buildServiceCards(),
            // SizedBox(height: 100),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Color(0xFFe0e0e0),
            //             padding: const EdgeInsets.symmetric(
            //                 vertical: 14), // ✅ เพิ่มความสูง
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => BookingShopPage(
            //                         province: '',
            //                         booking_date: '',
            //                       )),
            //             );
            //           },
            //           label: const Text(
            //             "ย้อนกลับ",
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Color(0xFF494949),
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Color(0xFF07663a),
            //             padding: const EdgeInsets.symmetric(vertical: 14),
            //           ),
            //           onPressed: () {
            //             if (selectedCourse == null || selectedCourse!.isEmpty) {
            //               showCenterDialog(
            //                 context,
            //                 title: "ยังไม่ได้เลือกบริการ",
            //                 message: "กรุณาเลือกประเภทบริการ",
            //               );
            //               return;
            //             }
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => BookingConfirm()),
            //             );
            //           },
            //           label: const Text(
            //             "ถัดไป",
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  _buildSelection() {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        labelText: "เลือกบริการ",
        prefixIcon: Icon(Icons.spa, color: Color(0xFF07663a)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      isExpanded: true,
      value: selectedService,
      items: allServices.map((service) {
        return DropdownMenuItem<String>(
          value: service['service_list_id'],
          child: Row(
            children: [
              Expanded(child: Text(service['name_service'])),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedService = value;
        });
      },
      dropdownStyleData: const DropdownStyleData(maxHeight: 420),
    );
  }

  Widget _buildServiceCards() {
    List<Widget> widgets = [];

    if (selectedService == null) {
      servicesLists.forEach((cat, list) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              cat,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        );

        widgets.add(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: list.map<Widget>((srv) {
                return _buildServiceCard(srv);
              }).toList(),
            ),
          ),
        );

        widgets.add(const SizedBox(height: 12));
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }

    final service = allServices.firstWhere(
      (e) => e['service_list_id'] == selectedService,
      orElse: () => {},
    );

    return Column(
      children: [
        _buildServiceCard(service),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> s) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCourse = s["service_list_id"];
        });
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedCourse == s["service_list_id"]
                ? Color(0xFF07663a)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูป
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  "$api/${s["image"]}",
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // เนื้อหา
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s["name_service"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("${s["price"]} บาท • ${s["minutes"]} นาที"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCourse = s["service_list_id"];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCourse == s["service_list_id"]
                            ? const Color(0xFF07663a)
                            : Colors.grey[700],
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        selectedCourse == s["service_list_id"]
                            ? "✓ เลือกแล้ว"
                            : "เลือก",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCenterDialog(BuildContext context,
      {required String title, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false, // บังคับให้กดปุ่ม
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFB3261E),
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFF07663a),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Row(
          children: [
            Expanded(child: _buildSelection()),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: () {
                setState(() => selectedService = null);
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                foregroundColor: const Color(0xFF07663a),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFF07663a), width: 1.5),
                ),
              ),
              icon: Icon(Icons.refresh_rounded),
              label: Text("ล้างข้อมูล"),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildServiceCards(),
        SizedBox(height: 20),
        _bottomButtons(),
      ],
    );
  }

  Widget _tab2() {
    if (selectedServiceData == null) {
      return const Center(
        child: Text("ยังไม่ได้เลือกบริการ"),
      );
    }

    if (selectedServiceData != null) {
      final durations = selectedServiceData!["durations"];
      if (durations.isNotEmpty) {
        selectedDuration = durations.first;
      }
    }

    final String nameService = selectedServiceData!["name_service"];
    final int price = selectedServiceData!["price"];
    final int minutes = selectedServiceData!["minutes"];

    final List durations = selectedServiceData!["durations"];
    therapists = selectedServiceData!["therapists_list"];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // หัวข้อ
          const Text(
            "เลือผู้ให้บริการ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF07663a),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Text(
                "บริการที่เลือก : ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                nameService,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (selectedTherapist != null)
            OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  builder: (_) => TherapistScheduleSheet(context),
                );
              },
              icon: Icon(Icons.calendar_month, color: Color(0xFF07663a)),
              label: Text("ดูตารางงาน"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF07663a),
                side: BorderSide(color: Color(0xFF07663a), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          const SizedBox(height: 15),

          Text(
            "เลือกผู้ให้บริการ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // ถ้ามี therapist
          if (therapists.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: therapists.map((t) {
                  bool isSelected = selectedTherapist == t["therapist_info_id"];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTherapist = t["therapist_info_id"];
                        filteredTherapistWork();
                      });
                    },
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Color(0xFF07663a)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage("$api/${t["image"]}"),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t["fullname"],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12)),
              child: const Text(
                "ไม่มีตารางงานในวันนี้",
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 25),

          /// -----------------------------
          /// 3️⃣ Section Duration
          /// -----------------------------
          Text(
            "เลือกเวลานวด",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          DropdownButtonFormField(
            value: selectedDuration,
            isExpanded: true,
            items: durations.map((d) {
              return DropdownMenuItem(
                value: d,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${d["minutes"]} นาที"),
                    Text(
                      "${d["price"]} บาท",
                      style: const TextStyle(color: Color(0xFF07663a)),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) {
              setState(() {
                selectedDuration = v;

                /// คำนวณเวลาสิ้นสุดใหม่ (ถ้าเลือกเวลาแล้ว)
                if (startTimeCtrl.text.isNotEmpty &&
                    v is Map &&
                    v["minutes"] != null) {
                  final start = TimeOfDayExtension.parse(startTimeCtrl.text);
                  final mins = v["minutes"] as int;
                  endTimeCtrl.text = addMinutes(start, mins);
                }
              });
            },
          ),

          const SizedBox(height: 25),
          Text("เวลาจอง", style: TextStyle(fontSize: 15)),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: startTimeCtrl,
                  decoration: const InputDecoration(
                    labelText: "เริ่ม",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => pickTime("start"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  readOnly: true,
                  // enabled: false,
                  controller: endTimeCtrl,
                  decoration: const InputDecoration(
                    labelText: "สิ้นสุด",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _bottomButtons(),
        ],
      ),
    );
  }

  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFe0e0e0),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (currentTab == 1) {
                  // กลับหน้าแรก
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingShopPage(
                        province: widget.province,
                        booking_date: booking_date,
                      ),
                    ),
                  );
                } else {
                  // Tab2 → Tab1
                  setState(() => currentTab = 1);
                }
              },
              child: Text(
                currentTab == 1 ? "ย้อนกลับ" : "ย้อนกลับ",
                style: TextStyle(
                  color: Color(0xFF494949),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF07663a),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (currentTab == 1) {
                  /// ต้องเลือกก่อน
                  if (selectedCourse == null) {
                    showCenterDialog(
                      context,
                      title: "ยังไม่ได้เลือกบริการ",
                      message: "กรุณาเลือกประเภทบริการ",
                    );
                    return;
                  }
                  findSelectedService();
                  setState(() => currentTab = 2);
                } else {
                  if (selectedTherapist == null) {
                    showCenterDialog(
                      context,
                      title: "ยังไม่ได้เลือกผู้ให้บริการ",
                      message: "กรุณาเลือกผู้ให้บริการ",
                    );
                    return;
                  }

                  final bookingData = {
                    "booking_date": booking_date,
                    "discount": 0,
                    "discount_type": "",
                    "end_time": endTimeCtrl.text,
                    "massage_duration": selectedDuration['minutes'],
                    "massage_info_id": massageInfo['uuid'],
                    "price": selectedDuration['price'],
                    "price_total": selectedDuration['price'],
                    "promotion_id": "",
                    "service_list_id":
                        selectedServiceData?['service_list_id'] ?? '',
                    "name_service": selectedServiceData?['name_service'] ?? '',
                    "category_sub": selectedServiceData?['category_sub'] ?? '',
                    "start_time": startTimeCtrl.text,
                    "therapist_info_id": therapists[0]['therapist_info_id'],
                    "therapist_fullname": therapists[0]['fullname'],
                    "image": massageInfo['image'],
                    "massageDate": massageBookingDate,
                    "massage_name": massageInfo['massage_name'],
                    "avg_score": massageInfo['avg_score'],
                    "review_count": massageInfo['review_count'],
                    "province": widget.province,
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingConfirm(model: bookingData),
                    ),
                  );
                }
              },
              child: Text(
                currentTab == 1 ? "ถัดไป" : "ถัดไป",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void findSelectedService() {
    selectedServiceData = null;

    servicesLists.forEach((cat, list) {
      for (var s in list) {
        if (s["service_list_id"] == selectedCourse) {
          selectedServiceData = s;
          break;
        }
      }
    });
  }

  Future pickTime(String type) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (time == null) return;

    setState(() {
      startTimeCtrl.text = time.format(context);

      if (selectedDuration != null) {
        int mins = selectedDuration["minutes"];
        endTimeCtrl.text = addMinutes(time, mins);
      }
    });
  }

  String addMinutes(TimeOfDay start, int minutes) {
    final now = DateTime.now();
    final startDt = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );

    final result = startDt.add(Duration(minutes: minutes));

    return TimeOfDay(
      hour: result.hour,
      minute: result.minute,
    ).format(context);
  }

  Widget TherapistScheduleSheet(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      minChildSize: 0.35,
      maxChildSize: 0.90,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              color: Colors.black12,
            )
          ],
        ),
        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 4,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              "ตารางงานวันนี้",
              style: const TextStyle(
                color: Color(0xFF07663a),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: therapistWorks.isEmpty
                  ? _buildEmptySchedule()
                  : ListView.builder(
                      controller: controller,
                      itemCount: therapistWorks.length,
                      padding: EdgeInsets.only(bottom: 12),
                      itemBuilder: (_, i) => _buildBusyCard(therapistWorks[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusyCard(Map w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.withOpacity(0.05),
        border: Border.all(color: Colors.red.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.block, color: Colors.red[600]),
          const SizedBox(width: 10),
          Text(
            "${w["start"]} – ${w["end"]}",
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available,
              size: 60, color: Colors.grey.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(
            "วันนี้ไม่มีตารางงาน 🎉",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  filteredTherapistWork() {
    therapistWorks = therapistsWorkList.firstWhere(
        (x) => x["therapist_info_id"] == selectedTherapist,
        orElse: () => {"works": []})["works"];
  }

  // Widget buildTherapistSheet() {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height * 0.6, // ครึ่งจอ
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Center(
  //             child: Container(
  //               width: 40,
  //               height: 4,
  //               margin: EdgeInsets.only(bottom: 16),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade300,
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //           ),
  //           Text(
  //             "เลือกหมอนวด",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 16),
  //           Expanded(
  //             child: ListView.separated(
  //               itemCount: therapists.length,
  //               separatorBuilder: (_, __) => SizedBox(height: 12),
  //               itemBuilder: (context, index) {
  //                 final t = therapists[index];
  //                 isSelectedTherapist = selectedTherapist == t["name"];
  //                 return GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       selectedTherapist = t["name"];
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                   child: AnimatedContainer(
  //                     duration: Duration(milliseconds: 300),
  //                     padding: EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: isSelectedTherapist
  //                           ? Colors.green[50]
  //                           : Colors.white,
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(
  //                         color: isSelectedTherapist
  //                             ? Color(0xFF07663a)
  //                             : Colors.grey,
  //                         width: 2,
  //                       ),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12,
  //                           blurRadius: 5,
  //                           offset: Offset(2, 3),
  //                         )
  //                       ],
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         CircleAvatar(
  //                           radius: 28,
  //                           backgroundImage: NetworkImage(t["image"]!),
  //                         ),
  //                         SizedBox(width: 16),
  //                         Expanded(
  //                           child: Text(
  //                             t["name"]!,
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: isSelectedTherapist
  //                                   ? FontWeight.bold
  //                                   : FontWeight.normal,
  //                               color: isSelectedTherapist
  //                                   ? Color(0xFF07663a)
  //                                   : Colors.black87,
  //                             ),
  //                           ),
  //                         ),
  //                         if (isSelectedTherapist)
  //                           Icon(Icons.check_circle, color: Color(0xFF07663a)),
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  reset() {}
}

class FullscreenImage extends StatelessWidget {
  final String imageUrl;
  const FullscreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
