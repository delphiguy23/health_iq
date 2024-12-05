import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DocumentService {
  static const String _documentsKey = 'documents';
  final SharedPreferences _prefs;

  DocumentService(this._prefs);

  Future<void> uploadDocument(String filePath, String fileName) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);
    
    final documents = await getDocuments();
    documents.add({
      'name': fileName,
      'data': base64String,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    await _saveDocuments(documents);
  }

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final String? documentsJson = _prefs.getString(_documentsKey);
    if (documentsJson == null) return [];
    
    final List<dynamic> documentsList = json.decode(documentsJson);
    return List<Map<String, dynamic>>.from(documentsList);
  }

  Future<void> _saveDocuments(List<Map<String, dynamic>> documents) async {
    final String documentsJson = json.encode(documents);
    await _prefs.setString(_documentsKey, documentsJson);
  }

  Future<void> deleteDocument(String fileName) async {
    final documents = await getDocuments();
    documents.removeWhere((doc) => doc['name'] == fileName);
    await _saveDocuments(documents);
  }

  Future<String> getLocalPath() async {
    final directory = await Directory.systemTemp.createTemp();
    return directory.path;
  }
}
