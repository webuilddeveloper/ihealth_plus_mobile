// ignore_for_file: deprecated_member_use

import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCalendarMain extends StatefulWidget {
  EventCalendarMain({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EventCalendarMain createState() => _EventCalendarMain();
}

class _EventCalendarMain extends State<EventCalendarMain> {
  bool showCalendar = false;
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // ข้อมูลจำลองจาก API
  List<Map<String, dynamic>> apiData = [];

  // เก็บข้อมูลการจองทั้งหมดจาก API
  List<Map<String, dynamic>> allBookingData = [];

  @override
  void initState() {
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _initializeBookingData(); // เริ่มต้นข้อมูลการจอง
    _fetchDataForDate(selectedDate); // โหลดข้อมูลเริ่มต้น
    super.initState();
  }

  /// เริ่มต้นข้อมูลการจองทั้งหมด (จำลอง API Response)
  void _initializeBookingData() {
    // ข้อมูลตัวอย่างจาก API

    allBookingData = [
      {
        "date": "20-08-2025",
        "status": "busy",
        "startTime": "09:15",
        "endTime": "10:15",
        "duration": "60 นาที",
        "customerName": "คุณสมชาย ใจดี",
        "bookingType": "นวดไทยแผนโบราณ",
      },
      {
        "date": "20-08-2025",
        "status": "busy",
        "startTime": "13:00",
        "endTime": "14:00",
        "duration": "60 นาที",
        "customerName": "คุณวิภา สวยงาม",
        "bookingType": "นวดอโรมา",
      },
      {
        "date": "20-08-2025",
        "status": "busy",
        "startTime": "15:45",
        "endTime": "16:45",
        "duration": "60 นาที",
        "customerName": "คุณมานะ รักษ์ดี",
        "bookingType": "นวดเพื่อสุขภาพ",
      },
      {
        "date": "21-08-2025",
        "status": "busy",
        "startTime": "10:30",
        "endTime": "12:00",
        "duration": "90 นาที",
        "customerName": "คุณสุวรรณ ทองคำ",
        "bookingType": "นวดน้ำมัน",
      },
      {
        "date": "21-08-2025",
        "status": "busy",
        "startTime": "14:15",
        "endTime": "15:45",
        "duration": "90 นาที",
        "customerName": "คุณปรีชา สุขใส",
        "bookingType": "นวดสปอร์ต",
      },
      {
        "date": "21-08-2025",
        "status": "busy",
        "startTime": "16:00",
        "endTime": "17:00",
        "duration": "60 นาที",
        "customerName": "คุณลักษณา แสงแก้ว",
        "bookingType": "นวดหิน",
      },
      {
        "date": "22-08-2025",
        "status": "busy",
        "startTime": "08:00",
        "endTime": "09:00",
        "duration": "60 นาที",
        "customerName": "คุณอารยา สุขสันต์",
        "bookingType": "นวดแผนไทย",
      },
      {
        "date": "22-08-2025",
        "status": "busy",
        "startTime": "11:00",
        "endTime": "12:30",
        "duration": "90 นาที",
        "customerName": "คุณธนา เจริญสุข",
        "bookingType": "นวดเพื่อสุขภาพ",
      },
      {
        "date": "22-08-2025",
        "status": "busy",
        "startTime": "15:00",
        "endTime": "17:00",
        "duration": "120 นาที",
        "customerName": "คุณนิรันดร์ แสงทอง",
        "bookingType": "นวดไทยแผนโบราณ",
      },
    ];
  }

  /// สร้าง Widget สำหรับแสดงรายละเอียด
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void changeTab() async {
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  /// ดึงข้อมูลสำหรับวันที่ที่เลือก
  void _fetchDataForDate(DateTime date) {
    String dateString = DateFormat('dd-MM-yyyy').format(date);

    // กรองข้อมูลตามวันที่ที่เลือก
    apiData = allBookingData.where((booking) {
      return booking['date'] == dateString;
    }).map((booking) {
      return {
        ...booking,
        "time": booking["startTime"], // เพิ่ม time field สำหรับ compatibility
        "detail":
            "${booking['bookingType']} - ${booking['customerName']} (${booking['duration']})",
        "bookingDate": booking['date'],
      };
    }).toList();

    setState(() {});
  }

  /// แปลงเวลาจาก String เป็น DateTime สำหรับการเปรียบเทียบ
  DateTime _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(2025, 1, 1, hour, minute);
  }

  /// สร้างรายการเวลาทุก 15 นาที
  List<String> _generateTimeSlots() {
    List<String> timeSlots = [];

    // สร้างเวลาตั้งแต่ 8:00 - 17:00 ทุก 15 นาที
    for (int hour = 8; hour <= 16; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        String timeStr =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        timeSlots.add(timeStr);
      }
    }

    // เพิ่มเวลา 17:00
    timeSlots.add('17:00');

    return timeSlots;
  }

  /// ตรวจสอบสถานะของเวลาแต่ละ slot
  Map<String, dynamic> _getTimeSlotStatus(String timeSlot) {
    DateTime currentTime = _parseTime(timeSlot);

    for (var booking in apiData) {
      DateTime startTime = _parseTime(booking['startTime']);
      DateTime endTime = _parseTime(booking['endTime']);

      // ตรวจสอบว่าเป็นเวลาเริ่มต้นการจอง
      if (currentTime.isAtSameMomentAs(startTime)) {
        return {
          "time": timeSlot,
          "status": "busy",
          "isMainSlot": true,
          "booking": booking,
          "displayType": "main" // แสดงข้อมูลเต็ม
        };
      }

      // ตรวจสอบว่าอยู่ในช่วงการจอง
      if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
        return {
          "time": timeSlot,
          "status": "busy",
          "isMainSlot": false,
          "booking": booking,
          "displayType": "ongoing" // แสดงว่าอยู่ในช่วงการจอง
        };
      }
    }

    // เวลาว่าง
    return {
      "time": timeSlot,
      "status": "free",
      "isMainSlot": false,
      "booking": null,
      "displayType": "free"
    };
  }

  /// สร้างตารางแบบไดนามิกจากข้อมูล API + ช่วงเวลามาตรฐาน
  List<Map<String, dynamic>> _createDynamicSchedule() {
    List<String> timeSlots = _generateTimeSlots();

    return timeSlots.map((timeSlot) {
      return _getTimeSlotStatus(timeSlot);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var schedule = _createDynamicSchedule();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              //   Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'เลือกวันที่',
              //       style: TextStyle(
              //         color: AppColors.primary,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              SizedBox(height: 8),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.grayligh),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      dialogOpenPickerDate(context, _dateController);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'ตารางงานประจำวันที่',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                formatThaiDate(_dateController.text),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textdark,
                ),
              ),
              SizedBox(height: 20),

              // ตารางเวลา
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    var item = schedule[index];
                    bool isBusy = item["status"] == "busy";
                    bool isMainSlot = item["isMainSlot"] ?? false;
                    String displayType = item["displayType"] ?? "free";

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isBusy
                              ? (isMainSlot
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.3))
                              : Colors.grey.shade300,
                          width: isMainSlot ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isBusy
                            ? (isMainSlot
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.primary.withOpacity(0.05))
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text(
                              item["time"],
                              style: TextStyle(
                                fontWeight: isMainSlot
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 14,
                                color: isMainSlot
                                    ? AppColors.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isBusy
                                  ? (isMainSlot
                                      ? Colors.red.shade400
                                      : Colors.red.shade200)
                                  : Colors.green.shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isBusy
                                  ? (isMainSlot ? "จอง" : "ช่วงจอง")
                                  : "ว่าง",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // แสดงรายละเอียดย่อสำหรับ main slot
                          if (isMainSlot && item["booking"] != null) ...[
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${item["booking"]["bookingType"]} - ${item["booking"]["customerName"]}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else if (displayType == "ongoing" &&
                              item["booking"] != null) ...[
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "ช่วงการจอง: ${item["booking"]["startTime"]} - ${item["booking"]["endTime"]}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else ...[
                            const Spacer(),
                          ],

                          // ปุ่มดูรายละเอียด (เฉพาะ main slot)
                          if (isMainSlot && item["booking"] != null)
                            GestureDetector(
                              onTap: () {
                                var booking = item["booking"];
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Row(
                                      children: [
                                        Icon(Icons.spa,
                                            color: AppColors.primary, size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                          "รายละเอียดการจอง",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow("วันที่จอง",
                                              booking["date"] ?? "-"),
                                          _buildDetailRow("เวลาเริ่ม",
                                              booking["startTime"] ?? "-"),
                                          _buildDetailRow("เวลาสิ้นสุด",
                                              booking["endTime"] ?? "-"),
                                          _buildDetailRow("ระยะเวลา",
                                              booking["duration"] ?? "-"),
                                          _buildDetailRow("ลูกค้า",
                                              booking["customerName"] ?? "-"),
                                          _buildDetailRow("ประเภทการจอง",
                                              booking["bookingType"] ?? "-"),
                                          Divider(color: Colors.grey.shade300),
                                          SizedBox(height: 8),
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.info_outline,
                                                    color: AppColors.primary,
                                                    size: 18),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    booking["detail"] ?? "-",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      // TextButton(
                                      //   onPressed: () => Navigator.pop(context),
                                      //   child: const Text(
                                      //     "ปิด",
                                      //     style: TextStyle(
                                      //       color: AppColors.primary,
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.primary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              "ปิด",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "ดูรายละเอียด",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (!isBusy)
                            Text(
                              "",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            )
                          else
                            SizedBox.shrink(), // สำหรับ ongoing slots
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatThaiDate(String dateString) {
    try {
      DateTime date = DateFormat("dd-MM-yyyy").parse(dateString);

      String dayName = DateFormat.EEEE('th_TH').format(date);
      String day = date.day.toString();
      String month = DateFormat.MMMM('th_TH').format(date);
      String year = (date.year + 543).toString();

      return '$dayNameที่ $day $month $year';
    } catch (e) {
      return "ไม่สามารถแปลงวันที่ได้ ($e)";
    }
  }

  Future<void> dialogOpenPickerDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800, 1, 1),
      lastDate: DateTime(2030, 1, 1),
      helpText: 'เลือกวันที่',
      cancelText: 'ยกเลิก',
      confirmText: 'ตกลง',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.lightgreen,
              onSurface: AppColors.textdark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            datePickerTheme: const DatePickerThemeData(
              headerBackgroundColor: AppColors.primary,
              headerForegroundColor: AppColors.lightgreen,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        controller.text = DateFormat("dd-MM-yyyy").format(pickedDate);
        _fetchDataForDate(pickedDate);
      });
    }
  }
}
