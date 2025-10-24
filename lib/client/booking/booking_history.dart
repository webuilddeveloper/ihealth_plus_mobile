import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedPayment;
  late XFile _image;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};

  final List<Map<String, dynamic>> bookings = [
    {
      "shopName": "สมใจสุขใจ",
      "status": "ไม่ชำระ",
      "service": "นวดแผนไทย / นวดประคบสมุนไพร",
      "category": "ฟรี / เดว / สปา",
      "therapist": "คุณสมชาย",
      "duration": "2 ชั่วโมง",
      "date": "25/06/2025",
      "time": "20:30 น.",
      "price": "800 บาท",
      "payment": ""
    },
    {
      "shopName": "ผ่อนคลายสปา",
      "status": "ไม่ชำระ",
      "service": "นวดน้ำมันอโรมา",
      "category": "รีแลกซ์ / เดว / สปา",
      "therapist": "คุณสมศรี",
      "duration": "1.5 ชั่วโมง",
      "date": "23/06/2025",
      "time": "14:00 น.",
      "price": "1,200 บาท",
      "payment": ""
    },
  ];

  final List<Map<String, dynamic>> completedBookings = [
    {
      "shopName": "ผ่อนคลายสปา",
      "status": "ชำระแล้ว",
      "service": "นวดน้ำมันอโรมา",
      "category": "รีแลกซ์ / เดว / สปา",
      "therapist": "คุณสมศรี",
      "duration": "1.5 ชั่วโมง",
      "date": "23/06/2025",
      "time": "14:00 น.",
      "price": "1,200 บาท",
    },
  ];

  bool hasRated = false;
  Map<String, dynamic> savedRatings = {};

  bool isSubmit = false;

  double shopQuality = 0;
  double shopCleanliness = 0;
  double shopAccuracy = 0;

  double therapistSkill = 0;
  double therapistCare = 0;
  double therapistPunctuality = 0;

  final TextEditingController feedbackController = TextEditingController();

  // state
  String? selectedMonth = "ทุกเดือน";
  String? selectedYear = "ทุกปี";
  String? selectedStatus = "ทุกสถานะ";

  final List<String> months = [
    "ทุกเดือน",
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม"
  ];

  final List<String> years = ["ทุกปี", "2024", "2025"];
  final List<String> statuses = ["ทุกสถานะ", "ชำระเงินแล้ว", "ยกเลิกแล้ว"];

  @override
  void initState() {
    super.initState();
    _resetRatings();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(booking["shopName"],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  Text(booking["status"],
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(height: 5),
              // รายละเอียด
              buildDetail("ประเภทหลัก", booking["service"]),
              SizedBox(height: 10),
              buildDetail("ประเภทย่อย", booking["category"]),
              SizedBox(height: 10),
              buildDetail("หมอนวด", booking["therapist"]),
              SizedBox(height: 10),
              buildDetail("ระยะเวลา", booking["duration"]),
              SizedBox(height: 10),
              buildDetail("วันที่นัดหมาย", booking["date"]),
              SizedBox(height: 10),
              buildDetail("เวลานัดหมาย", booking["time"]),
              SizedBox(height: 10),

              // แผนที่ + ราคา
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.map,
                        size: 18, color: Color(0xFF07663a)),
                    label: const Text("เปิดบน Google Maps",
                        style: TextStyle(color: Color(0xFF07663a))),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF07663a))),
                    onPressed: () {},
                  ),
                  Text("ราคา: ${booking["price"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF07663a))),
                ],
              ),
              const SizedBox(height: 20),
              booking['payment'] == 'promptpay'
                  ? itemImage1['imageUrl'] == "" &&
                          itemImage1['imageUrl'] == null
                      ? Container(
                          width: double.infinity,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text("ยังไม่มีสลิป",
                              style: TextStyle(color: Color(0xFF5a5a5a))),
                        )
                      : Container(
                          alignment: Alignment.center,
                          height: 150,
                          width: double.infinity,
                          child: Image.network(
                            itemImage1['imageUrl'],
                            height: 150,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        )
                  : Container(),
              const SizedBox(height: 10),
              booking['payment'] == 'promptpay'
                  ? Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                          minimumSize: const Size(60, 50),
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _showPickerImage(context, '1');
                        },
                        child: const Text(
                          "แนบสลิป",
                          style: TextStyle(color: Color(0xFF07663a)),
                        ),
                      ),
                    )
                  : Container(),

              const SizedBox(height: 10),

              const Divider(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              booking['payment'] = "promptpay";
                            });

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SizedBox(
                                    width: 320,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                            ),
                                            const Text(
                                              "สแกนจ่ายด้วย PromptPay",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Color(0xFF07663a),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            QrImageView(
                                              data: booking["promptPay"] ??
                                                  "0123456789",
                                              version: QrVersions.auto,
                                              size: 200.0,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              booking["shopName"] ?? "",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              ColorFiltered(
                                colorFilter: booking['payment'] == "promptpay"
                                    ? const ColorFilter.mode(
                                        Colors.transparent, BlendMode.multiply)
                                    : const ColorFilter.matrix(<double>[
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0, 0, 0, 1, 0, //
                                      ]),
                                child: Image.asset(
                                  'assets/ihealth/promtpay.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Text(
                                "พร้อมเพย์",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: booking['payment'] == "promptpay"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),

                        // เงินสด
                        InkWell(
                          onTap: () {
                            setState(() {
                              booking['payment'] = "cash";
                            });
                          },
                          child: Column(
                            children: [
                              ColorFiltered(
                                colorFilter: booking['payment'] == "cash"
                                    ? const ColorFilter.mode(
                                        Colors.transparent, BlendMode.multiply)
                                    : const ColorFilter.matrix(<double>[
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0.2126, 0.7152, 0.0722, 0, 0, //
                                        0, 0, 0, 1, 0, //
                                      ]),
                                child: Image.asset(
                                  'assets/ihealth/money.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              Text(
                                "เงินสด",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: booking['payment'] == "cash"
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Column(
                      children: [
                        Icon(Icons.add_task, color: Colors.green, size: 40),
                        Text("บันทึก",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Column(
                      children: [
                        Icon(Icons.delete_forever, color: Colors.red, size: 40),
                        Text("ยกเลิก",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookingCardSuccess(Map<String, dynamic> booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(booking["shopName"],
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(booking["status"],
                      style: const TextStyle(
                          color: Color(0xFF07663a), fontSize: 13)),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(height: 5),
              Text('25/06/2025 เวลา 20:30 น.'),
              SizedBox(height: 10),
              buildDetail("ราคา", booking["price"]),
              SizedBox(height: 5),
              buildDetail("หมอนวด", booking["therapist"]),
              SizedBox(height: 10),

              // แผนที่
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.map,
                        size: 18, color: Color(0xFF07663a)),
                    label: const Text("เปิดบน Google Maps",
                        style: TextStyle(color: Color(0xFF07663a))),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF07663a))),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text("ไม่มีภาพแนบ",
                    style: TextStyle(color: Color(0xFF5a5a5a))),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFd4af37),
                    minimumSize: const Size(60, 50),
                    side: const BorderSide(
                      color: Color(0xFFd4af37),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      hasRated ? _showViewRatingDialog : _showRatingDialog,
                  child: Text(
                    hasRated ? "ดูคะแนน" : "ให้คะแนน",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: const Text("ประวัติการจอง"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF07663a),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF07663a),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "อยู่ระหว่างดำเนินการ"),
                Tab(text: "ดำเนินการเสร็จสิ้น"),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return buildBookingCard(bookings[index]);
                  },
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // 🔽 Dropdown Filters อยู่นอก Card
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 16, vertical: 10),
                      //   child: Column(
                      //     children: [
                      //       DropdownButtonFormField2<String>(
                      //         decoration: InputDecoration(
                      //           labelText: "เดือน",
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //         ),
                      //         value: selectedMonth,
                      //         items: months.map((month) {
                      //           return DropdownMenuItem<String>(
                      //             value: month,
                      //             child: Text(month),
                      //           );
                      //         }).toList(),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             selectedMonth = value;
                      //           });
                      //         },
                      //         dropdownStyleData: DropdownStyleData(
                      //           useSafeArea: true,
                      //           elevation: 2,
                      //           offset: const Offset(0, -5),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 16),

                      //       DropdownButtonFormField2<String>(
                      //         decoration: InputDecoration(
                      //           labelText: "ปี",
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //         ),
                      //         value: selectedYear,
                      //         items: years.map((year) {
                      //           return DropdownMenuItem<String>(
                      //             value: year,
                      //             child: Text(year),
                      //           );
                      //         }).toList(),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             selectedYear = value;
                      //           });
                      //         },
                      //         dropdownStyleData: DropdownStyleData(
                      //           useSafeArea: true,
                      //           elevation: 2,
                      //           offset: const Offset(0, -5),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 16),

                      //       DropdownButtonFormField2<String>(
                      //         decoration: InputDecoration(
                      //           labelText: "สถานะ",
                      //           border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //         ),
                      //         value: selectedStatus,
                      //         items: statuses.map((status) {
                      //           return DropdownMenuItem<String>(
                      //             value: status,
                      //             child: Text(status),
                      //           );
                      //         }).toList(),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             selectedStatus = value;
                      //           });
                      //         },
                      //         dropdownStyleData: DropdownStyleData(
                      //           useSafeArea: true,
                      //           elevation: 2,
                      //           offset: const Offset(0, -5),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // 🔽 รายการ Booking Cards
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedBookings.length,
                        itemBuilder: (context, index) {
                          return buildBookingCardSuccess(
                              completedBookings[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 350,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "ให้คะแนนบริการ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF07663a)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ ส่วนที่ scroll ได้
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.store, color: Colors.green),
                              SizedBox(width: 6),
                              Text("ร้านนวด",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildRatingRow("คุณภาพของร้าน",
                              (value) => setState(() => shopQuality = value)),
                          _buildRatingRow(
                              "ความสะอาดของสถานที่",
                              (value) =>
                                  setState(() => shopCleanliness = value)),
                          _buildRatingRow("ตรงเวลานัดหมาย",
                              (value) => setState(() => shopAccuracy = value)),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(Icons.person, color: Colors.green),
                              SizedBox(width: 6),
                              Text("หมอนวด",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildRatingRow(
                              "ทักษะของหมอนวด",
                              (value) =>
                                  setState(() => therapistSkill = value)),
                          _buildRatingRow("ความเอาใจใส่หมอนวด",
                              (value) => setState(() => therapistCare = value)),
                          _buildRatingRow(
                              "ความตรงต่อเวลา",
                              (value) =>
                                  setState(() => therapistPunctuality = value)),
                          const SizedBox(height: 20),
                          TextField(
                            controller: feedbackController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "ข้อเสนอแนะเพิ่มเติม...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ ปุ่มส่ง
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF07663a),
                        minimumSize: const Size(100, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();

                        setState(() {
                          hasRated = true;
                          savedRatings = {
                            "คุณภาพของร้าน": shopQuality,
                            "ความสะอาดของสถานที่": shopCleanliness,
                            "ตรงเวลานัดหมาย": shopAccuracy,
                            "ทักษะของหมอนวด": therapistSkill,
                            "ความเอาใจใส่หมอนวด": therapistCare,
                            "ความตรงต่อเวลา": therapistPunctuality,
                            "ข้อเสนอแนะ": feedbackController.text,
                          };
                        });
                      },
                      child: const Text("ส่งคะแนน",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showViewRatingDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "คะแนนที่คุณให้",
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF07663a)),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: savedRatings.entries.map((entry) {
              if (entry.key == "ข้อเสนอแนะ") {
                // ✅ ข้อเสนอแนะเป็นข้อความ
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const Text(
                        "ข้อเสนอแนะเพิ่มเติม",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.value.isEmpty
                            ? "— ไม่มีข้อเสนอแนะ —"
                            : entry.value,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                );
              } else {
                // ✅ คะแนน (แสดงเป็นดาว)
                final double ratingValue = entry.value.toDouble();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < ratingValue
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 22,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ปิด", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF07663a),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _resetRatings(); // ✅ ให้คะแนนใหม่
            },
            child: const Text("ให้คะแนนใหม่",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String title, Function(double) onRatingUpdate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          RatingBar.builder(
            initialRating: 0,
            direction: Axis.horizontal,
            itemSize: 28,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: onRatingUpdate,
          ),
        ],
      ),
    );
  }

  void _showPickerImage(context, String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  'อัลบั้มรูปภาพ',
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () {
                  _imgFromGallery(type);
                  Navigator.of(context).pop();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.photo_camera),
              //   title: const Text(
              //     'กล้องถ่ายรูป',
              //     style: TextStyle(
              //       fontSize: 13,
              //       fontFamily: 'Kanit',
              //       fontWeight: FontWeight.normal,
              //     ),
              //   ),
              //   onTap: () {
              //     _imgFromCamera(type);
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  _imgFromCamera(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload(type);
  }

  _imgFromGallery(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload(type);
  }

  void _upload(String type) async {
    Random random = Random();
    uploadImageX(_image).then((res) {
      setState(() {
        if (type == "1") {
          itemImage1 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type
          };
        }
      });

      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      print(err);
    });
  }

  void _resetRatings() {
    setState(() {
      hasRated = false;
      savedRatings.clear();
      shopQuality = 0;
      shopCleanliness = 0;
      shopAccuracy = 0;
      therapistSkill = 0;
      therapistCare = 0;
      therapistPunctuality = 0;
      feedbackController.clear();
    });
  }
}
