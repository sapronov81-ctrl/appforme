import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

/// Сервис генерации PDF-отчётов для аудита и аттестации бариста.
class PdfService {
  /// Создание PDF-отчёта аудита
  static Future<File> createAuditPdf({
    required String title,
    required Map<String, dynamic> data,
    required Map<String, List<File>> photos,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          final widgets = <pw.Widget>[];

          widgets.add(
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          );

          widgets.add(pw.SizedBox(height: 20));
          widgets.addAll(_buildDataSection(data));
          widgets.add(pw.SizedBox(height: 20));
          widgets.addAll(_buildPhotoSections(photos));

          return widgets;
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/audit_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Создание PDF-отчёта аттестации
  static Future<File> createAttestationPdf({
    required String title,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          final widgets = <pw.Widget>[];

          widgets.add(
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          );

          widgets.add(pw.SizedBox(height: 20));
          widgets.addAll(_buildDataSection(data));

          return widgets;
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/attestation_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Блок текстовых данных
  static List<pw.Widget> _buildDataSection(Map<String, dynamic> data) {
    final widgets = <pw.Widget>[];
    data.forEach((key, value) {
      widgets.add(
        pw.Text('$key: $value', style: const pw.TextStyle(fontSize: 14)),
      );
    });
    return widgets;
  }

  /// Блок фотографий по секциям
  static List<pw.Widget> _buildPhotoSections(Map<String, List<File>> photos) {
    final widgets = <pw.Widget>[];
    photos.forEach((section, files) {
      widgets.add(pw.SizedBox(height: 16));
      widgets.add(
        pw.Text(
          section,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );

      for (final f in files) {
        try {
          final bytes = f.readAsBytesSync();
          widgets.add(
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 8),
              height: 200,
              child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
            ),
          );
        } catch (_) {
          widgets.add(pw.Text('Ошибка загрузки фото: ${f.path}'));
        }
      }
    });
    return widgets;
  }
}
