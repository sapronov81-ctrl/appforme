import 'package:flutter/material.dart';

class TheoryCard extends StatefulWidget {
  final void Function(List<bool>) onDone;
  const TheoryCard({super.key, required this.onDone});

  @override
  State<TheoryCard> createState() => _TheoryCardState();
}

class _TheoryCardState extends State<TheoryCard> {
  final List<bool> answers = List<bool>.filled(12, false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Теория (4 блока × 3 вопроса)', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (ctx, bi) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Блок ${bi+1}', style: Theme.of(context).textTheme.titleMedium),
                        for (int qi=0;qi<3;qi++) CheckboxListTile(
                          value: answers[bi*3+qi],
                          onChanged: (v)=>setState(()=>answers[bi*3+qi]=v??false),
                          title: Text('Вопрос ${qi+1} — (заполним позже)')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          FilledButton.icon(
            onPressed: ()=>widget.onDone(answers),
            icon: const Icon(Icons.assignment_turned_in),
            label: const Text('Завершить теорию'),
          )
        ],
      ),
    );
  }
}
