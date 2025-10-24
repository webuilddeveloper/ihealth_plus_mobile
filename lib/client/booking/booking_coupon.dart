import 'package:flutter/material.dart';

class BookingCouponPage extends StatefulWidget {
  const BookingCouponPage({super.key});

  @override
  State<BookingCouponPage> createState() => _BookingCouponPageState();
}

class _BookingCouponPageState extends State<BookingCouponPage> {
  int? expandedIndex; // เก็บ index ที่ถูกขยาย

  final List<Map<String, dynamic>> promotions = [
    {
      "title": "โปรวันเกิด (ลด 15%)",
      "description": "ใช้ได้เฉพาะวันเกิดของลูกค้า พร้อมแสดงบัตรประชาชน",
      "discount": 0.15,
    },
    {
      "title": "โปรวันจันทร์–ศุกร์ (ลด 20%)",
      "description": "ใช้ได้เฉพาะวันจันทร์–ศุกร์ ไม่รวมวันหยุดนักขัตฤกษ์",
      "discount": 0.20,
    },
    {
      "title": "โปรลูกค้าใหม่ (ลด 10%)",
      "description": "ใช้ได้เฉพาะครั้งแรกของการใช้บริการ",
      "discount": 0.10,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เลือกโปรโมชั่น"),
        backgroundColor: const Color(0xFF07663a),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          final promo = promotions[index];
          final isExpanded = expandedIndex == index;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// title
                    Row(
                      children: [
                        const Icon(Icons.local_offer,
                            color: Color(0xFF07663a)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            promo["title"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    /// description + button (ถ้าขยาย)
                    if (isExpanded) ...[
                      const SizedBox(height: 8),
                      Text(
                        promo["description"],
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37), // สีทอง
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.pop(context, promo); // ส่งโปรกลับไปหน้า Confirm
                          },
                          child: const Text("ใช้โปรโมชั่นนี้"),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
