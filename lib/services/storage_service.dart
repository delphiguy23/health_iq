import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_metric_model.dart';

class StorageService {
  static const String _metricsKey = 'health_metrics';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<List<HealthMetric>> getMetrics() async {
    final String? metricsJson = _prefs.getString(_metricsKey);
    if (metricsJson == null) return [];

    final List<dynamic> metricsList = jsonDecode(metricsJson);
    return metricsList.map((json) => HealthMetric.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> addMetric(HealthMetric metric) async {
    final metrics = await getMetrics();
    metrics.add(metric);
    await _saveMetrics(metrics);
  }

  Future<void> deleteMetric(String id) async {
    final metrics = await getMetrics();
    metrics.removeWhere((metric) => metric.id == id);
    await _saveMetrics(metrics);
  }

  Future<void> _saveMetrics(List<HealthMetric> metrics) async {
    final String metricsJson = jsonEncode(metrics.map((m) => m.toJson()).toList());
    await _prefs.setString(_metricsKey, metricsJson);
  }

  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
