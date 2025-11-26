import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/review.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';

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
  ServiceType(id: 4, category: "สปา", name: "การแช่น้ำแร่"),
  ServiceType(id: 5, category: "สปา", name: "Vichy shower"),
  ServiceType(id: 6, category: "สปา", name: "Jet shower"),
  ServiceType(id: 7, category: "สปา", name: "ออนเซน"),
  ServiceType(id: 8, category: "สปา", name: "Steam bath"),
  ServiceType(id: 9, category: "สปา", name: "การขัดผิวกาย"),
  ServiceType(id: 10, category: "สปา", name: "การขัดผิวหน้า"),
  ServiceType(id: 11, category: "สปา", name: "การใช้ผ้าห่มร้อน"),
  ServiceType(id: 12, category: "สปา", name: "การรักษาความสะอาดผิวกาย"),
  ServiceType(id: 13, category: "สปา", name: "การรักษาความสะอาดผิวหน้า"),
  ServiceType(id: 14, category: "สปา", name: "การทำสมาธิ"),
  ServiceType(id: 15, category: "สปา", name: "การนวดหน้า"),
  ServiceType(
      id: 16,
      category: "สปา",
      name: "การบริการอาหารหรือเครื่องดื่มเพื่อสุขภาพ"),
  ServiceType(id: 17, category: "สปา", name: "การบำรุงผิวกาย"),
  ServiceType(id: 18, category: "สปา", name: "การบำรุงผิวหน้า"),
  ServiceType(id: 19, category: "สปา", name: "การประคบด้วยความเย็น"),
  ServiceType(id: 20, category: "สปา", name: "การประคบด้วยหินร้อน"),
  ServiceType(id: 21, category: "สปา", name: "การปรับสภาพผิวหน้า"),
  ServiceType(id: 22, category: "สปา", name: "การแปรงผิว"),
  ServiceType(id: 23, category: "สปา", name: "การพอกผิวกาย"),
  ServiceType(id: 24, category: "สปา", name: "การพอกผิวหน้า"),
  ServiceType(id: 25, category: "สปา", name: "การพันตัว"),
  ServiceType(id: 26, category: "สปา", name: "การพันร้อน"),
  ServiceType(id: 27, category: "สปา", name: "การอบซาวน่า"),
  ServiceType(id: 28, category: "สปา", name: "การอบไอน้ำ"),
  ServiceType(id: 29, category: "สปา", name: "การอาบด้วยทรายร้อน"),
  ServiceType(id: 30, category: "สปา", name: "ชิบอล"),
  ServiceType(id: 31, category: "สปา", name: "ไทเก๊ก"),
  ServiceType(id: 32, category: "สปา", name: "ไทชิ"),
  ServiceType(id: 33, category: "สปา", name: "พิลาทิส"),
  ServiceType(id: 34, category: "สปา", name: "ฟิตบอล"),
  ServiceType(id: 35, category: "สปา", name: "โยคะ"),
  ServiceType(id: 36, category: "สปา", name: "ฤาษีดัดตน"),
  ServiceType(id: 37, category: "สปา", name: "แอโรบิก"),
  ServiceType(id: 38, category: "นวดเพื่อสุขภาพ", name: "คอ / บ่า / ไหล่"),
  ServiceType(id: 39, category: "นวดเพื่อสุขภาพ", name: "หลัง / เอว / สะบัก"),
  ServiceType(id: 40, category: "นวดเพื่อสุขภาพ", name: "แขน / มือ / ข้อมือ"),
  ServiceType(id: 41, category: "นวดเพื่อสุขภาพ", name: "ขา / น่อง / เท้า"),
  ServiceType(id: 42, category: "นวดเพื่อสุขภาพ", name: "ศีรษะ / หน้า"),
  ServiceType(id: 43, category: "นวดเพื่อสุขภาพ", name: "นวดประคบสมุนไพร"),
  ServiceType(id: 44, category: "นวดเพื่อสุขภาพ", name: "นวดไทยผ่อนคลาย"),
  ServiceType(
      id: 45, category: "นวดเพื่อสุขภาพ", name: "นวดฝ่าเท้าเพื่อสุขภาพ"),
  ServiceType(
      id: 46, category: "นวดเพื่อสุขภาพ", name: "นวดอโรม่า / นวดน้ำมัน"),
  ServiceType(id: 47, category: "นวดเพื่อสุขภาพ", name: "นวดสวีดิช"),
  ServiceType(id: 48, category: "นวดเพื่อสุขภาพ", name: "นวดหญิงตั้งครรภ์"),
  ServiceType(id: 49, category: "นวดเพื่อสุขภาพ", name: "นวดผู้สูงอายุ"),
  ServiceType(id: 50, category: "นวดเพื่อสุขภาพ", name: "นวตอกเส้นเพื่อสุขภาพ"),
  ServiceType(id: 51, category: "นวดเพื่อสุขภาพ", name: "นวดเพื่อการกีฬา"),
  ServiceType(id: 52, category: "นวดเพื่อสุขภาพ", name: "นวดสำหรับเด็ก"),
  ServiceType(
      id: 53, category: "นวดเพื่อเสริมความงาม", name: "การทำทรีทเม้นท์หน้า"),
  ServiceType(id: 54, category: "นวดเพื่อเสริมความงาม", name: "การขัดตัว"),
  ServiceType(
      id: 55,
      category: "นวดเพื่อเสริมความงาม",
      name: "การนวดเซลลูไลท์ (นวดด้วยมือ)"),
  ServiceType(id: 56, category: "นวดเพื่อเสริมความงาม", name: "การพอกตัว"),
  ServiceType(id: 57, category: "นวดเพื่อเสริมความงาม", name: "การดูแลเส้นผม"),
  ServiceType(
      id: 58,
      category: "นวดเพื่อเสริมความงาม",
      name: "การนวดหน้าเพื่อสุขภาพและความงาม"),
  ServiceType(
      id: 59, category: "นวดเพื่อเสริมความงาม", name: "การทำความสะอาดผิวหน้า"),
  ServiceType(
      id: 60, category: "นวดเพื่อเสริมความงาม", name: "ปรับสภาพผิวหน้า"),
  ServiceType(id: 61, category: "นวดเพื่อเสริมความงาม", name: "ขัดผิวหน้า"),
  ServiceType(id: 62, category: "นวดเพื่อเสริมความงาม", name: "นวดหน้า"),
  ServiceType(id: 63, category: "นวดเพื่อเสริมความงาม", name: "พอกผิวหน้า"),
];

