import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PdfApi {
  static Future<File> saveDocument({
    String name,
    Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<File> loadNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    print(bytes);
    return _storeFile(url, bytes);
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final path = url.split("?");
    final fileNames = filename.split("?");

    final names = fileNames[0];
    final name = names.split("%2F")[1];
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future openFileFromUrl(String url) async {
    File file = await loadNetwork(url);
    openFile(file);
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
