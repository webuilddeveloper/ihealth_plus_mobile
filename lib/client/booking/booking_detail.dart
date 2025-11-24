import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_confirm.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_coupon.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_shop.dart';
import 'package:ihealth_2025_mobile/client/review.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';
import 'package:photo_view/photo_view.dart';

class BookingDetail extends StatefulWidget {
  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String? selectedCategory;
  String? selectedCourse;
  String? selectedTherapist;
  bool isSelectedTherapist = false;

  final Map<String, List<Map<String, dynamic>>> courseCategories = {
    "นวดน้ำมัน": [
      {
        "id": 1,
        "name": "นวดอโรม่า / นวดน้ำมัน",
        "price": 750,
        "duration": 60,
        "image":
            "https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=800",
        "isFull": false,
      },
    ],
    "นวดสวีดิช": [
      {
        "id": 2,
        "name": "นวดสวีดิช",
        "price": 500,
        "duration": 45,
        "image":
            "https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=800",
        "isFull": false,
      },
      {
        "id": 3,
        "name": "นวดสวีดิช (พิเศษ)",
        "price": 900,
        "duration": 90,
        "image":
            "https://images.unsplash.com/photo-1600334129128-685c5582fd35?w=800",
        "isFull": true,
      },
    ],
  };

  final therapists = [
    {"name": "หมอนวด A", "image": "https://i.pravatar.cc/150?img=1"},
    {"name": "หมอนวด B", "image": "https://i.pravatar.cc/150?img=2"},
    {"name": "หมอนวด C", "image": "https://i.pravatar.cc/150?img=3"},
  ];

  // Mock Data
  final List<String> images = [
    'assets/ihealth/shop1.jpg',
    'assets/ihealth/shop2.jpg',
    'assets/ihealth/shop1.jpg',
    'assets/ihealth/shop2.jpg',
    'assets/ihealth/shop2.jpg',
  ];

  final Map<String, dynamic> infoData = {
    "id": 1,
    "name": "ศูนย์บำบัดครบวงจร",
    "rating": "⭐ 4.95 (4 รีวิว)",
    "description": "ให้บริการนวดและสปา ด้วยทีมงานมืออาชีพ",
    "openDays": "จันทร์ – อาทิตย์",
    "openHours": "10:00 – 20:00 น.",
  };

  Map<String, dynamic> toggle = {};

