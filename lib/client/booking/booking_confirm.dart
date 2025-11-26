import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_coupon.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_history.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';

class BookingConfirm extends StatefulWidget {
  const BookingConfirm({super.key, required this.model});

  final dynamic model;
  @override
  State<BookingConfirm> createState() => _BookingConfirmState();
}

class _BookingConfirmState extends State<BookingConfirm> {
  Map<String, dynamic>? selectedPromo; // เก็บโปรที่เลือก

  dynamic model;
  dynamic profileModel = {};

  @override
  void initState() {
    super.initState();
    model = widget.model;
    _readProfile();
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Image.network(
                            "$api/${model['image']}",
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model["massage_name"],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(model["name_service"],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF07663a))),
                              const SizedBox(height: 4),
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
                                      "${model["avg_score"]} (${model["review_count"]} รีวิว)",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  buildInfoRow("ชื่อผู้จอง:", profileModel['fullname'] ?? ""),
                  buildInfoRow("วันที่:", model["massageDate"]),
                  buildInfoRow("เวลาเริ่มนวด:",
                      "${model["start_time"]} น. ถึง ${model["end_time"]} น."),
                  buildInfoRow(
                      "ระยะเวลานวด:", "${model["massage_duration"]} นาที"),
                  buildInfoRow("ประเภทย่อย:", model["category_sub"]),
                  buildInfoRow(
                      "ผู้ให้บริการที่เลือก:", model["therapist_fullname"]),

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
                                "฿${model['price'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              "฿${model['price_total'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  ClipPath(
                    clipper: TicketShape(),
                    child: GestureDetector(
                      onTap: () async {
                        final promo = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingCouponPage(
                                  massage_info_id: model['massage_info_id'])),
                        );
                        if (promo != null) {
                          setState(() {
                            selectedPromo = promo;
                            final price = (model['price'] ?? 0).toDouble();
                            final discount =
                                (promo['discount'] ?? 0).toDouble();

                            model['price_total'] = price - discount;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        color: const Color(0xFFC99B22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.discount, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "คูปองส่วนลด / โปรโมชั่น",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
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
                                builder: (_) => BookingDetail(
                                  massage_info_id: model['massage_info_id'],
                                  booking_date: model['booking_date'],
                                  province: model['province'],
                                ),
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
                          onPressed: () async {
                            if (selectedPromo?.isNotEmpty == true) {
                              model['discount'] =
                                  selectedPromo?['discount'] ?? 0;
                              model['discount_type'] =
                                  selectedPromo?['discount_type'] ?? "";
                              model['promotion_id'] =
                                  selectedPromo?['promotion_id'] ?? "";
                            }

                            final res = await post(
                              "$api/api/v1/customer/bookings",
                              model,
                            );

                            if (res['status'] == "F") {
                              showCenterDialog(
                                context,
                                title: "จองไม่สำเร็จ",
                                message: "เนื่องจากช่วงเวลานี้ มีคนจองแล้ว",
                              );
                              return;
                            } else {
                              _showSuccessDialog();
                            }
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

  _readProfile() async {
    await storage.read(key: 'fullname').then((v) => setState(() {
          profileModel['fullname'] = v;
        }));
    await storage.read(key: 'mobile').then((v) => setState(() {
          profileModel['mobile'] = v;
        }));
    await storage.read(key: 'image').then((v) => setState(() {
          profileModel['image'] = v;
        }));
    await storage.read(key: 'token').then((v) => setState(() {
          profileModel['token'] = v;
        }));
    await storage.read(key: 'loginType').then((v) => setState(() {
          profileModel['loginType'] = v;
        }));
  }

  _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ห้ามกดปิดเอง
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        MaterialPageRoute(builder: (context) => BookingHistoryPage()),
      );
    });
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
}

class TicketShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 10.0;

    Path path = Path()
      ..moveTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(
          size.width, size.height, size.width - radius, size.height)
      ..lineTo(radius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(TicketShape oldClipper) => false;
}
