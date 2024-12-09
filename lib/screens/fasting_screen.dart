import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_metric_model.dart';
import '../services/storage_service.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startTime;
  DateTime? _endTime;
  String? _notes;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set both start and end times')),
        );
        return;
      }

      if (_endTime!.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      final duration = _endTime!.difference(_startTime!).inHours;
      final metric = HealthMetric(
        id: DateTime.now().toIso8601String(),
        type: MetricType.fasting,
        value: duration.toDouble(),
        startTime: _startTime,
        endTime: _endTime,
        duration: duration,
        timestamp: DateTime.now(),
        notes: _notes,
      );

      try {
        await Provider.of<StorageService>(context, listen: false)
            .addMetric(metric);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fasting period saved successfully')),
          );
          _formKey.currentState!.reset();
          setState(() {
            _startTime = null;
            _endTime = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving fasting period: $e')),
          );
        }
      }
    }
  }

  Future<DateTime?> _showDateTimePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
    return null;
  }

  String _getFastingCategory() {
    if (_startTime == null || _endTime == null) return 'Not Started';
    final hours = _endTime!.difference(_startTime!).inHours;
    if (hours < 12) return 'Short Fast';
    if (hours < 16) return 'Intermediate Fast';
    if (hours < 24) return 'Extended Fast';
    return 'Long-term Fast';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fasting Tracker'),
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
                        'Record Fasting Period',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Start Time'),
                        subtitle: Text(_startTime?.toString() ?? 'Not set'),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await _showDateTimePicker();
                            if (picked != null) {
                              setState(() {
                                _startTime = picked;
                              });
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('End Time'),
                        subtitle: Text(_endTime?.toString() ?? 'Not set'),
                        trailing: IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final picked = await _showDateTimePicker();
                            if (picked != null) {
                              setState(() {
                                _endTime = picked;
                              });
                            }
                          },
                        ),
                      ),
                      if (_startTime != null && _endTime != null) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.timer),
                          title: Text(
                            'Duration: ${_endTime!.difference(_startTime!).inHours} hours',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_getFastingCategory()),
                        ),
                      ],
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
                label: const Text('Save Fasting Period'),
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
