// models/fasting_record.dart
class FastingRecord {
  final int? id;
  final String date;
  final String startTime;
  final String endTime;
  final bool success;

  FastingRecord({
    this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.success,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'success': success ? 1 : 0,
    };
  }

  factory FastingRecord.fromMap(Map<String, dynamic> map) {
    return FastingRecord(
      id: map['id'],
      date: map['date'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      success: map['success'] == 1,
    );
  }

  FastingRecord copyWith({
    int? id,
    String? date,
    String? startTime,
    String? endTime,
    bool? success,
  }) {
    return FastingRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      success: success ?? this.success,
    );
  }
}
