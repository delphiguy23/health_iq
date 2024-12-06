import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DocumentService {
  static const String _documentsKey = 'documents';
  final SharedPreferences _prefs;

  DocumentService(this._prefs);

  Future<List<Map<String, dynamic>>> getDocuments() async {
    final String? documentsJson = _prefs.getString(_documentsKey);
    if (documentsJson == null) return [];

    final List<dynamic> documentsList = jsonDecode(documentsJson);
    return List<Map<String, dynamic>>.from(documentsList);
  }

  Future<void> uploadDocument(String filePath, String fileName) async {
    final documents = await getDocuments();
    documents.add({
      'name': fileName,
      'path': filePath,
      'uploadDate': DateTime.now().toIso8601String(),
    });

    await _saveDocuments(documents);
  }

  Future<void> deleteDocument(String fileName) async {
    final documents = await getDocuments();
    documents.removeWhere((doc) => doc['name'] == fileName);
    await _saveDocuments(documents);
  }

  Future<void> _saveDocuments(List<Map<String, dynamic>> documents) async {
    final String documentsJson = jsonEncode(documents);
    await _prefs.setString(_documentsKey, documentsJson);
  }

  Future<void> clearAllDocuments() async {
    await _prefs.remove(_documentsKey);
  }
}
