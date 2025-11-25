import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:geolocator/geolocator.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_detail.dart';
import 'package:ihealth_2025_mobile/client/booking/booking_shop.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Booking extends StatefulWidget {
  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? latLng;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int selectedDuration = 60;

  final TextEditingController priceMinCtrl = TextEditingController();
  final TextEditingController priceMaxCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  // TextEditingController txtDate = TextEditingController();

  // int _selectedDay = DateTime.now().day;
  // int _selectedMonth = DateTime.now().month;
  // int _selectedYear = DateTime.now().year;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TextEditingController txtDate = TextEditingController();

  DateTime today = DateTime.now();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latLng =
            "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
        locationCtrl.text = latLng!;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        timeCtrl.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จองนวด')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            // วันที่ต้องการ
            Text('วันที่ต้องการ *'),
            TableCalendar(
              firstDay: DateTime(2024),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,

              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },

              // ====== จุดสำคัญ =============
              // disable วันย้อนหลัง
              enabledDayPredicate: (day) {
                return !day.isBefore(
                  DateTime(today.year, today.month, today.day),
                );
              },

              onDaySelected: (selected, focused) {
                if (!selected
                    .isBefore(DateTime(today.year, today.month, today.day))) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                    txtDate.text = formatThaiDate(selected);
                  });
                }
              },

              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                decoration: BoxDecoration(
                  color: Color(0XFF07663a),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFFFFFFF)),
              ),

              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0XFF07663a),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18),
                // กำหนดสีของวันที่ disabled
                disabledTextStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
                defaultTextStyle: TextStyle(
                  fontSize: 16, 
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Container(
                width: double.infinity,
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(4, 4),
                      blurRadius: 12,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(-4, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        txtDate.text.isNotEmpty
                            ? "วันที่เลือก : ${txtDate.text}"
                            : "ยังไม่ได้เลือก",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0XFF07663a),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // InkWell(
            //   onTap: () => dialogOpenCalendar(context),
            //   child: IgnorePointer(
            //     child: TextField(
            //       controller: txtDate,
            //       decoration: InputDecoration(
            //         hintText: 'เลือกวันที่',
            //         suffixIcon: Icon(Icons.calendar_today),
            //         border: OutlineInputBorder(),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            // // เวลาเริ่ม - ระยะเวลา
            // Text('เริ่มนวดเวลา *'),
            // Row(
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => _pickTime(context),
            //         child: IgnorePointer(
            //           child: TextField(
            //             controller: timeCtrl,
            //             decoration: InputDecoration(
            //               hintText: 'เลือกเวลา',
            //               border: OutlineInputBorder(),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: DropdownButtonFormField<int>(
            //         value: selectedDuration,
            //         decoration: InputDecoration(
            //           labelText: 'ระยะเวลา',
            //           border: OutlineInputBorder(),
            //         ),
            //         items: [30, 60, 90, 120]
            //             .map((e) =>
            //                 DropdownMenuItem(value: e, child: Text('$e นาที')))
            //             .toList(),
            //         onChanged: (value) {
            //           if (value != null) {
            //             setState(() {
            //               selectedDuration = value;
            //             });
            //           }
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 20),

            // // ช่วงราคา
            // Text('ช่วงราคา (ไม่บังคับ)'),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: priceMinCtrl,
            //         keyboardType: TextInputType.number,
            //         decoration: InputDecoration(
            //           labelText: 'ต่ำสุด (บาท)',
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: TextField(
            //         controller: priceMaxCtrl,
            //         keyboardType: TextInputType.number,
            //         decoration: InputDecoration(
            //           labelText: 'สูงสุด (บาท)',
            //           border: OutlineInputBorder(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 30),

            // ปุ่มตกลง
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF07663a),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingShopPage(),
                  ),
                );
              },
              child: Text(
                'ถัดไป',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Future<void> dialogOpenCalendar(BuildContext context) async {
  //   DateTime today = DateTime.now();
  //   DateTime selectedDate = today;

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.zero,
  //         content: StatefulBuilder(
  //           builder: (context, setState) {
  //             return SizedBox(
  //               width: 350,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TableCalendar(
  //                     firstDay: DateTime(today.year, today.month, today.day),
  //                     lastDay: DateTime(2100),
  //                     focusedDay: selectedDate,
  //                     selectedDayPredicate: (day) =>
  //                         isSameDay(selectedDate, day),
  //                     onDaySelected: (selected, focused) {
  //                       setState(() {
  //                         selectedDate = selected;
  //                       });
  //                     },
  //                     headerStyle: const HeaderStyle(
  //                       formatButtonVisible: false,
  //                       titleCentered: true,
  //                       titleTextStyle: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                     calendarStyle: const CalendarStyle(
  //                       todayDecoration: BoxDecoration(
  //                         color: Color(0XFF224B45),
  //                         shape: BoxShape.circle,
  //                       ),
  //                       selectedDecoration: BoxDecoration(
  //                         color: Colors.orange,
  //                         shape: BoxShape.circle,
  //                       ),
  //                       todayTextStyle: TextStyle(color: Colors.white),
  //                       selectedTextStyle: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                   const Divider(height: 1),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         TextButton(
  //                           onPressed: () => Navigator.pop(context),
  //                           child: const Text('CANCEL'),
  //                         ),
  //                         ElevatedButton(
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: const Color(0XFF224B45),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.pop(context, selectedDate);
  //                           },
  //                           child: const Text('OK'),
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   ).then((pickedDate) {
  //     if (pickedDate != null) {
  //       // อัพเดทค่าที่เลือก
  //       _selectedYear = pickedDate.year;
  //       _selectedMonth = pickedDate.month;
  //       _selectedDay = pickedDate.day;
  //       txtDate.value = TextEditingValue(
  //         text:
  //             "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}",
  //       );
  //     }
  //   });
  // }

  String formatThaiDate(DateTime date) {
    const thaiMonths = [
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

    int buddhistYear = date.year + 543;
    String monthName = thaiMonths[date.month - 1];

    return "${date.day} $monthName $buddhistYear";
  }
}
