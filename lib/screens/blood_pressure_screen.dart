import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_metric_model.dart';
import '../services/storage_service.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  final _formKey = GlobalKey<FormState>();
  double _systolic = 120;
  double _diastolic = 80;
  String? _notes;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final metric = HealthMetric(
        id: DateTime.now().toIso8601String(),
        type: MetricType.bloodPressure,
        value: _systolic, // Using systolic as the main value
        systolic: _systolic,
        diastolic: _diastolic,
        timestamp: DateTime.now(),
        notes: _notes,
      );

      try {
        await Provider.of<StorageService>(context, listen: false)
            .addMetric(metric);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blood pressure reading saved successfully')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _systolic = 120;
            _diastolic = 80;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving reading: $e')),
          );
        }
      }
    }
  }

  String _getPressureCategory() {
    if (_systolic < 90 || _diastolic < 60) return 'Low Blood Pressure';
    if (_systolic <= 120 && _diastolic <= 80) return 'Normal';
    if (_systolic <= 129 && _diastolic < 80) return 'Elevated';
    if (_systolic <= 139 || _diastolic <= 89) return 'High Blood Pressure (Stage 1)';
    return 'High Blood Pressure (Stage 2)';
  }

  Color _getCategoryColor() {
    if (_systolic < 90 || _diastolic < 60) return Colors.blue;
    if (_systolic <= 120 && _diastolic <= 80) return Colors.green;
    if (_systolic <= 129 && _diastolic < 80) return Colors.yellow;
    if (_systolic <= 139 || _diastolic <= 89) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Blood Pressure Reading',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Systolic Pressure (mmHg)',
                          helperText: 'Upper number',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _systolic.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter systolic pressure';
                          }
                          final number = double.tryParse(value);
                          if (number == null || number < 0) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _systolic = double.parse(value!);
                        },
                        onChanged: (value) {
                          final number = double.tryParse(value);
                          if (number != null) {
                            setState(() {
                              _systolic = number;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Diastolic Pressure (mmHg)',
                          helperText: 'Lower number',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: _diastolic.toString(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter diastolic pressure';
                          }
                          final number = double.tryParse(value);
                          if (number == null || number < 0) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _diastolic = double.parse(value!);
                        },
                        onChanged: (value) {
                          final number = double.tryParse(value);
                          if (number != null) {
                            setState(() {
                              _diastolic = number;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getCategoryColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getCategoryColor(),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _getCategoryColor(),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getPressureCategory(),
                                style: TextStyle(
                                  color: _getCategoryColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onSaved: (value) {
                          _notes = value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Save Reading'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
