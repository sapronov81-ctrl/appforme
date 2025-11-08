import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barista_pro/core/services/pdf_service.dart';

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  // Пример данных аудита
  final Map<String, dynamic> data = {
    'Кафе': 'Coffee Lab Downtown',
    'Дата': DateTime.now().toString().split(' ').first,
    'Проверил': 'Иван Петров',
  };

  // Фото по категориям
  final List<File> cleanPhotos = [];
  final List<File> expiryPhotos = [];
  final List<File> drinkPhotos = [];

  bool _isLoading = false;
  File? _pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аудит кафе'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Создать PDF-отчёт по аудиту',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateAuditPdf,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Сформировать отчёт'),
            ),
            const SizedBox(height: 20),
            if (_pdfFile != null)
              Text(
                'PDF готов: ${_pdfFile!.path}',
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAuditPdf() async {
    setState(() => _isLoading = true);

    try {
      // Создаём Map для фото по секциям
      final Map<String, List<File>> photos = {
        'Чистота': cleanPhotos,
        'Сроки годности и маркировка': expiryPhotos,
        'Напитки': drinkPhotos,
      };

      // Генерация PDF
      final pdf = await PdfService.createAuditPdf(
        title: 'Отчёт аудита',
        data: data,
        photos: photos,
      );

      // Сохраняем результат
      final dir = await getApplicationDocumentsDirectory();
      final newPath = '${dir.path}/audit_result.pdf';
      final savedFile = await pdf.copy(newPath);

      setState(() {
        _pdfFile = savedFile;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Ошибка PDF: $e');
      setState(() => _isLoading = false);
    }
  }
}
