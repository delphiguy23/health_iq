# HealthIQ - Personal Health Metrics Tracker

## Overview
HealthIQ is a Flutter-based mobile application designed to help users track and manage their personal health metrics. The app provides a simple, intuitive interface for recording and monitoring various health indicators including blood sugar levels, blood pressure readings, and dietary intake.

## Features

### 1. Health Metrics Tracking
- **Blood Sugar Monitoring**
  - Record blood glucose levels
  - Track readings over time
  - View historical data

- **Blood Pressure Management**
  - Log systolic and diastolic readings
  - Monitor pressure trends
  - Track readings history

- **Diet Tracking**
  - Record food intake
  - Track caloric intake
  - Add notes for meals

### 2. Document Management
- Upload and store health-related documents
- Organize medical records
- Easy access to important health files

### 3. Settings & Data Management
- Clear all data option
- About app information
- Data backup capabilities

## Technical Details

### Dependencies
```yaml
dependencies:
  flutter: ^2.18.4
  shared_preferences: ^2.0.15
  provider: ^6.0.5
  file_picker: ^5.3.1
  path_provider: ^2.0.15
  http: ^0.13.5
  intl: ^0.18.1
```

### Architecture
- **State Management**: Provider pattern
- **Data Persistence**: SharedPreferences
- **File Storage**: Local device storage
- **UI Framework**: Material Design (Material 2)

## Setup & Installation

### Prerequisites
1. Flutter SDK (version 2.18.4 or higher)
2. Dart SDK (compatible with Flutter version)
3. Android Studio/VS Code with Flutter extensions

### Installation Steps
1. Clone the repository:
   ```bash
   git clone [repository-url]
   ```

2. Navigate to project directory:
   ```bash
   cd health_iq
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Production
1. For Android:
   ```bash
   flutter build apk --release
   ```

2. For iOS:
   ```bash
   flutter build ios --release
   ```

3. For Web:
   ```bash
   flutter build web --release
   ```

## Project Structure
```
lib/
├── main.dart              # App entry point
├── models/               
│   └── health_metric_model.dart
├── screens/
│   ├── health_tracking_screen.dart
│   ├── document_upload_screen.dart
│   └── settings_screen.dart
└── services/
    ├── storage_service.dart
    └── document_service.dart
```

## Known Issues & Future Improvements

### Current Limitations
- Local storage only (no cloud sync)
- Limited data visualization
- Basic metric types

### Planned Features
1. Advanced Data Visualization
   - Graphs and charts
   - Trend analysis
   - Statistical insights

2. Enhanced Health Metrics
   - Weight tracking
   - Exercise logging
   - Medication reminders

3. Cloud Integration
   - Data backup
   - Cross-device sync
   - Sharing capabilities

4. Advanced Analytics
   - Health trends
   - Predictive insights
   - Custom reports

## Troubleshooting

### Common Issues
1. **Blank Screen**
   - Clear app data
   - Reinstall the app
   - Check Flutter version compatibility

2. **Data Not Saving**
   - Verify storage permissions
   - Check available device storage
   - Clear app cache

3. **Performance Issues**
   - Reduce stored data volume
   - Clear old records
   - Update Flutter version

### Debug Mode
Run in debug mode for detailed logs:
```bash
flutter run --debug
```

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contact
For support or queries, please contact [your-email]

---
Built with ❤️ using Flutter
