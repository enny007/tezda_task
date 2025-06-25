class DeviceInfo {
  final String modelName;
  final String systemVersion;
  final String systemName;
  final String deviceName;

  DeviceInfo({
    required this.modelName,
    required this.systemVersion,
    required this.systemName,
    required this.deviceName,
  });

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      modelName: map['modelName'] ?? 'Unknown',
      systemVersion: map['systemVersion'] ?? 'Unknown',
      systemName: map['systemName'] ?? 'Unknown',
      deviceName: map['deviceName'] ?? 'Unknown',
    );
  }
}
