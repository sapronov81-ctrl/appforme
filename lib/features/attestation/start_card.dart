import 'package:flutter/material.dart';

class StartCard extends StatefulWidget {
  final void Function(String barista, String cafe, DateTime date) onNext;
  const StartCard({super.key, required this.onNext});

  @override
  State<StartCard> createState() => _StartCardState();
}

class _StartCardState extends State<StartCard> {
  final _name = TextEditingController();
  final _cafe = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Привет! Готовы к аттестации?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'ФИО бариста')),
          TextField(controller: _cafe, decoration: const InputDecoration(labelText: 'Кафе')),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final d = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: _date);
              if (d!=null) setState(()=>_date=d);
            },
            icon: const Icon(Icons.date_range),
            label: Text('Дата аттестации: ${_date.toLocal().toString().split(' ').first}'),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: ()=>widget.onNext(_name.text, _cafe.text, _date),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Готов поработать'),
          )
        ],
      ),
    );
  }
}
