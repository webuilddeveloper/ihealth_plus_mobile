import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/pages/register_permission.dart';

class mainPermission extends StatefulWidget {
  const mainPermission({super.key});

  @override
  State<mainPermission> createState() => _mainPermissionState();
}

class _mainPermissionState extends State<mainPermission>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: const Text(
            'ลงทะเบียนแบบขออนุญาต',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        backgroundColor: const Color(0XFF224B45),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecurityLicenseCard(
                title: "หมอนวดแผนไทย \n(Traditional Thai Massage)",
                description: "การนวดเพื่อส่งเสริมสุขภาพ ",
                icon: Icons.self_improvement, // ไอคอนสื่อถึงโยคะ/การผ่อนคลาย
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'Traditional',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title: "หมอนวดเพื่อสุขภาพ \n(Spa & Wellness Massage)",
                description:
                    "การนวดน้ำมันเพื่อผ่อนคลาย การนวดบำบัดอื่นๆ เช่น นวดหินร้อน",
                icon: Icons.spa, // ไอคอนที่เกี่ยวกับสปาและความผ่อนคลาย
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'Spa',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title: "หมอนวดเพื่อการแพทย์แผนไทย (Thai Medical Massage)",
                description:
                    "การนวดเพื่อรักษาอาการปวดเมื่อยเฉพาะจุด เช่น ออฟฟิศซินโดรม",
                icon:
                    Icons.local_hospital, // ไอคอนที่สื่อถึงการรักษาทางการแพทย์
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'Medical',
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SecurityLicenseCard(
                title:
                    "หมอนวดแผนจีนและแผนตะวันออก (Chinese & Oriental Massage)",
                description:
                    "การกดจุดฝังเข็ม การใช้ศาสตร์จีน เช่น การครอบแก้ว หรือกัวซา",
                icon: Icons
                    .healing, // ไอคอนสื่อถึงศาสตร์แพทย์แผนจีน (Flutter ยังไม่มีไอคอนนี้ อาจใช้ alternative)
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPermission(
                        type: 'Chinese',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SecurityLicenseCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0XFF224B45).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, size: 60, color: const Color(0XFF224B45)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
