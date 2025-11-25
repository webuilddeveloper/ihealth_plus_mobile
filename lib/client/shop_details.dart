import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/ihealth/course/course.dart';
import 'package:ihealth_2025_mobile/shared/api_provider.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';

class ShopDetail extends StatefulWidget {
  ShopDetail({super.key, required this.shopId});

  String? shopId;

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  dynamic model = {};

  @override
  void initState() {
    _callReadShop();
    super.initState();
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
          'รายละเอียด',
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
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(api + (model?['image'] ?? '')),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  model?['massage_name'] ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        model?['massage_type'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "sarabun",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightgreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        model?['details'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "sarabun",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textdark,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${model?['house_number'] ?? ''} ${model?['moo'] ?? ''} ${model?['alley'] ?? ''} ${model?['road'] ?? ''} ${model?['subdistrict'] ?? ''} ${model?['district'] ?? ''} ${model?['province'] ?? ''} ${model?['postal_code'] ?? ''}',
                      style: TextStyle(
                        color: AppColors.textdark,
                        fontFamily: "sarabun",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: AppColors.textdark,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${model?['time_text'] ?? ''}',
                      style: TextStyle(
                        color: AppColors.textdark,
                        fontFamily: "sarabun",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.textdark,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${model?['day_of_week_text'] ?? ''}',
                      style: TextStyle(
                        color: AppColors.textdark,
                        fontFamily: "sarabun",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
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
        child: SafeArea(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => {isFavorite()},
                child: Icon(
                  (model['is_favorite'] ?? false)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  size: 40,
                  color: (model['is_favorite'] ?? false) ? Colors.red : AppColors.primary,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.map_outlined,
                size: 40,
                color: AppColors.primary,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // _launchUrl(job['url']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'จองทันที',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  _callReadShop() async {
    // https://api-ihealth.spl-system.com/api/v1/customer/detail-massage?booking_date=&massage_info_id=36b3535f-2458-4105-abe1-e23400e663b9
    get(api +
            'api/v1/customer/detail-massage?booking_date=&massage_info_id=${widget.shopId}')
        .then(
      (v) => {
        setState(() {
          model = v['massage_info'];
          print('>>>><<<<<< ${v}');
        }),
      },
    );
  }

  isFavorite() async {
    post(api + '/api/v1/customer/favorites', {'massage_info_id': model['uuid']})
        .then(
      (v) => {
        setState(() {
          model['is_favorite'] = v['isFavorite'];
        }),
      },
    );
    // final dioService = DioService();
    // await dioService.init();
    // final dio = dioService.dio;

    // var response = await dio.request(
    //   'https://api-ihealth.spl-system.com/api/v1/customer/favorites',
    //   options: Options(
    //     method: 'POST',
    //     headers: headers,
    //   ),
    //   data: data,
    // );
  }
}
