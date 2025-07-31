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

  int itemsToShow = 10;

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

  List<Map<String, dynamic>> get filteredDistricts {
    if (selectedProvinceId == null) return [];
    return mockDistricts
        .where((d) => d['province_id'] == selectedProvinceId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primary,
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
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.grayligh,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                      ),
                      hintText: 'เลือกจังหวัด',
                      hintStyle: TextStyle(
                        color: AppColors.grayligh,
                        fontSize: 14,
                      ),
                    ),
                    value: selectedProvinceId,
                    hint: Text('เลือกจังหวัด'),
                    items: mockProvinces.map((province) {
                      return DropdownMenuItem<String>(
                        value: province['id'],
                        child: Text(
                          province['name'],
                          style: TextStyle(
                            color: AppColors.textdark,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvinceId = value;
                        selectedDistrictId = null;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),

                // อำเภอ
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.grayligh,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.grayligh, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                      ),
                      hintText: 'เลือกจังหวัด',
                      hintStyle: TextStyle(
                        color: AppColors.grayligh,
                        fontSize: 14,
                      ),
                    ),
                    value: selectedDistrictId,
                    hint: Text('เลือกอำเภอ'),
                    items: filteredDistricts.map((district) {
                      return DropdownMenuItem<String>(
                        value: district['id'],
                        child: Text(
                          district['name'],
                          style: TextStyle(
                            color: AppColors.textdark,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrictId = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: itemsToShow,
                itemBuilder: (context, index) {
                  if (index >= widget.job.length) return null;

                  final job = widget.job[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
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
                                      image: NetworkImage(job['imgUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              job['title'],
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              job['type'],
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        job['company'],
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
                                            job['location'],
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
                                              job['working_hours'],
                                              style: TextStyle(
                                                color: Colors.grey[500],
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
                                        job['salary'],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      job['postedDate'],
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
                                            builder: (context) =>
                                                ApplyDetail(job: job),
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
              ),
            ),
          ],
        ),
      ),
      // Container(
      //   decoration: BoxDecoration(
      //     color: AppColors.primary,
      //   ),
      //   padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
      //   child: TextField(
      //     // controller: txtSearch,
      //     // onChanged: searchData,
      //     style: TextStyle(color: Colors.white),
      //     decoration: InputDecoration(
      //       filled: true,
      //       fillColor: Colors.white.withOpacity(0.2),
      //       hintText: 'ค้นหาจากชื่อบริษัท',
      //       hintStyle: TextStyle(color: Colors.white70),
      //       prefixIcon: Icon(Icons.search, color: Colors.white),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(12),
      //         borderSide: BorderSide.none,
      //       ),
      //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //     ),
      //   ),
      // ),
    );
  }
}
