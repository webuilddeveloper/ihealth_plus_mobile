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

  const BookingDetail({
    required this.massage_info_id,
    required this.booking_date,
    super.key,
  });

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String? selectedCategory;
  String? selectedCourse;
  String? selectedTherapist;
  bool isSelectedTherapist = false;

  dynamic massageInfo;
  List filteredMassageLists = [];

  Map<String, dynamic> toggle = {};
  String? massage_info_id;
  String? booking_date;
  String? massageBookingDate;
  String? selectedService;
  Map<String, dynamic> servicesLists = {};
  List<Map<String, dynamic>> allServices = [];

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

    final v = await get(url);

    if (v == null) return;

    setState(() {
      massageInfo = v['massage_info'] ?? {};
      massageBookingDate = v['booking_date'] ?? '';
      servicesLists = v['services_lists'] ?? {};

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
      appBar: AppBar(title: const Text("จองบริการนวด")),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewPage()),
                          );
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      final url = massageInfo['mapLink'];
                      if (url != null && url.toString().isNotEmpty) {
                        launchUrl(Uri.parse(url));
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("ดูตำแหน่งร้าน"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: massageInfo?['is_favorite'] == true
                          ? Colors.grey.shade600 // ถ้าเคย fav = ปุ่มสีเทา
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildSelection(),
            SizedBox(height: 20),
            _buildServiceCards(),
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFe0e0e0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14), // ✅ เพิ่มความสูง
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingShopPage(
                                    province: '',
                                    booking_date: '',
                                  )),
                        );
                      },
                      label: const Text(
                        "ย้อนกลับ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF494949),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF07663a),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingConfirm()),
                        );
                      },
                      label: const Text(
                        "ถัดไป",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              Icon(Icons.check_circle, color: Colors.grey[500], size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(service['name_service']),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedService = value;
        });
      },
      dropdownStyleData: const DropdownStyleData(
        maxHeight: 420,
      ),
    );
  }

  Widget _buildServiceCards() {
    List<Widget> widgets = [];

    // ถ้าเลือก Category → render category เดียว
    final categories = selectedCategory == null
        ? servicesLists.keys.toList()
        : [selectedCategory!];

    for (final cat in categories) {
      final items = servicesLists[cat] ?? [];

      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          cat,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ));

      widgets.add(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map<Widget>((srv) {
              return _buildServiceCard(srv);
            }).toList(),
          ),
        ),
      );

      widgets.add(const SizedBox(height: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
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
