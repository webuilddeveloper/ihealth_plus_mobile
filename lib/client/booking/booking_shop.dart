import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/review.dart';

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

class BookingShopPage extends StatefulWidget {
  @override
  _BookingShopPageState createState() => _BookingShopPageState();
}

class _BookingShopPageState extends State<BookingShopPage> {
  String? selectedService;
  TextEditingController searchController = TextEditingController();
  List<Shop> filteredData = tempData;

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
              onChanged: (val) => setState(() => selectedService = val),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 300,
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
                    decoration: InputDecoration(
                      hintText: "ค้นหาชื่อร้าน",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: search,
                  icon: Icon(Icons.search),
                  label: Text("ค้นหา"),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: reset,
                  child: Text("รีเซ็ต"),
                )
              ],
            ),
            SizedBox(height: 20),

            // แถวสาม Results
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final shop = filteredData[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(shop.imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text("${shop.subDistrict}, ${shop.district}"),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReviewPage()),
                                  );
                                },
                                child: 
                             
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.orange, size: 18),
                                  Text(
                                      "${shop.rating} (${shop.reviewCount} รีวิว)"),
                                ],
                              ), ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingDetail()),
                                  );
                                },
                                child: Text("ดูรายละเอียด"),
                              )
                            ],
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
