enum MetricType
{
  bloodSugar,
  bloodPressure,
  fasting
}

class HealthMetric {
  final String id;
  final MetricType type;
  final double value;
  final double? systolic;  // For blood pressure
  final double? diastolic; // For blood pressure
  final DateTime? startTime;  // For fasting
  final DateTime? endTime;    // For fasting
  final int? duration;        // For fasting (in hours)
  final DateTime timestamp;
  final String? notes;

  HealthMetric({
    required this.id,
    required this.type,
    required this.value,
    this.systolic,
    this.diastolic,
    this.startTime,
    this.endTime,
    this.duration,
    required this.timestamp,
    this.notes,
  });

  factory HealthMetric.fromJson(Map<String, dynamic> json) {
    return HealthMetric(
      id: json['id'] as String,
      type: MetricType.values.firstWhere(
        (e) => e.toString().split('.').last == (json['type'] as String).split('.').last,
      ),
      value: (json['value'] as num).toDouble(),
      systolic: json['systolic'] != null ? (json['systolic'] as num).toDouble() : null,
      diastolic: json['diastolic'] != null ? (json['diastolic'] as num).toDouble() : null,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      duration: json['duration'] as int?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'value': value,
      'systolic': systolic,
      'diastolic': diastolic,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  String get displayValue {
    switch (type) {
      case MetricType.bloodSugar:
        return '$value mg/dL';
      case MetricType.bloodPressure:
        return '$systolic/$diastolic mmHg';
      case MetricType.fasting:
        return '${duration ?? 0} hours';
    }
  }

  String get metricName {
    switch (type) {
      case MetricType.bloodSugar:
        return 'Blood Sugar';
      case MetricType.bloodPressure:
        return 'Blood Pressure';
      case MetricType.fasting:
        return 'Fasting';
    }
  }
}
