import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_coupon.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_history.dart';

class BookingConfirm extends StatefulWidget {
  const BookingConfirm({super.key});

  @override
  State<BookingConfirm> createState() => _BookingConfirmState();
}

class _BookingConfirmState extends State<BookingConfirm> {
  Map<String, dynamic>? selectedPromo; // เก็บโปรที่เลือก

  final Map<String, dynamic> bookingSummary = {
    "shop": {
      "id": 1,
      "name": "ร้านปังปังสุขใจ",
      "rating": "⭐ 4.95 (4 รีวิว)",
      "imageUrl": "assets/ihealth/shop1.jpg",
    },
    "booking": {
      "customerName": "คุณอารยา สมศรี",
      "date": "วันอังคารที่ 15 กันยายน 2568",
      "time": "10:17",
      "duration": "60 นาที",
      "massageType": "นวดอโรมา / นวดน้ำมัน",
      "therapist": "คุณแนน",
      "price": 750.00,
      "currency": "บาท",
    }
  };

  @override
  Widget build(BuildContext context) {
    final shop = bookingSummary["shop"];

    final booking = bookingSummary["booking"];

    /// ถ้ามีโปรคำนวณราคาใหม่
    final double price = booking["price"];
    final double finalPrice = selectedPromo == null
        ? price
        : price - (price * selectedPromo!["discount"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("สรุปรายการจอง"),
        backgroundColor: const Color(0xFF07663a),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// แสดงรายละเอียดอื่นๆ (ตัดไว้สั้นๆ)
            Expanded(
              child: ListView(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Image.asset(
                            shop["imageUrl"],
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shop["name"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(shop["rating"],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  buildInfoRow("ชื่อผู้จอง:", booking["customerName"]),
                  buildInfoRow("วันที่:", booking["date"]),
                  buildInfoRow("เวลานัดหมาย:", booking["time"]),
                  buildInfoRow("ประเภทนวด:", booking["massageType"]),

                  /// แสดงราคา
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("ราคารวม:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            if (selectedPromo != null)
                              Text(
                                "${price.toStringAsFixed(2)} ${booking["currency"]}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              "${finalPrice.toStringAsFixed(2)} ${booking["currency"]}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFe8f5e9),
                            foregroundColor: const Color(0xFF07663a),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.map),
                          label: const Text("ดูตำแหน่งใน Google Maps"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          final promo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingCouponPage()),
                          );
                          if (promo != null) {
                            setState(() {
                              selectedPromo = promo;
                            });
                          }
                        },
                        child: const Text(
                          "ใช้โค้ดหรือโปรโมชั่น",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  /// ถ้ามีโปร แสดงกล่อง
                  if (selectedPromo != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF07663a)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "ใช้โปรโมชั่น: ${selectedPromo!["title"]}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPromo = null;
                              });
                            },
                            child: const Icon(Icons.close, color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetail(),
                              ),
                            );
                          },
                          child: const Text("แก้ไขการจอง",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF07663a)),
                          onPressed: () {
                            _showSuccessDialog();
                          },
                          child: const Text("ยืนยันการจอง",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ห้ามกดปิดเอง
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    color: Color(0xFF07663a), size: 60),
                const SizedBox(height: 16),
                const Text(
                  "สำเร็จ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF07663a)),
                ),
                const SizedBox(height: 8),
                const Text("บันทึกข้อมูลสำเร็จ!",
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // ปิด dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  BookingHistoryPage()),
      );
    });
  }
}
