enum MetricType { bloodSugar, bloodPressure, diet }

class HealthMetric {
  final String id;
  final MetricType type;
  final double value;
  final double? systolic;  // For blood pressure
  final double? diastolic; // For blood pressure
  final String? foodItem;  // For diet
  final int? calories;     // For diet
  final DateTime timestamp;
  final String? notes;

  HealthMetric({
    required this.id,
    required this.type,
    required this.value,
    this.systolic,
    this.diastolic,
    this.foodItem,
    this.calories,
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
      foodItem: json['foodItem'] as String?,
      calories: json['calories'] as int?,
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
      'foodItem': foodItem,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  String getStatus() {
    switch (type) {
      case MetricType.bloodSugar:
        return _analyzeBloodSugar(value);
      case MetricType.bloodPressure:
        if (systolic != null && diastolic != null) {
          return _analyzeBloodPressure(systolic!, diastolic!);
        }
        return 'unknown';
      case MetricType.diet:
        return 'recorded';
    }
  }

  static String _analyzeBloodSugar(double value) {
    // Based on general guidelines for blood sugar levels (mg/dL)
    if (value < 70) return 'low';
    if (value >= 70 && value <= 140) return 'normal';
    return 'high';
  }

  static String _analyzeBloodPressure(double systolic, double diastolic) {
    // Based on American Heart Association guidelines
    if (systolic < 90 || diastolic < 60) return 'low';
    if (systolic <= 120 && diastolic <= 80) return 'normal';
    if (systolic <= 129 && diastolic < 80) return 'elevated';
    if (systolic <= 139 || diastolic <= 89) return 'high stage 1';
    return 'high stage 2';
  }
}