class BookingShopPage extends StatefulWidget {
  final String? province;
  final String? booking_date;

  const BookingShopPage({
    required this.province,
    required this.booking_date,
    super.key,
  });

  @override
  _BookingShopPageState createState() => _BookingShopPageState();
}

class _BookingShopPageState extends State<BookingShopPage> {
  String? selectedService;
  String? selectedServiceName;

  TextEditingController searchController = TextEditingController();

  List massageLists = [];
  List filteredMassageLists = [];

  String? province;
  String? booking_date;

  String? latLng;

  @override
  void initState() {
    super.initState();
    province = widget.province;
    booking_date = widget.booking_date;
    _getCurrentLocation();
  }

  callRead() {
    final url = '$api/api/v1/customer/search-massage-step1'
        '?province=$province'
        '&mapLink=$latLng'
        '&booking_date=$booking_date';

    get(url).then((v) {
      setState(() {
        massageLists = v['massage_lists'];
        filteredMassageLists = massageLists;
      });
    });
  }

  void search() {
    final encodedService = Uri.encodeComponent(selectedServiceName ?? "");

    final url = '$api/api/v1/customer/search-massage-step1'
        '?province=$province'
        '&mapLink=$latLng'
        '&booking_date=$booking_date'
        '&name_service=$encodedService';

    get(url).then((v) {
      setState(() {
        massageLists = v['massage_lists'];
        filteredMassageLists = massageLists;
      });
    });
  }

  void reset() {
    setState(() {
      searchController.clear();
      selectedService = null;
      callRead();
    });
  }

  Timer? _timer;

  void filterShops(String text) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredMassageLists = massageLists.where((shop) {
          return shop["massage_name"]
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase());
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ค้นหาร้านบริการ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton2<String>(
              isExpanded: true,
              hint: const Text("เลือกประเภทบริการ"),
              value: selectedService,
              items: buildGroupedItems(serviceTypes),
              onChanged: (val) {
                final selected =
                    serviceTypes.firstWhere((x) => x.id.toString() == val);
                setState(() {
                  selectedService = val;
                  selectedServiceName = selected.name;
                  search();
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF07663a),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF07663a), // สีเดียวกับปุ่ม
                    width: 1,
                  ),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: filterShops,
                    decoration: InputDecoration(
                      hintText: "ค้นหาชื่อร้าน",
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF07663a)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF07663a), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF064D2C), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 46,
                  width: 95,
                  child: OutlinedButton(
                    onPressed: reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFd4af37),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "ล้างข้อมูล",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMassageLists.length,
                itemBuilder: (context, index) {
                  final shop = filteredMassageLists[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          api + "/" + shop["massage_image"],
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                shop["massage_name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFF494949)),
                              ),
                              const SizedBox(height: 8),
                              // ที่อยู่
                              Text(
                                shop["address"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF07663a)),
                              ),

                              const SizedBox(height: 8),
                              // รีวิว
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => ReviewPage(),
                                  //   ),
                                  // );
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.orange, size: 18),
                                    Text(
                                      "${shop["avg_score"]} (${shop["total_reviews"]} รีวิว)",
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingDetail(
                                        booking_date: widget.booking_date,
                                        massage_info_id:
                                            shop['massage_info_id'],
                                        province: province,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF07663a),
                                  minimumSize: const Size(double.infinity, 46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.black.withOpacity(0.25),
                                ),
                                child: const Text(
                                  'ดูรายละเอียด',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        )
                      ],
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latLng =
            "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      });
    }

    callRead();
  }
}
