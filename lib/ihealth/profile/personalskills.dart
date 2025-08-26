import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';

class PersonalSkill extends StatefulWidget {
  const PersonalSkill({super.key});

  @override
  State<PersonalSkill> createState() => _PersonalSkillState();
}

class _PersonalSkillState extends State<PersonalSkill> {
  // Mock ข้อมูล - พร้อมเชื่อมต่อ API ภายหลัง
  final List<Map<String, dynamic>> serviceWater = [
    {"id": 001, "title": "การแช่น้ำสมุนไพร"},
    {"id": 002, "title": "การแช่น้ำนม"},
    {"id": 003, "title": "การแช่อ่างน้ำวน"},
    {"id": 004, "title": "การแช่น้ำแร่"},
    {"id": 005, "title": "Vichy shower"},
    {"id": 006, "title": "Jet shower"},
    {"id": 007, "title": "ออนเซน"},
    {"id": 008, "title": "Steam bath"},
  ];

  final List<Map<String, dynamic>> serviceOther = [
    {"id": 101, "title": "การขัดผิวกาย"},
    {"id": 102, "title": "การขัดผิวหน้า"},
    {"id": 103, "title": "การใช้ผ้าห่มร้อน"},
    {"id": 104, "title": "การทำความสะอาดผิวกาย"},
    {"id": 105, "title": "การทำความสะอาดผิวหน้า"},
    {"id": 106, "title": "การทำสมาธิ"},
    {"id": 107, "title": "การนวดหน้า"},
    {"id": 108, "title": "การบริการอาหารหรือเครื่องดื่มเพื่อสุขภาพ"},
    {"id": 109, "title": "การบำรุงผิวกาย"},
    {"id": 110, "title": "การบำรุงผิวหน้า"},
    {"id": 111, "title": "การประคบด้วยความเย็น"},
    {"id": 112, "title": "การประคบด้วยหินร้อน"},
    {"id": 113, "title": "การปรับสภาพผิวหน้า"},
    {"id": 114, "title": "การแปรงผิว"},
    {"id": 115, "title": "การพอกผิวกาย"},
    {"id": 116, "title": "การพอกผิวหน้า"},
    {"id": 117, "title": "การพันตัว"},
    {"id": 118, "title": "การพันร้อน"},
    {"id": 119, "title": "การอบซาวน่า"},
    {"id": 120, "title": "การอบไอน้ำ"},
    {"id": 121, "title": "การอาบด้วยทรายร้อน"},
    {"id": 122, "title": "ชิบอล"},
    {"id": 123, "title": "ไทเก็ก"},
    {"id": 124, "title": "ไทชิ"},
    {"id": 125, "title": "พิลาทิส"},
    {"id": 126, "title": "ฟิตบอล"},
    {"id": 127, "title": "โยคะ"},
    {"id": 128, "title": "ฤาษีดัดตน"},
    {"id": 129, "title": "แอโรบิก"},
  ];
  final List<Map<String, dynamic>> serviceMassage = [
    {"id": 201, "title": "คอ / บ่า / ไหล่"},
    {"id": 202, "title": "หลัง / เอว / สะบัก"},
    {"id": 203, "title": "แขน / มือ / ข้อมือ"},
    {"id": 204, "title": "ขา / น่อง / เท้า"},
    {"id": 205, "title": "ศีรษะ / หน้า"},
    {"id": 206, "title": "นวดประคบสมุนไพร"},
    {"id": 207, "title": "นวดไทยผ่อนคลาย"},
  ];
  final List<Map<String, dynamic>> serviceMassageOil = [
    {"id": 301, "title": "นวดอโรม่า / นวดน้ำมัน"},
    {"id": 302, "title": "นวดสวีดิช"},
  ];
  // serviceMassageSpecialized
  final List<Map<String, dynamic>> serviceSpecializedMassage = [
    {"id": 401, "title": "นวดหญิงตั้งครรภ์"},
    {"id": 402, "title": "นวดผู้สูงอายุ"},
    {"id": 403, "title": "นวดตอกเส้นเพื่อสุขภาพ"},
    {"id": 404, "title": "นวดเพื่อการกีฬา"},
    {"id": 405, "title": "นวดสำหรับเด็ก"},
  ];
  final List<Map<String, dynamic>> serviceMassageBeauty = [
    {"id": 501, "title": "การทำทรีทเม้นท์หน้า"},
    {"id": 502, "title": "การขัดตัว"},
    {"id": 503, "title": "การนวดเซลลูไลท์ (นวดด้วยมือ)"},
    {"id": 504, "title": "การพอกตัว"},
    {"id": 505, "title": "การดูแลเส้นผม"},
    {"id": 506, "title": "การนวดหน้าเพื่อสุขภาพและความงาม"},
    {"id": 507, "title": "การทำความสะอาดผิวหน้า"},
    {"id": 508, "title": "ปรับสภาพผิวหน้า"},
    {"id": 509, "title": "ขัดผิวหน้า"},
    {"id": 510, "title": "นวดหน้า"},
    {"id": 511, "title": "พอกผิวหน้า"},
  ];
  final List<Map<String, dynamic>> languages = [
    {"id": 601, "title": "ไทย"},
    {"id": 602, "title": "อังกฤษ"},
    {"id": 603, "title": "จีนกลาง"},
    {"id": 604, "title": "ญี่ปุ่น"},
    {"id": 605, "title": "เกาหลี"},
    {"id": 606, "title": "เยอรมัน"},
    {"id": 607, "title": "ฝรั่งเศส"},
    {"id": 608, "title": "รัสเซีย"},
    {"id": 609, "title": "อาหรับ"},
    {"id": 610, "title": "พม่า"},
    {"id": 611, "title": "เขมร"},
    {"id": 612, "title": "ลาว"},
  ];

