import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  /// Генерация PDF-отчёта аудита или аттестации
  static Future<File> generateReport({
    required String title,
    required String cafeName,
    required DateTime date,
    required List<String> sections,
    required Map<String, List<File>> photosBySection,
    String? notes,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              title,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text("Кафе: $cafeName"),
          pw.Text("Дата: ${date.toString().split(' ').first}"),
          pw.SizedBox(height: 20),
          if (notes != null) pw.Text("Комментарий: $notes"),

          // --- Секции проверки ---
          for (final section in sections) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              section,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            if (photosBySection.containsKey(section))
              ...await _buildPhotoWidgets(photosBySection[section]!),
          ],
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${title.replaceAll(' ', '_')}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Асинхронное создание виджетов для фото
  static Future<List<pw.Widget>> _buildPhotoWidgets(List<File> files) async {
    final widgets = <pw.Widget>[];
    for (final f in files) {
      try {
        final bytes = await f.readAsBytes();
        widgets.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            height: 200,
            child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
          ),
        );
      } catch (e) {
        widgets.add(
          pw.Text('Ошибка при загрузке изображения: ${f.path}'),
        );
      }
    }
    return widgets;
  }
}