  _toggleFavorite() async {
    print('------ Adding to favorites... ------');
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    var headers = {'Authorization': 'Bearer $token'};

    final dioService = DioService();
    await dioService.init();
    final dio = dioService.dio;
    final cookieJar = dioService.cookieJar;

    var cookies = await cookieJar.loadForRequest(
      Uri.parse('https://api-ihealth.spl-system.com'),
    );
    print("Cookies: $cookies");
    var data = json
        .encode({"massage_info_id": "645c9a68-d89f-41e9-b9d9-414e25c04a7e"});

    var response = await dio.request(
      'https://api-ihealth.spl-system.com/api/v1/customer/favorites',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print('✅ Added to favorites successfully');

      setState(() {
        toggle = response.data['data'];
      });
      SnackBar snackBar = SnackBar(
        backgroundColor: toggle['isFavorite'] ? Colors.green : Colors.red,
        content: toggle['isFavorite']
            ? Text(' เพิ่มลงรายการโปรดเรียบร้อยแล้ว')
            : Text(' ลบออกจากรายการโปรดเรียบร้อยแล้ว'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print(response.statusMessage);
    }
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
    return Scaffold(
      appBar: AppBar(title: const Text("จองบริการนวด")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รูปหลัก
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullscreenImage(imageUrl: images[0]),
                    ),
                  );
                },
                child: Image.asset(
                  images[0],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),

              // แกลเลอรี
              Container(
                height: 90,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FullscreenImage(imageUrl: images[index]),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          images[index],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infoData["name"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewPage()),
                            );
                          },
                          child: Text(
                            infoData["rating"],
                            style:
                                TextStyle(fontSize: 14, color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'รายละเอียด:',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          infoData["description"],
                          style: TextStyle(fontSize: 14, color: Colors.black87),
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
                              fontWeight: FontWeight.w500),
                        ),
                        Text(infoData["openDays"],
                            style: TextStyle(fontSize: 13)),
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
                              fontWeight: FontWeight.w500),
                        ),
                        Text(infoData["openHours"],
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(color: Color(0xFF07663a), width: 4),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // หัวข้อ
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
                    const SizedBox(height: 8),
                    // แถว 1 : วันที่จอง
                    Row(
                      children: const [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.black54),
                        SizedBox(width: 4),
                        Text("วันที่จอง: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text("วันศุกร์ที่ 16 เมษายน 2570"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // แถว 2 : เวลาเริ่ม
                    Row(
                      children: const [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.black54),
                        SizedBox(width: 4),
                        Text("เวลาเริ่ม: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("14:34"),
                        const SizedBox(width: 20),
                        Icon(Icons.timer, size: 16, color: Colors.black54),
                        SizedBox(width: 4),
                        Text("ระยะเวลา: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("60 นาที"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              // ปุ่ม
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.map),
                      label: const Text("ดูตำแหน่งร้าน"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        _toggleFavorite();
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "เพิ่มลงรายการโปรด ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              _buildSelection(),
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
                                builder: (context) => BookingShopPage()),
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
      ),
    );
  }

  _buildSelection() {
    final courses = selectedCategory != null
        ? courseCategories[selectedCategory] ?? []
        : [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField2<String>(
          decoration: InputDecoration(
            labelText: "เลือกหมวดหมู่คอร์สนวด",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          value: selectedCategory,
          items: courseCategories.keys.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
              selectedCourse = null;
            });
          },
          dropdownStyleData: DropdownStyleData(
            useSafeArea: true,
            elevation: 2,
            offset: const Offset(0, -5),
          ),
          menuItemStyleData: const MenuItemStyleData(
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: courses.map((course) {
              bool isSelected = selectedCourse == course["name"];
              return Container(
                width: 270,
                height: 385,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Color(0xFF07663a) : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          course["image"],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        // ✅ บังคับให้ Padding ขยายเต็มพื้นที่ที่เหลือ
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // ✅ ชิดล่าง
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(course["name"],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(
                                "${course["price"]} บาท • ${course["duration"]} นาที",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: course["isFull"]
                                      ? Color(0xFFe0e0e0)
                                      : isSelected
                                          ? Color(0xFF07663a)
                                          : Colors.grey[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  minimumSize: Size(double.infinity, 45),
                                ),
                                onPressed: () {
                                  if (course["isFull"] != true) {
                                    setState(() {
                                      selectedCourse = course["name"] as String;
                                    });
                                  }
                                },
                                child: Text(
                                  course["isFull"]
                                      ? "ไม่ว่าง"
                                      : isSelected
                                          ? "✓ เลือกแล้ว"
                                          : "เลือก",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: course["isFull"]
                                          ? Colors.grey[700]
                                          : Colors.white),
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(height: 8),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Color(0xFF07663a)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    minimumSize: Size(double.infinity, 45),
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: (context) =>
                                          buildTherapistSheet(),
                                    );
                                  },
                                  child: Text(selectedTherapist != "" &&
                                          selectedTherapist != null
                                      ? "เปลี่ยนหมอนวด"
                                      : "เลือกหมอนวด"),
                                ),
                                SizedBox(height: 5),
                                selectedTherapist != "" &&
                                        selectedTherapist != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Color(0xFF07663a)),
                                          SizedBox(width: 5),
                                          Container(
                                            child: Text(
                                              selectedTherapist ?? '',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF07663a)),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget buildTherapistSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6, // ครึ่งจอ
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              "เลือกหมอนวด",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: therapists.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final t = therapists[index];
                  isSelectedTherapist = selectedTherapist == t["name"];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTherapist = t["name"];
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelectedTherapist
                            ? Colors.green[50]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelectedTherapist
                              ? Color(0xFF07663a)
                              : Colors.grey,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(2, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(t["image"]!),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              t["name"]!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelectedTherapist
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelectedTherapist
                                    ? Color(0xFF07663a)
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (isSelectedTherapist)
                            Icon(Icons.check_circle, color: Color(0xFF07663a)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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
