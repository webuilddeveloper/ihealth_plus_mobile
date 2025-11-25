import 'package:flutter/material.dart';
import 'package:ihealth_2025_mobile/ihealth/appcolor.dart';
import 'package:ihealth_2025_mobile/shared/api_provider_ihealth.dart';
import 'package:ihealth_2025_mobile/shared/dio_service.dart';
import 'package:ihealth_2025_mobile/shared/extension.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class NotificationClientForm extends StatefulWidget {
  NotificationClientForm({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  _NotificationClientForm createState() => _NotificationClientForm();
}

class _NotificationClientForm extends State<NotificationClientForm> {
  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    if (widget.model != null && widget.model['noti_id'] != null) {
      try {
        final apiProvider = await ApiProviderIhealth.getInstance();
        var response = await apiProvider.get('v1/notify?role=customer/${widget.model['noti_id']}');
        print('Notification ${widget.model['noti_id']} marked as read.');
      } catch (e) {
        print("Error marking notification as read: $e");
      }
    }
  }

  String formatDateTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      final formatter = DateFormat('dd-MM-yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return isoDateStringToDisplayDate(dateString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดการแจ้งเตือน',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: widget.model == null
            ? Center(child: Text('ไม่พบข้อมูล'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model['title'] ?? 'ไม่มีหัวข้อ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          color: Colors.grey[600], size: 16),
                      SizedBox(width: 8),
                      Text(
                        formatDateTime(widget.model['createdAt']),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Text(
                    'รายละเอียด:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textdark,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.model['message'] ?? 'ไม่มีข้อความ',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (widget.model['booking_id'] != null) ...[
                    Text(
                      'รหัสการจอง: ${widget.model['booking_id']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ]
                ],
              ),
      ),
    );
  }
}
