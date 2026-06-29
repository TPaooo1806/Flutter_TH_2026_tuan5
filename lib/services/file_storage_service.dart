import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  static Future<void> writeData(Map<String, dynamic> data) async {
    final file = await _localFile;
    await file.writeAsString(jsonEncode(data));
  }

  static Future<Map<String, dynamic>> readData() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return {};
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return {};
    }
  }
}
