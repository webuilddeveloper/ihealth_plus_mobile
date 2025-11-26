import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/review.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';

class Shop {
  final int id;
  final String name;
  final String subDistrict;
  final String district;
  final String province;
  final double rating;
  final int reviewCount;
  final int serviceId;
  final String imageUrl;

  Shop({
    required this.id,
    required this.name,
    required this.subDistrict,
    required this.district,
    required this.province,
    required this.rating,
    required this.reviewCount,
    required this.serviceId,
    required this.imageUrl,
  });
}

class ServiceType {
  final int id;
  final String category;
  final String name;

  ServiceType({required this.id, required this.category, required this.name});
}

final List<ServiceType> serviceTypes = [
  ServiceType(id: 1, category: "สปา", name: "การแช่น้ำสมุนไพร"),
  ServiceType(id: 2, category: "สปา", name: "การแช่น้ำนม"),
  ServiceType(id: 3, category: "สปา", name: "การแช่อ่างน้ำวน"),
  ServiceType(id: 4, category: "นวดเสริมความงาม", name: "การพอกตัว"),
  ServiceType(id: 5, category: "นวดเสริมความงาม", name: "การขัดตัว"),
];

// mock ข้อมูลร้าน
final List<Shop> tempData = [
  Shop(
    id: 1,
    name: "ร้านบำบัดสุขใจ",
    subDistrict: "แขวงพลับพลา",
    district: "เขตวังทองหลาง",
    province: "กรุงเทพฯ",
    rating: 4.95,
    reviewCount: 4,
    serviceId: 1,
    imageUrl: "https://picsum.photos/200/300?random=1",
  ),
  Shop(
    id: 2,
    name: "สปาธรรมชาติ",
    subDistrict: "แขวงจันทรเกษม",
    district: "เขตลาดพร้าว",
    province: "กรุงเทพฯ",
    rating: 4.8,
    reviewCount: 4,
    serviceId: 2,
    imageUrl: "https://picsum.photos/200/300?random=2",
  ),
];

final List<Map<String, dynamic>> shopData = [
  {
    "id": 1,
    "name": "ร้านบำบัดสุขใจ",
    "rating": 4.95,
    "reviewCount": 4,
    "categories": [
      {
        "id": 1,
        "name": "นวดเพื่อสุขภาพ",
        "subCategories": [
          {
            "id": 1,
            "name": "นวดน้ำมันและสวีดิช",
            "services": [
              {
                "id": 1,
                "name": "นวดอโรม่า / นวดน้ำมัน",
                "price": 750,
                "duration": 60,
                "imageUrl": "https://picsum.photos/200/300?random=11",
                "therapists": [
                  {"id": 1, "name": "หมอนวดเอ"},
                  {"id": 2, "name": "หมอนวดบี"},
                ],
              },
              {
                "id": 2,
                "name": "นวดสวีดิช",
                "price": 850,
                "duration": 60,
                "imageUrl": "https://picsum.photos/200/300?random=12",
                "therapists": [
                  {"id": 3, "name": "หมอนวดซี"},
                ],
              },
            ],
          },
        ],
      },
      {
        "id": 2,
        "name": "นวดเสริมความงาม",
        "subCategories": [
          {
            "id": 2,
            "name": "นวดหน้า",
            "services": [
              {
                "id": 3,
                "name": "นวดหน้าสปา",
                "price": 650,
                "duration": 45,
                "imageUrl": "https://picsum.photos/200/300?random=13",
                "therapists": [
                  {"id": 4, "name": "หมอนวดดี"},
                ],
              }
            ],
          }
        ],
      }
    ],
  }
];

class BookingFavoritePage extends StatefulWidget {
  @override
  _BookingFavoritePageState createState() => _BookingFavoritePageState();
}

class _BookingFavoritePageState extends State<BookingFavoritePage> {
  String? selectedService;
  TextEditingController searchController = TextEditingController();
  List<Shop> filteredData = tempData;
  List<dynamic> favoritesData = [];

  void search() {
    setState(() {
      filteredData = tempData.where((shop) {
        final matchesName = shop.name.contains(searchController.text.trim());
        final matchesService = selectedService == null ||
            shop.serviceId.toString() == selectedService;
        return matchesName && matchesService;
      }).toList();
    });
  }

  void reset() {
    setState(() {
      searchController.clear();
      selectedService = null;
      filteredData = tempData;
    });
  }

  void initState() {
    super.initState();
    _Favorites();
  }

  _Favorites() async {
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
    // var data = json
    //     .encode({"massage_info_id": "645c9a68-d89f-41e9-b9d9-414e25c04a7e"});
    var response = await dio.request(
      'https://api-ihealth.spl-system.com/api/v1/customer/favorites',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
      // data: data,
    );

    if (response.statusCode == 200) {
      print('✅ Favorites fetched successfully:');
      setState(() {
        favoritesData = response.data['data'];
      });
    } else {
      print(response.statusMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "รายการโปรด",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DropdownButton2<String>(
            //   isExpanded: true,
            //   hint: const Text("เลือกประเภทบริการ"),
            //   value: selectedService,
            //   items: buildGroupedItems(serviceTypes),
            //   onChanged: (val) => setState(() => selectedService = val),
            //   buttonStyleData: const ButtonStyleData(
            //     padding: EdgeInsets.symmetric(horizontal: 12),
            //   ),
            //   dropdownStyleData: const DropdownStyleData(
            //     maxHeight: 300,
            //   ),
            //   menuItemStyleData: const MenuItemStyleData(
            //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //   ),
            // ),

            SizedBox(height: 12),

            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: searchController,
            //         decoration: InputDecoration(
            //           hintText: "ค้นหาชื่อร้าน",
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 8),
            //     ElevatedButton.icon(
            //       onPressed: search,
            //       icon: Icon(Icons.search),
            //       label: Text("ค้นหา"),
            //     ),
            //     SizedBox(width: 8),
            //     OutlinedButton(
            //       onPressed: reset,
            //       child: Text("รีเซ็ต"),
            //     )
            //   ],
            // ),
            SizedBox(height: 20),

            // แถวสาม Results
            favoritesData.isEmpty
                ? Center(
                    child: Text(
                      "ไม่มีรายการโปรด",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: favoritesData.length,
                      itemBuilder: (context, index) {
                        final favorite = favoritesData[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.1),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                  "https://api-ihealth.spl-system.com/" +
                                      favorite['image'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(favorite['massage_name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(
                                        "${favorite['province']}, ${favorite['district']}"),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                            "${favorite['avg_score']} (${favorite['review_count']} รีวิว)"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookingDetail(massage_info_id: '', booking_date: '',)),
                                      );
                                    },
                                    child: const Text(
                                      "ดูรายละเอียด",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Kanit',
                                      ),
                                    )
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildGroupedItems(List<ServiceType> data) {
    final Map<String, List<ServiceType>> grouped = {};
    for (final s in data) {
      grouped.putIfAbsent(s.category, () => []).add(s);
    }

    final items = <DropdownMenuItem<String>>[];
    grouped.forEach((cat, list) {
      items.add(
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
      items.addAll(list.map((s) {
        return DropdownMenuItem<String>(
          value: s.id.toString(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(s.name),
          ),
        );
      }));
    });
    return items;
  }
}
