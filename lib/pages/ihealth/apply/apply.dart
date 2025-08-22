import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/pages/ihealth/apply/apply-detail.dart';

class Apply extends StatefulWidget {
  final List<Map<String, dynamic>> job;
  const Apply({super.key, required this.job});

  @override
  State<Apply> createState() => _ApplyState();
}

class _ApplyState extends State<Apply> {
  String? selectedProvinceId;
  String? selectedDistrictId;
  String? selectedJobCategoryId;
  String? selectedMainTypeId;
  String? selectedSubTypeId;

  String selectType = '1';
  int itemsToShow = 10;
  bool isFilterExpanded = false;

  final List<Map<String, dynamic>> mockProvinces = [
    {"id": "10", "name": "กรุงเทพมหานคร"},
    {"id": "50", "name": "เชียงใหม่"},
    {"id": "40", "name": "ขอนแก่น"},
  ];

  final List<Map<String, dynamic>> mockDistricts = [
    {"id": "1001", "province_id": "10", "name": "เขตดินแดง"},
    {"id": "1002", "province_id": "10", "name": "เขตบางกะปิ"},
    {"id": "5001", "province_id": "50", "name": "อำเภอเมืองเชียงใหม่"},
    {"id": "5002", "province_id": "50", "name": "อำเภอสันทราย"},
    {"id": "4001", "province_id": "40", "name": "อำเภอเมืองขอนแก่น"},
    {"id": "4002", "province_id": "40", "name": "อำเภอบ้านฝาง"},
  ];

  final List<Map<String, dynamic>> mockJobCategories = [
    {"id": "1", "name": "สปา"},
    {"id": "2", "name": "นวดเพื่อสุขภาพ"},
    {"id": "3", "name": "นวดเพื่อเสริมความงาม"},
  ];

  final List<Map<String, dynamic>> mockMainTypes = [
    {"id": "1", "category_id": "1", "name": "การยริการด้วยน้ำ"},
    {"id": "2", "category_id": "1", "name": "บริการอื่นๆ"},
    {"id": "3", "category_id": "2", "name": "test"},
    {"id": "4", "category_id": "2", "name": "test"},
  ];

  final List<Map<String, dynamic>> mockSubTypes = [
    {"id": "1", "main_type_id": "1", "name": "test1"},
    {"id": "2", "main_type_id": "1", "name": "test2"},
    {"id": "3", "main_type_id": "2", "name": "test3"},
    {"id": "4", "main_type_id": "2", "name": "test4"},
    {"id": "5", "main_type_id": "3", "name": "test5 "},
    {"id": "6", "main_type_id": "3", "name": "test6"},
  ];

  // Filtered Lists
  List<Map<String, dynamic>> get filteredDistricts {
    if (selectedProvinceId == null) return [];
    return mockDistricts
        .where((d) => d['province_id'] == selectedProvinceId)
        .toList();
  }

  List<Map<String, dynamic>> get filteredMainTypes {
    if (selectedJobCategoryId == null) return [];
    return mockMainTypes
        .where((m) => m['category_id'] == selectedJobCategoryId)
        .toList();
  }

