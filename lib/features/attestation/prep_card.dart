import 'package:flutter/material.dart';

class PrepCard extends StatefulWidget {
  final void Function(List<Map<String,String>> drinks) onNext;
  const PrepCard({super.key, required this.onNext});

  @override
  State<PrepCard> createState() => _PrepCardState();
}

class _PrepCardState extends State<PrepCard> {
  bool appearance=false, workspace=false, cleanliness=false;
  final List<Map<String,String>> drinks = [];

  void _addDrink() {
    if (drinks.length>=6) return;
    drinks.add({'name':'', 'volume':''});
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Подготовительная карточка', style: Theme.of(context).textTheme.titleLarge),
          CheckboxListTile(value: cleanliness, onChanged: (v)=>setState(()=>cleanliness=v??false), title: const Text('Чистота рабочих зон, оборудования и инвентаря')),
          CheckboxListTile(value: appearance, onChanged: (v)=>setState(()=>appearance=v??false), title: const Text('Внешний вид бариста')),
          CheckboxListTile(value: workspace, onChanged: (v)=>setState(()=>workspace=v??false), title: const Text('Организация рабочего пространства')),
          const SizedBox(height: 8),
          Text('Напитки для оценки (до 6):'),
          for (int i=0;i<drinks.length;i++) Row(children: [
            Expanded(child: TextField(onChanged: (v)=>drinks[i]['name']=v, decoration: const InputDecoration(labelText: 'Название'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(onChanged: (v)=>drinks[i]['volume']=v, decoration: const InputDecoration(labelText: 'Объём'))),
            IconButton(onPressed: (){drinks.removeAt(i); setState((){});}, icon: const Icon(Icons.delete_outline))
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: _addDrink, icon: const Icon(Icons.add), label: const Text('Добавить напиток')),
          const Spacer(),
          FilledButton.icon(
            onPressed: ()=>widget.onNext(drinks),
            icon: const Icon(Icons.timer),
            label: const Text('Старт практики (15 мин) → Оценка напитков'),
          ),
        ],
      ),
    );
  }
}
