import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/widget/dialog.dart';

class ApplyDetail extends StatefulWidget {
  const ApplyDetail({super.key, required this.job});
  final Map<String, dynamic> job;

  @override
  State<ApplyDetail> createState() => _ApplyDetailState();
}

class _ApplyDetailState extends State<ApplyDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'รายละเอียดงาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(widget.job['imgUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.job['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightgreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.job['type'],
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontFamily: "sarabun",
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.job['company'],
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textdark,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textdark,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.job['location'],
                                    style: TextStyle(
                                      color: AppColors.textdark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTextRow(
                      title: 'ประเภทหลัก', sub: widget.job['maincategories']),
                  SizedBox(height: 8),
                  _buildTextRow(
                      title: 'ประเภทย่อย', sub: widget.job['subcategories']),
                  SizedBox(height: 8),
                  _buildTextRow(title: 'สวัสดิการ', sub: widget.job['welfare']),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightgreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.attach_money,
                          title: 'ค่าตอบแทน',
                          value: widget.job['salary'],
                          valueColor: Color(0XFF224B45),
                        ),
                        SizedBox(height: 12),
                        _buildInfoRow(
                          icon: Icons.access_time,
                          title: 'เวลาทำงาน',
                          value: widget.job['working_hours'],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            print('------------>>สมัครงาน<<----------------');

            dialogApply();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'สมัครงาน',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  dialogApply() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        insetPadding:
            EdgeInsets.symmetric(horizontal: 20), // ลดระยะห่างจากขอบจอ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // กว้าง 90% ของหน้าจอ
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          'สมัครงาน: ร้านนวดสบายใจ',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.grayligh,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'ข้อมูลผู้สมัคร',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'ชื่อนามสกุล', sub: "วรรณิภา สุขใจ"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'เลขใบอนุญาต', sub: "กอ-12345-50"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'สัญชาติ', sub: "ไทย"),
                              _buildTextRowPrimary(title: 'เพศ', sub: "หญิง"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'วันเกิด', sub: "1997-09-20"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'ทักษะนวด',
                                  sub: "หลัง / เอว / สะบัก, ศีรษะ / หน้า"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'ทักษะภาษา', sub: "ไทย, อังกฤษ"),
                              SizedBox(height: 8),
                              _buildTextRowPrimary(
                                  title: 'เบอร์โทรศัพท์', sub: "091-234-6789"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: Text(
                          'ข้อความเพิ่มเติม',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: null,
                        maxLines: null, // ไม่จำกัดจำนวนบรรทัด
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.grayligh,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            print('============>> success  <<===========');
                            Navigator.of(context).pop();
                            dialogSuccess();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.primary,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Text(
                                'ส่งใบสมัคร',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // ปุ่ม X ที่มุมขวาบน
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด dialog
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dialogSuccess() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 100,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Success title
              Text(
                'สำเร็จ!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Success message
              Text(
                'ส่งใบสมัครเรียบร้อยแล้ว',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textdark,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextRow({
    required String title,
    required String sub,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            sub,
            style: TextStyle(
              fontSize: 16,

              // fontWeight: FontWeight.w600,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _buildTextRowPrimary({
    required String title,
    required String sub,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            sub,
            style: TextStyle(
              fontSize: 16,

              // fontWeight: FontWeight.w600,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary_gold,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.textdark,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary_gold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
