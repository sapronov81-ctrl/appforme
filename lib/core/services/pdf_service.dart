import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class PdfService {
  static Future<File> createAuditPdf({
    required String title,
    required Map<String, dynamic> data,
    List<File> photos = const [],
  }) async {
    final pdf = pw.Document();
    final df = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => [
          pw.Header(level: 0, child: pw.Text(title, style: pw.TextStyle(fontSize: 22))),
          pw.Text('Сформировано: ${df.format(DateTime.now())}'),
          pw.SizedBox(height: 8),
          ...data.entries.map((e) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(e.key, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text(e.value.toString()),
                  pw.SizedBox(height: 6),
                ],
              )),
          if (photos.isNotEmpty) pw.Header(text: 'Фото'),
          if (photos.isNotEmpty)
            pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in photos)
                  pw.Container(
                    width: 180,
                    height: 120,
                    child: pw.Image(pw.MemoryImage(await f.readAsBytes()), fit: pw.BoxFit.cover),
                  )
              ],
            )
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audit_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> createAttestationPdf({
    required String title,
    required Map<String, dynamic> data,
  }) async {
    final pdf = pw.Document();
    final df = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => [
        pw.Header(level: 0, child: pw.Text(title, style: pw.TextStyle(fontSize: 22))),
        pw.Text('Сформировано: ${df.format(DateTime.now())}'),
        pw.SizedBox(height: 8),
        ...data.entries.map((e) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(e.key, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(e.value.toString()),
                pw.SizedBox(height: 6),
              ],
            )),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/attestation_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
