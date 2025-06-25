import 'package:flutter/services.dart';

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel('device_info_channel');

  static Future<Map<String, dynamic>?> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod('getDeviceInfo');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get device info: '${e.message}'");
      return null;
    }
  }
}
