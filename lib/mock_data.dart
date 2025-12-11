import 'package:flutter/material.dart';

class InsightService {
  static List<Map<String, dynamic>> getSmartPredictions() {
    return [
      {
        'title': 'تجديد رخصة القيادة',
        'desc': 'تنتهي الصلاحية خلال 3 أيام تجنب الغرامة',
        'icon': Icons.directions_car,
        'color': Colors.red.shade700,
        'priority': 10,
        'days_left': 3,
      },
      {
        'title': 'تجديد جواز السفر',
        'desc': 'تبقى 6 أشهر هل تخطط للسفر قريباً',
        'icon': Icons.flight_takeoff,
        'color': Colors.orange.shade700,
        'priority': 5,
        'days_left': 180,
      },
      {
        'title': 'الفحص الدوري',
        'desc': 'موعدك المقترح بناءً على تاريخ الاستمارة',
        'icon': Icons.build_circle,
        'color': const Color(0xFF007A5E),
        'priority': 3,
        'days_left': 200,
      },
    ];
  }

  static const String encryptedQRData = "ABSHER_SECURE_TOKEN_User_Lina_ID_1020304050_EXP_2026_SIG_X9Y8Z7_ENCRYPTED_KEY_9928374";
}