  List<Map<String, dynamic>> get filteredSubTypes {
    if (selectedMainTypeId == null) return [];
    return mockSubTypes
        .where((s) => s['main_type_id'] == selectedMainTypeId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'สมัครงาน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          selectType == "1"
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isFilterExpanded = !isFilterExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFilterExpanded
                            ? AppColors.primary
                            : AppColors.lightgreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color:
                            isFilterExpanded ? Colors.white : Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ),
                )
              : SizedBox()
        ],
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: tabController(),
          ),
          selectType == "1"
              ? Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: isFilterExpanded ? Filter() : SizedBox(),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Expanded(
            child: selectType == "1" ? announcement() : applied(),
          ),
        ],
      ),
    );
  }

  Widget tabController() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectType = '1';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectType == '1'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'ประกาศรับสมัคร',
                    style: TextStyle(
                      color:
                          selectType == '1' ? Colors.white : AppColors.textdark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectType = '2';
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selectType == '2'
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'งานที่สมัครแล้ว',
                    style: TextStyle(
                      color:
                          selectType == '2' ? Colors.white : AppColors.textdark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Filter() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Row 1: จังหวัด + อำเภอ
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  value: selectedProvinceId,
                  hint: 'จังหวัด',
                  items: mockProvinces,
                  onChanged: (value) {
                    setState(() {
                      selectedProvinceId = value;
                      selectedDistrictId = null;
                    });
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: buildDropdown(
                  value: selectedDistrictId,
                  hint: 'อำเภอ',
                  items: filteredDistricts,
                  onChanged: selectedProvinceId == null
                      ? null
                      : (value) {
                          setState(() {
                            selectedDistrictId = value;
                          });
                        },
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Row 2: หมวดสมัครงาน
          buildDropdown(
            value: selectedJobCategoryId,
            hint: 'หมวดสมัครงาน',
            items: mockJobCategories,
            onChanged: (value) {
              setState(() {
                selectedJobCategoryId = value;
                selectedMainTypeId = null;
                selectedSubTypeId = null;
              });
            },
          ),
          SizedBox(height: 12),

          // Row 3: ประเภทหลัก + ประเภทย่อย
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  value: selectedMainTypeId,
                  hint: 'ประเภทหลัก',
                  items: filteredMainTypes,
                  onChanged: selectedJobCategoryId == null
                      ? null
                      : (value) {
                          setState(() {
                            selectedMainTypeId = value;
                            selectedSubTypeId = null;
                          });
                        },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: buildDropdown(
                  value: selectedSubTypeId,
                  hint: 'ประเภทย่อย',
                  items: filteredSubTypes,
                  onChanged: selectedMainTypeId == null
                      ? null
                      : (value) {
                          setState(() {
                            selectedSubTypeId = value;
                          });
                        },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Buttons: ค้นหา + ล้างตัวกรอง
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isFilterExpanded = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'ค้นหา',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: clearAllFilters,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.clear, size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'ล้าง',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({
    required String? value,
    required String hint,
    required List<Map<String, dynamic>> items,
    required Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['id'],
          child: Text(
            item['name'],
            style: TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  void clearAllFilters() {
    setState(() {
      selectedProvinceId = null;
      selectedDistrictId = null;
      selectedJobCategoryId = null;
      selectedMainTypeId = null;
      selectedSubTypeId = null;
    });
  }

  Widget announcement() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: widget.job.length,
      itemBuilder: (context, index) {
        final job = widget.job[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(job['imgUrl'] ?? ''),
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
                                    job['title'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${job['count'] ?? ''} จำนวน',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              job['company'] ?? '',
                              style: TextStyle(
                                color: AppColors.textdark,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.textdark,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  job['location'] ?? '',
                                  style: TextStyle(
                                    color: AppColors.textdark,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    job['working_hours'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightgreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              job['salary'] ?? '',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            job['Date'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplyDetail(job: job),
                                ),
                              );
                            },
                            child: Text(
                              'ดูรายละเอียด',
                              style: TextStyle(
                                color: AppColors.primary_gold,
                                fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  Widget applied() {
    // หาว่ามีงานไหนที่มีค่า status ไหม
    final hasStatus = widget.job.any(
      (job) => job["status"] != null && job["status"].toString().isNotEmpty,
    );

    if (hasStatus) {
      // แสดงงานทั้งหมดที่มี status
      return ListView.builder(
        itemCount: widget.job.length,
        itemBuilder: (context, index) {
          final status = widget.job[index]["status"]?.toString() ?? "";
          final job = widget.job[index];
          if (status.isNotEmpty) {
            // return

            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(job['imgUrl'] ?? ''),
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
                                        job['title'] ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${job['count'] ?? ''} จำนวน',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  job['company'] ?? '',
                                  style: TextStyle(
                                    color: AppColors.textdark,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: AppColors.textdark,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      job['location'] ?? '',
                                      style: TextStyle(
                                        color: AppColors.textdark,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        job['working_hours'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightgreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  job['salary'] ?? '',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'สถานะ :',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: job["status"] == 'ยังไม่ประกาศผล'
                                        ? AppColors.grayligh
                                        : job["status"] == "ผ่านการคัดเลือก"
                                            ? Colors.green
                                            : Colors.red),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${job["status"]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink(); // ไม่แสดงถ้า status ว่าง
          }
        },
      );
    } else {
      // ถ้าไม่มีงานที่มี status เลย
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'ยังไม่มีงานที่สมัครแล้ว',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'เมื่อคุณสมัครงานแล้ว จะแสดงรายการที่นี่',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }
  }
  // Widget applied() {
  //   return
  //   // final jobstatus = widget.job;
  //   // return Text(widget.job[0]["status"]);
  //   // Center(
  //   //   child: Column(
  //   //     mainAxisAlignment: MainAxisAlignment.center,
  //   //     children: [
  //   //       Icon(
  //   //         Icons.work_off,
  //   //         size: 80,
  //   //         color: Colors.grey[400],
  //   //       ),
  //   //       SizedBox(height: 16),
  //   //       Text(
  //   //         'ยังไม่มีงานที่สมัครแล้ว',
  //   //         style: TextStyle(
  //   //           fontSize: 18,
  //   //           color: Colors.grey[600],
  //   //           fontWeight: FontWeight.w500,
  //   //         ),
  //   //       ),
  //   //       SizedBox(height: 8),
  //   //       Text(
  //   //         'เมื่อคุณสมัครงานแล้ว จะแสดงรายการที่นี่',
  //   //         style: TextStyle(
  //   //           fontSize: 14,
  //   //           color: Colors.grey[500],
  //   //         ),
  //   //       ),
  //   //     ],
  //   //   ),
  //   // );
  // }
}
