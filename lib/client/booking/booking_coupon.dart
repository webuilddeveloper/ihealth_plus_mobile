import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';

class BookingCouponPage extends StatefulWidget {
  const BookingCouponPage({super.key, required this.massage_info_id});
  final String massage_info_id;

  @override
  State<BookingCouponPage> createState() => _BookingCouponPageState();
}

class _BookingCouponPageState extends State<BookingCouponPage> {
  int? expandedIndex;

  List<dynamic> promotions = [];

  @override
  void initState() {
    super.initState();
    _callRead();
  }

  _callRead() async {
    final url =
        '$api/api/v1/customer/promotions-massage/${widget.massage_info_id}';

    get(url).then((v) {
      setState(() {
        promotions = v['promotions'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f6),
      appBar: AppBar(
        title: const Text("เลือกโปรโมชั่น"),
        backgroundColor: const Color(0xFF07663a),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: promotions.length,
        itemBuilder: (context, i) {
          final p = promotions[i];
          final selected = expandedIndex == i;

          return GestureDetector(
            onTap: () => setState(() => expandedIndex = selected ? null : i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected
                    ? const Color(0xFFD9F3E2) // เขียวอ่อนแบบในภาพ
                    : Colors.white,
                border: Border.all(
                  color:
                      selected ? const Color(0xFF1C7F50) : Colors.grey.shade300,
                  width: 1.3,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.local_offer,
                          color: selected
                              ? const Color(0xFF1C7F50)
                              : Colors.black54,
                          size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          p["name"],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? const Color(0xFF1C7F50)
                                : Colors.black87,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(Icons.check_circle,
                            color: Color(0xFF1C7F50), size: 20)
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _promotionText(p),
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          selected ? const Color(0xFF1C7F50) : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(height: 10),
                    Text(
                      p["detail"] ?? "",
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "ใช้ได้ตั้งแต่ ${formatThaiDate(p["promotion_start"])} ถึง ${formatThaiDate(p["promotion_end"])}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFFF4D69), // ชมพู
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.pop(context, p),
                        child: const Text(
                          "ใช้โปรโมชั่นนี้",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// แสดง format % หรือ เงิน
  String _promotionText(Map<String, dynamic> p) {
    try {
      final type = p["discount_type"];
      final discount = p["discount"];

      if (type == "percent") {
        return "(ลด $discount %)";
      } else {
        return "(ลด $discount บาท)";
      }
    } catch (e) {
      return "";
    }
  }

  String formatThaiDate(dynamic isoDate) {
    if (isoDate == null || isoDate == "") return "-";

    try {
      DateTime d = DateTime.parse(isoDate);
      int buddhistYear = d.year + 543;
      return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/$buddhistYear";
    } catch (e) {
      return "-";
    }
  }
}
