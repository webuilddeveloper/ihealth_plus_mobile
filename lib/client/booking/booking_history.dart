import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/component/link_url_out.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';
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

  final TextEditingController txtcancel = TextEditingController();

  String? selectedPayment;
  XFile? _image;
  // dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  String? imageUrl;

  // final List<Map<String, dynamic>> bookings = [
  //   {
  //     "shopName": "สมใจสุขใจ",
  //     "status": "ไม่ชำระ",
  //     "service": "นวดแผนไทย / นวดประคบสมุนไพร",
  //     "category": "ฟรี / เดว / สปา",
  //     "therapist": "คุณสมชาย",
  //     "duration": "2 ชั่วโมง",
  //     "date": "25/06/2025",
  //     "time": "20:30 น.",
  //     "price": "800 บาท",
  //     "payment": "",
  //     "imageUrl": "",
  //   },
  //   {
  //     "shopName": "ผ่อนคลายสปา",
  //     "status": "ไม่ชำระ",
  //     "service": "นวดน้ำมันอโรมา",
  //     "category": "รีแลกซ์ / เดว / สปา",
  //     "therapist": "คุณสมศรี",
  //     "duration": "1.5 ชั่วโมง",
  //     "date": "23/06/2025",
  //     "time": "14:00 น.",
  //     "price": "1,200 บาท",
  //     "payment": "",
  //     "imageUrl": "",
  //   },
  // ];

  List<dynamic> pendingBookings = [
    // {
    //   "shopName": "ผ่อนคลายสปา",
    //   "status": "ชำระแล้ว",
    //   "service": "นวดน้ำมันอโรมา",
    //   "category": "รีแลกซ์ / เดว / สปา",
    //   "therapist": "คุณสมศรี",
    //   "duration": "1.5 ชั่วโมง",
    //   "date": "23/06/2025",
    //   "time": "14:00 น.",
    //   "price": "1,200 บาท",
    // },
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

  final TextEditingController reasonController = TextEditingController();

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
    _historymassage();
    _historyMassagePending();
    // _resetRatings();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildBookingCard(Map<String, dynamic> booking, int index) {
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
                  Text(booking['massage_name'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  booking['payment'] == "promptpay" && isSubmit == true
                      ? Text('ชำระแล้ว',
                          style: const TextStyle(
                              color: Colors.green, fontSize: 13))
                      : booking['payment'] == "cash" && isSubmit == true
                          ? Text('ชำระปลายทาง',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 13))
                          : Text(booking["status"],
                              style: TextStyle(
                                  color: booking['status'] == 'completed' ?
                                  Colors.green : booking['status'] == 'cancelled' ? Colors.red : Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 10),
              SizedBox(height: 5),
              // รายละเอียด
              buildDetail("ประเภทหลัก", booking["category_main"]),
              SizedBox(height: 10),
              buildDetail("ประเภทย่อย", booking["category_sub"]),
              SizedBox(height: 10),
              buildDetail("บริการ", booking["service_name"]),

              SizedBox(height: 10),
              buildDetail("หมอนวด", booking["therapist_name"]),
              SizedBox(height: 10),
              buildDetail("ระยะเวลา", booking["massage_duration"]),
              SizedBox(height: 10),
              buildDetail("วันที่นัดหมาย", booking["booking_date"]),
              SizedBox(height: 10),
              buildDetail("เวลานัดหมาย",
                  booking["start_time"] + "ถึง" + booking["start_time"]),

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
                  ? imageUrl == "" || imageUrl == null
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
                            imageUrl!,
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
                          _showPickerImage(context, index);
                        },
                        child: const Text(
                          "แนบสลิป ",
                          style: TextStyle(color: Color(0xFF07663a)),
                        ),
                      ),
                    )
                  : Container(),

              const Divider(height: 20),
              booking['status'] == 'completed'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: Container(
                            width: 100,
                            // margin: EdgeInsets.symmetric(vertical: 50.0),
                            child: Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppColors.primary,
                              child: MaterialButton(
                                height: 40,
                                onPressed: () {
                                  _showRatingDialog2(booking['scores'][0]);
                                },
                                child: Text(
                                  'ดูคะแนน',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Sarabun',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : booking['status'] == 'cancelled' ?
                  Container() :
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
                                          borderRadius:
                                              BorderRadius.circular(16),
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
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                  ),
                                                  const Text(
                                                    "สแกนจ่ายด้วย PromptPay",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Color(0xFF07663a),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  QrImageView(
                                                    data:
                                                        booking["promptPay"] ??
                                                            "0123456789",
                                                    version: QrVersions.auto,
                                                    size: 200.0,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    booking["shopName"] ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                      colorFilter: booking['payment'] ==
                                              "promptpay"
                                          ? const ColorFilter.mode(
                                              Colors.transparent,
                                              BlendMode.multiply)
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
                                              Colors.transparent,
                                              BlendMode.multiply)
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
                        booking['payment'] != "" && booking['payment'] != null
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    _updateBookingPayment(
                                        booking, booking['booking_id']);
                                  });
                                  // _showSuccessDialog();
                                },
                                child: const Column(
                                  children: [
                                    Icon(Icons.add_task,
                                        color: Colors.green, size: 40),
                                    Text("บันทึก",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: 35,
                        ),
                        InkWell(
                          onTap: () {
                            _showcancelDialog(booking['booking_id']);
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.delete_forever,
                                  color: Colors.red, size: 40),
                              Text("ยกเลิก",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
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

  Widget buildBookingCardPending(dynamic booking, int index) {
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
                  Text(
                    booking["massage_name"],
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(booking["status"],
                  //     style: const TextStyle(
                  //         color: Color(0xFF07663a), fontSize: 13)),
                ],
              ),
              const SizedBox(height: 10),
              buildDetail("ประเภทหลัก", booking["category_main"]),
              buildDetail("ประเภทย่อย", booking["category_sub"]),
              buildDetail("บริการ", booking["service_name"]),
              buildDetail("ผู้ให้บริการ", booking["therapist_name"]),
              buildDetail("ระยะเวลา", '${booking["massage_duration"]} นาที'),
              buildDetail("วันที่นัดหมาย", booking["booking_date"]),
              buildDetail("เวลานัดหมาย",
                  '${booking["start_time"]} ถึง ${booking["end_time"]}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildDetail("พิกัดร้าน", ''),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.map,
                        size: 18, color: Color(0xFF07663a)),
                    label: const Text("เปิดบน Google Maps",
                        style: TextStyle(color: Color(0xFF07663a))),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF07663a))),
                    onPressed: () {
                      launchURL(booking["massage_map"]);
                    },
                  ),
                ],
              ),
              buildDetail("ราคา", booking["price"]),
              const SizedBox(height: 20),
              booking["status"] == 'pending'
                  ? Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(60, 50),
                          // side: const BorderSide(
                          //   color: Color(0xFFd4af37),
                          //   width: 1,
                          // ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () =>
                            _showcancelDialog(booking["booking_id"]),
                        // hasRated
                        //     ? _showViewRatingDialog
                        //     : _showRatingDialog,
                        child: Text(
                          "ยกเลิกการจอง",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  : Column(
                      children: [
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
                            onPressed: hasRated
                                ? _showViewRatingDialog
                                : _showRatingDialog,
                            child: Text(
                              hasRated ? "ดูคะแนน" : "ให้คะแนน ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
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
        title: Text(
          "ประวัติการนวด",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
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
              onTap: (idx) => {
                idx == 0 ? _historyMassagePending() : _historymassage()
              }
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // SingleChildScrollView(
                //   child: Column(
                //     children: [
                //       // 🔽 Dropdown Filters อยู่นอก Card
                //       // Padding(
                //       //   padding: const EdgeInsets.symmetric(
                //       //       horizontal: 16, vertical: 10),
                //       //   child: Column(
                //       //     children: [
                //       //       DropdownButtonFormField2<String>(
                //       //         decoration: InputDecoration(
                //       //           labelText: "เดือน",
                //       //           border: OutlineInputBorder(
                //       //             borderRadius: BorderRadius.circular(12),
                //       //           ),
                //       //         ),
                //       //         value: selectedMonth,
                //       //         items: months.map((month) {
                //       //           return DropdownMenuItem<String>(
                //       //             value: month,
                //       //             child: Text(month),
                //       //           );
                //       //         }).toList(),
                //       //         onChanged: (value) {
                //       //           setState(() {
                //       //             selectedMonth = value;
                //       //           });
                //       //         },
                //       //         dropdownStyleData: DropdownStyleData(
                //       //           useSafeArea: true,
                //       //           elevation: 2,
                //       //           offset: const Offset(0, -5),
                //       //         ),
                //       //       ),
                //       //       const SizedBox(height: 16),

                //       //       DropdownButtonFormField2<String>(
                //       //         decoration: InputDecoration(
                //       //           labelText: "ปี",
                //       //           border: OutlineInputBorder(
                //       //             borderRadius: BorderRadius.circular(12),
                //       //           ),
                //       //         ),
                //       //         value: selectedYear,
                //       //         items: years.map((year) {
                //       //           return DropdownMenuItem<String>(
                //       //             value: year,
                //       //             child: Text(year),
                //       //           );
                //       //         }).toList(),
                //       //         onChanged: (value) {
                //       //           setState(() {
                //       //             selectedYear = value;
                //       //           });
                //       //         },
                //       //         dropdownStyleData: DropdownStyleData(
                //       //           useSafeArea: true,
                //       //           elevation: 2,
                //       //           offset: const Offset(0, -5),
                //       //         ),
                //       //       ),
                //       //       const SizedBox(height: 16),

                //       //       DropdownButtonFormField2<String>(
                //       //         decoration: InputDecoration(
                //       //           labelText: "สถานะ",
                //       //           border: OutlineInputBorder(
                //       //             borderRadius: BorderRadius.circular(12),
                //       //           ),
                //       //         ),
                //       //         value: selectedStatus,
                //       //         items: statuses.map((status) {
                //       //           return DropdownMenuItem<String>(
                //       //             value: status,
                //       //             child: Text(status),
                //       //           );
                //       //         }).toList(),
                //       //         onChanged: (value) {
                //       //           setState(() {
                //       //             selectedStatus = value;
                //       //           });
                //       //         },
                //       //         dropdownStyleData: DropdownStyleData(
                //       //           useSafeArea: true,
                //       //           elevation: 2,
                //       //           offset: const Offset(0, -5),
                //       //         ),
                //       //       ),
                //       //     ],
                //       //   ),
                //       // ),

                //       // 🔽 รายการ Booking Cards

                //     ],
                //   ),
                // ),
                ListView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingBookings.length,
                  itemBuilder: (context, index) {
                    return buildBookingCardPending(
                        pendingBookings[index], index);
                  },
                ),
                ListView.builder(
                  itemCount: historymassage.length,
                  itemBuilder: (context, index) {
                    return buildBookingCard(historymassage[index], index);
                  },
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
                        Navigator.of(context).pop(); // แล้วค่อยปิด

                        setState(() {
                          hasRated = true;
                          // savedRatings = {
                          //   "คุณภาพของร้าน": shopQuality,
                          //   "ความสะอาดของสถานที่": shopCleanliness,
                          //   "ตรงเวลานัดหมาย": shopAccuracy,
                          //   "ทักษะของหมอนวด": therapistSkill,
                          //   "ความเอาใจใส่หมอนวด": therapistCare,
                          //   "ความตรงต่อเวลา": therapistPunctuality,
                          //   "ข้อเสนอแนะ": feedbackController.text,
                          // };b
                          feedback();
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

  void _showRatingDialog2(dynamic rating) {
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
                          _buildRatingRow("คุณภาพของร้าน", (value) => null,
                              rating: rating['quality'].toDouble()),
                          _buildRatingRow(
                              "ความสะอาดของสถานที่", (value) => null,
                              rating: rating['cleanliness'].toDouble()),
                          _buildRatingRow("ตรงเวลานัดหมาย", (value) => null,
                              rating: rating['punctuality'].toDouble()),
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
                          _buildRatingRow("ทักษะของหมอนวด", (value) => null,
                              rating: rating['skill'].toDouble()),
                          _buildRatingRow("ความเอาใจใส่หมอนวด", (value) => null,
                              rating: rating['wellbeing'].toDouble()),
                          _buildRatingRow("ความตรงต่อเวลา", (value) => null,
                              rating: rating['comfort'].toDouble()),
                          const SizedBox(height: 20),
                          Text("ข้อเสนอแนะ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(rating['suggestion_text'], style: TextStyle()),

                          // TextField(
                          //   controller: feedbackController,
                          //   maxLines: 3,
                          //   decoration: const InputDecoration(
                          //     hintText: "ข้อเสนอแนะเพิ่มเติม...",
                          //     border: OutlineInputBorder(),
                          //   ),
                          // ),
                        ],
                      ),
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

  Widget _buildRatingRow(String title, Function(double) onRatingUpdate,
      {double rating = 0.0}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          RatingBar.builder(
            initialRating: rating,
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

  void _showPickerImage(context, int index) {
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
                  _imgFromGallery(index);
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

  // _imgFromCamera(int index) async {
  //   final ImagePicker _picker = ImagePicker();
  //   // Pick an image
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     _image = image!;
  //   });
  //   _upload(index);
  // }

  _imgFromGallery(int index) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload(index);

    print(_image!.path);
  }

  void _upload(int index) async {
    uploadImageX(_image!).then((res) {
      // setState(() {
      //   // bookings[index]['imageUrl'] = res;
      // });

      setState(() {
        imageUrl = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  feedback() async {
    try {
      final dioService = DioService();
      await dioService.init();
      final dio = dioService.dio;
      final cookieJar = dioService.cookieJar;

      final storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var data = json.encode({
        "booking_id": "4ec10c34-9e39-4358-833c-07e9f4656fac",
        "quality": shopQuality,
        "cleanliness": shopCleanliness,
        "punctuality": shopAccuracy,
        "skill": therapistSkill,
        "wellbeing": therapistCare,
        "comfort": therapistPunctuality,
        "suggestion_text": feedbackController.text.trim()
      });

      var response = await dio.post(
        'https://api-ihealth.spl-system.com/api/v1/customer/feedback',
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print('✅ Feedback submitted successfully');
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data["message"] ?? "เกิดข้อผิดพลาด";
      showErrorDialog(
        context: context,
        title: "แจ้งเตือน",
        message: errorMessage,
      );
      print("❌ Dio Error: $errorMessage");
    } catch (e) {
      // ดัก error อื่นๆ เช่น null, format ผิด ฯลฯ
      showErrorDialog(
        context: context,
        title: "แจ้งเตือน",
        message: "เกิดข้อผิดพลาด: $e",
      );
      print("❌ Other Error: $e");
    }
  }

  _updateBookingPayment(Map<String, dynamic> booking, String bookingid) async {
    print('====bookingid=====>> ${bookingid}');

    try {
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

      String payment_methods = (booking['payment'] ?? "") == "promptpay"
          ? 'โอนผ่านธนาคาร'
          : "เงินสด";

      final Map<String, dynamic> data = {
        "booking_id": bookingid,
        "payment_methods": payment_methods,
      };

      if ((booking['payment'] ?? "") == "promptpay") {
        if (_image == null) {
          showErrorDialog(
            context: context,
            title: "แจ้งเตือน",
            message: "กรุณาเลือกภาพก่อนอัปโหลด",
          );
          return;
        }

        // เอาไฟล์เฉพาะเมื่อ _image ไม่เป็น null
        final filePath = _image!.path;
        final fileName = filePath.split('/').last;
        final file = await MultipartFile.fromFile(filePath, filename: fileName);

        data["image"] = file;
      }
      data.forEach((key, value) async {
        if (value is MultipartFile) {
          print("🔹 $key : MultipartFile");
          print("   filename   : ${value.filename}");
          print("   contentType: ${value.contentType}");
        } else {
          print("$key : $value");
        }
      });

      final formData = FormData.fromMap(data);

      final response = await dio.put(
        'https://api-ihealth.spl-system.com/api/v1/customer/payment',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        setState(() {
          isSubmit = true;
        });
        _showSuccessDialog();
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data["message"] ?? "เกิดข้อผิดพลาด";
      showErrorDialog(
        context: context,
        title: "แจ้งเตือน",
        message: errorMessage,
      );
    } catch (e) {
      print("❌ Other ERROR: $e");
    }
  }

  _cancelMassage(String bookingid) async {
    try {
      FormData formData = FormData.fromMap({
        "cancel_reason": txtcancel.text,
      });

      var response = await putUpdateProfile(
          '${api}/api/v1/customer/cancel-massage/${bookingid}', formData);

      if (response.statusCode == 200) {
        return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: CupertinoAlertDialog(
                title: Text(
                  'ยกเลิกการจองเรียบร้อยแล้ว',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Sarabun',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(" "),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      "ตกลง",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Sarabun',
                        color: AppColors.primary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(
                      //     builder: (context) => HomePageV2(),
                      //   ),
                      //   (Route<dynamic> route) => false,
                      // );
                      _historymassage();
                      _historyMassagePending();
                      // goBack();
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        print(response.statusMessage);
      }
    } on DioException catch (e) {
      String errorMessage = e.response?.data["message"] ?? "เกิดข้อผิดพลาด";
      showErrorDialog(
        context: context,
        title: "แจ้งเตือน",
        message: errorMessage,
      );
    } catch (e) {
      print("❌ Other ERROR: $e");
    }
  }

  List<dynamic> historymassage = [];

  _historymassage() async {
    get(api + 'api/v1/customer/history-massage?year=&status=').then((v) => {
          setState(() {
            historymassage = v;
          }),
        });
  }

  _historyMassagePending() async {
    get(api + 'api/v1/customer/history-massage?year=&status=pending')
        .then((v) => {
              setState(() {
                pendingBookings = v;
              }),
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
    });
  }

  _showcancelDialog(String bookingid) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white, // พื้นหลังเข้ม
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "ยืนยันการยกเลิกหรือไม่ ?",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary // สีขาวให้อ่านง่ายบนพื้นเข้ม
                          ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 18),

                    // TextField
                    TextField(
                      controller: txtcancel,
                      minLines: 4,
                      maxLines: 6,
                      onChanged: (value) => setState(() {}),
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        hintText: 'กรุณาระบุเหตุผลการยกเลิก...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Buttons Row
                    Row(
                      children: [
                        // Confirm
                        Expanded(
                          child: GestureDetector(
                            onTap: txtcancel.text.isEmpty
                                ? null
                                : () {
                                    _cancelMassage(bookingid);
                                    Navigator.pop(context);
                                  },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: txtcancel.text.isEmpty
                                    ? Colors.grey[300]
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'ยืนยันการยกเลิก',
                                style: TextStyle(
                                  color: txtcancel.text.isEmpty
                                      ? Colors.grey[400]
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Close
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ปิด',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = "ตกลง",
    VoidCallback? onConfirm,
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Sarabun',
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: message != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Sarabun',
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                : null,
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
                child: Text(
                  confirmText,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Sarabun',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
