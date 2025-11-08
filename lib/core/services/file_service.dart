import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileService {
  static final _uuid = const Uuid();

  static Future<File> saveBytes(List<int> bytes, {String ext = 'jpg'}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${_uuid.v4()}.$ext');
    return file.writeAsBytes(bytes);
  }

  static Future<bool> deletePath(String path) async {
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
