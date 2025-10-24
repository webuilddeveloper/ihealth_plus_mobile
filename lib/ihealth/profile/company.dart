import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final TextEditingController locationCtrl = TextEditingController();
  String? latLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'สถานประกอบการ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width *
                0.05, // 5% ของความกว้างหน้าจอ
            vertical: 20,
          ),
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // 2% ของความสูงหน้าจอ

              // Company Image - ปรับขนาดตามหน้าจอ
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width *
                      0.4, // 40% ของความกว้างหน้าจอ
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.2),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.2),
                    child: Image.asset(
                      'assets/ihealth/shop1.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.04), // 4% ของความสูงหน้าจอ

              // Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'ข้อมูลร้านที่อยู่ในสังกัด',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: MediaQuery.of(context).size.width *
                        0.055, // responsive font size
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Info Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoItem('ชื่อสถานประกอบการ', 'สปาสุขภาพไทย'),
                    _buildInfoItem('เลขใบอนุญาต', 'กอ-147852963-00'),
                    _buildInfoItem('ที่อยู่', 'ถนนสุขุมวิท กรุงเทพฯ 10110'),
                    _buildInfoItem('เบอร์โทร', '081-234-5678'),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              // Location Section
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ตำแหน่งที่ตั้ง',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Location Input Row - ปรับให้ responsive
                    MediaQuery.of(context).size.width > 400
                        ? Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildLocationTextField(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: _buildLocationButton(),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _buildLocationTextField(),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: _buildLocationButton(),
                              ),
                            ],
                          ),
                  ],
                ),
              ),

              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.05), // เพิ่มระยะห่างด้านล่าง
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width *
                0.35, // กำหนดความกว้างของ label ให้คงที่
            child: Text(
              '$label :',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTextField() {
    return Container(
      height: 55,
      child: TextField(
        controller: locationCtrl,
        cursorColor: AppColors.primary_gold,
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
        decoration: InputDecoration(
          hintText: "เลือกตำแหน่ง",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary_gold,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return InkWell(
      onTap: _getCurrentLocation,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "ใช้ตำแหน่งของฉัน",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
