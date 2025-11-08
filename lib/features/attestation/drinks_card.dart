import 'dart:async';
import 'package:flutter/material.dart';

class DrinksCard extends StatefulWidget {
  final List<Map<String,String>> drinks;
  final void Function(List<Map<String,dynamic>> scores, int practiceSeconds) onDone;
  const DrinksCard({super.key, required this.drinks, required this.onDone});

  @override
  State<DrinksCard> createState() => _DrinksCardState();
}

class _DrinksCardState extends State<DrinksCard> {
  late List<Map<String,dynamic>> scores;
  late Timer timer;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    scores = widget.drinks.map((e)=>{
      'name': e['name']??'', 'volume': e['volume']??'',
      'standard': false, 'volumeOk': false, 'tasteOk': false, 'visualOk': false, 'tempOk': false,
      'comment': '', 'photos': <String>[],
    }).toList();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => seconds++);
    });
  }

  @override
  void dispose() { timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    String mmss(int s){final m=(s~/60).toString().padLeft(2,'0'); final ss=(s%60).toString().padLeft(2,'0'); return '$m:$ss';}
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children:[
            Text('Практика · Таймер: ${mmss(seconds)}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 12),
            const Text('(до 15 минут — +1 балл)'),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: scores.length,
              itemBuilder: (ctx, i) {
                final s = scores[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${s['name']} · ${s['volume']}', style: Theme.of(context).textTheme.titleMedium),
                        CheckboxListTile(value: s['standard'], onChanged: (v){setState(()=>s['standard']=v??false);}, title: const Text('Стандарт подачи')),
                        CheckboxListTile(value: s['volumeOk'], onChanged: (v){setState(()=>s['volumeOk']=v??false);}, title: const Text('Объём')),
                        CheckboxListTile(value: s['tasteOk'], onChanged: (v){setState(()=>s['tasteOk']=v??false);}, title: const Text('Вкус')),
                        CheckboxListTile(value: s['visualOk'], onChanged: (v){setState(()=>s['visualOk']=v??false);}, title: const Text('Внешний вид')),
                        CheckboxListTile(value: s['tempOk'], onChanged: (v){setState(()=>s['tempOk']=v??false);}, title: const Text('Температура')),
                        TextField(onChanged: (v)=>s['comment']=v, decoration: const InputDecoration(labelText: 'Комментарий')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          FilledButton.icon(
            onPressed: (){ timer.cancel(); widget.onDone(scores, seconds); },
            icon: const Icon(Icons.navigate_next),
            label: const Text('Далее → Теория'),
          )
        ],
      ),
    );
  }
}
