import 'package:flutter/material.dart';
import '../../core/services/pdf_service.dart';

class ResultCard extends StatelessWidget {
  final String barista; final String cafe; final DateTime date;
  final int practiceSeconds; final List<Map<String,dynamic>> drinkScores; final List<bool> theory;
  const ResultCard({super.key, required this.barista, required this.cafe, required this.date, required this.practiceSeconds, required this.drinkScores, required this.theory});

  int get practicePoints => drinkScores.fold(0, (acc, s) => acc + ['standard','volumeOk','tasteOk','visualOk','tempOk'].where((k)=>s[k]==true).length);
  int get theoryPoints => theory.where((e)=>e).length; // 12 макс
  int get bonus => 0; // бонусы можно добавить из PrepCard позже

  Future<void> _pdf(BuildContext context) async {
    final m = <String, dynamic>{
      'Бариста': barista,
      'Кафе': cafe,
      'Дата': date.toString().split(' ').first,
      'Практика (баллы)': practicePoints,
      'Теория (баллы)': theoryPoints,
      'Бонус (скорость <=15мин)': ((practiceSeconds<=15*60)?1:0),
      'Время практики (сек)': practiceSeconds,
      'Итого баллы': practicePoints + theoryPoints + ((practiceSeconds<=15*60)?1:0),
    };

    final f = await PdfService.createAttestationPdf(title: 'Результат аттестации', data: m);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF создан: ${f.path}')));
  }

  @override
  Widget build(BuildContext context) {
    final total = practicePoints + theoryPoints + ((practiceSeconds<=15*60)?1:0);
    final max = (drinkScores.length*5) + 12 + 1; // 5 критериев/напиток + теория 12 + скорость 1
    final percent = (max==0)?0:(total*100/max).round();

    String grade;
    if (percent>=95) grade = 'Универсал';
    else if (percent>=90) grade = 'Старший бариста';
    else if (percent>=85) grade = 'Джуниор';
    else grade = 'Не сдано';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Результат', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Баллы практика: $practicePoints'),
          Text('Баллы теория: $theoryPoints'),
          Text('Бонус: ${((practiceSeconds<=15*60)?1:0)}'),
          Text('Время практики: ${(practiceSeconds/60).toStringAsFixed(1)} мин'),
          Text('Итого: $total / $max  (≈ $percent%)'),
          const SizedBox(height: 12),
          Text('Результат: $grade'),
          const Spacer(),
          Wrap(spacing: 8, children: [
            FilledButton.icon(onPressed: ()=>_pdf(context), icon: const Icon(Icons.picture_as_pdf), label: const Text('Отчёт (PDF)')),
          ])
        ],
      ),
    );
  }
}
