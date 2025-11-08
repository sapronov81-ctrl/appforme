import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

/// Универсальный сервис для генерации PDF файлов
class PdfService {
  /// Создание PDF для аудита
  static Future<File> createAuditPdf({
    required String title,
    required Map<String, dynamic> data,
    required Map<String, List<File>> photos,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          final content = <pw.Widget>[
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
          ];

          // Добавляем текстовые данные аудита
          data.forEach((key, value) {
            content.add(pw.Text('$key: $value'));
          });

          // Добавляем фото
          photos.forEach((section, files) {
            content.add(pw.SizedBox(height: 20));
            content.add(pw.Text(
              section,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ));

            for (final f in files) {
              try {
                final bytes = f.readAsBytesSync();
                content.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    height: 200,
                    child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
                  ),
                );
              } catch (_) {
                content.add(pw.Text('Ошибка при загрузке фото: ${f.path}'));
              }
            }
          });

          return content;
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audit_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Создание PDF для аттестации
  static Future<File> createAttestationPdf({
    required String title,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          final widgets = <pw.Widget>[
            pw.Center(
              child: pw.Text(
                title,
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
          ];

          data.forEach((k, v) {
            widgets.add(pw.Text('$k: $v'));
          });

          return widgets;
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/attestation_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