  // เก็บ ID ที่เลือก
  Set<int> selectedIds = <int>{};

  // สลับการเลือก
  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });

    // แสดงผลการเลือก
    print("Selected IDs: ${selectedIds.toList()}");
  }

  // เลือกทั้งหมดในหมวด
  void selectAllInCategory(
      List<Map<String, dynamic>> services, bool selectAll) {
    setState(() {
      final categoryIds = services.map((s) => s['id'] as int).toSet();

      if (selectAll) {
        selectedIds.addAll(categoryIds);
      } else {
        selectedIds.removeAll(categoryIds);
      }
    });
  }

  // ตรวจสอบว่าเลือกทั้งหมดในหมวดหรือไม่
  bool isAllSelectedInCategory(List<Map<String, dynamic>> services) {
    return services.every((service) => selectedIds.contains(service['id']));
  }

  // บันทึกข้อมูล
  Future<void> saveData() async {
    try {
      final selectedData = {
        'selected_skill_ids': selectedIds.toList(),
      };

      print('Saving data: $selectedData');

      // ส่งไป API
      // await http.post('your-save-endpoint', body: selectedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('บันทึกสำเร็จ'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ทักษะส่วนตัว',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_as_outlined),
            color: Colors.white,
            onPressed: saveData,
          ),
        ],
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'สปา',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildSection(
                title: "การบริการด้วยน้ำ",
                services: serviceWater,
              ),
              SizedBox(height: 12),
              _buildSection(
                title: "บริการอื่นๆ",
                services: serviceOther,
              ),
              SizedBox(height: 16),
              Text(
                'นวดเพื่อสุขภาพ',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildSection(
                title: "นวดเพื่อสุขภาพ",
                services: serviceMassage,
              ),
              SizedBox(height: 12),
              _buildSection(
                title: "นวดน้ำมันและสวีดิช",
                services: serviceMassageOil,
              ),
              _buildSection(
                title: "นวดเฉพาะทาง",
                services: serviceSpecializedMassage,
              ),
              SizedBox(height: 16),
              Text(
                'นวดเพื่อเสริมความงาม',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildSection(
                title: "บริการเพื่อความงาม",
                services: serviceMassageBeauty,
              ),
              SizedBox(height: 16),
              Text(
                'ด้านภาษา',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildSection(
                title: "ภาษาที่ใช้ได้",
                services: languages,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, dynamic>> services,
  }) {
    final allSelected = isAllSelectedInCategory(services);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with select all
        Row(
          children: [
            rowhead(title: title),
            Spacer(),
            TextButton(
              onPressed: () => selectAllInCategory(services, !allSelected),
              child: Text(
                allSelected ? 'ยกเลิกทั้งหมด' : 'เลือกทั้งหมด',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),

        // Services container
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grayligh),
          ),
          child: _buildServicesGrid(services),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(List<Map<String, dynamic>> services) {
    return Column(
      children: [
        for (int i = 0; i < services.length; i += 2)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                // คอลัมน์ซ้าย
                Expanded(
                  child: _buildCheckboxRow(services[i]),
                ),
                // คอลัมน์ขวา
                if (i + 1 < services.length)
                  Expanded(
                    child: _buildCheckboxRow(services[i + 1]),
                  )
                else
                  Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCheckboxRow(Map<String, dynamic> service) {
    final isSelected = selectedIds.contains(service['id']);

    return InkWell(
      onTap: () => toggleSelection(service['id']),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              activeColor: AppColors.primary,
              onChanged: (_) => toggleSelection(service['id']),
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                service['title'],
                style: TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowhead({required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 20,
          color: AppColors.primary,
          margin: EdgeInsets.only(right: 8),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// ตัวอย่างวิธีเรียก API จริง
/*
Future<void> loadData() async {
  try {
    setState(() => isLoading = true);
    
    // เรียก API
    final response = await http.get('https://your-api.com/personal-skills');
    final data = json.decode(response.body);
    
    setState(() {
      serviceWater = List<Map<String, dynamic>>.from(data['water_services']);
      serviceOther = List<Map<String, dynamic>>.from(data['other_services']);
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}

Future<void> saveData() async {
  try {
    final payload = {'selected_skill_ids': selectedIds.toList()};
    
    await http.post(
      'https://your-api.com/save-skills',
      headers: {'Content-Type': 'application/json'},
      body: json.encode(payload),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('บันทึกสำเร็จ')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาด')),
    );
  }
}
*/
