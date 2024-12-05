import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/health_metric_model.dart';
import '../services/storage_service.dart';

class HealthTrackingScreen extends StatefulWidget {
  const HealthTrackingScreen({super.key});

  @override
  State<HealthTrackingScreen> createState() => _HealthTrackingScreenState();
}

class _HealthTrackingScreenState extends State<HealthTrackingScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  List<HealthMetric> _metrics = [];
  MetricType _selectedType = MetricType.bloodSugar;
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _foodItemController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _foodItemController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMetrics() async {
    try {
      final storageService = Provider.of<StorageService>(context, listen: false);
      final metrics = await storageService.getMetrics();
      if (mounted) {
        setState(() {
          _metrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading metrics: $e')),
        );
      }
    }
  }

  Future<void> _saveMetric() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final metric = HealthMetric(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        value: double.parse(_valueController.text),
        systolic: _selectedType == MetricType.bloodPressure
            ? double.parse(_systolicController.text)
            : null,
        diastolic: _selectedType == MetricType.bloodPressure
            ? double.parse(_diastolicController.text)
            : null,
        foodItem: _selectedType == MetricType.diet ? _foodItemController.text : null,
        calories: _selectedType == MetricType.diet
            ? int.parse(_caloriesController.text)
            : null,
        timestamp: DateTime.now(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      await Provider.of<StorageService>(context, listen: false).addMetric(metric);
      await _loadMetrics();

      if (mounted) {
        _formKey.currentState!.reset();
        _valueController.clear();
        _systolicController.clear();
        _diastolicController.clear();
        _foodItemController.clear();
        _caloriesController.clear();
        _notesController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metric saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving metric: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Health Metric',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MetricType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Metric Type',
                          border: OutlineInputBorder(),
                        ),
                        items: MetricType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_selectedType == MetricType.bloodSugar) ...[
                        TextFormField(
                          controller: _valueController,
                          decoration: const InputDecoration(
                            labelText: 'Blood Sugar Level',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ] else if (_selectedType == MetricType.bloodPressure) ...[
                        TextFormField(
                          controller: _systolicController,
                          decoration: const InputDecoration(
                            labelText: 'Systolic Pressure',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter systolic pressure';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _diastolicController,
                          decoration: const InputDecoration(
                            labelText: 'Diastolic Pressure',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter diastolic pressure';
                            }
                            return null;
                          },
                        ),
                      ] else if (_selectedType == MetricType.diet) ...[
                        TextFormField(
                          controller: _foodItemController,
                          decoration: const InputDecoration(
                            labelText: 'Food Item',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter food item';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _caloriesController,
                          decoration: const InputDecoration(
                            labelText: 'Calories',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter calories';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes (Optional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveMetric,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Save Metric'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Metrics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (_metrics.isEmpty)
                      const Center(
                        child: Text('No metrics recorded yet'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _metrics.length,
                        itemBuilder: (context, index) {
                          final metric = _metrics[index];
                          return Card(
                            child: ListTile(
                              title: Text(metric.type.toString().split('.').last),
                              subtitle: Text(
                                'Value: ${metric.value}\n'
                                'Date: ${metric.timestamp.toString().split('.')[0]}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await Provider.of<StorageService>(context, listen: false)
                                      .deleteMetric(metric.id);
                                  await _loadMetrics();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
