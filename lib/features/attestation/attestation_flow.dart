import 'package:flutter/material.dart';
import 'start_card.dart';
import 'prep_card.dart';
import 'drinks_card.dart';
import 'theory_card.dart';
import 'result_card.dart';

class AttestationFlow extends StatefulWidget {
  const AttestationFlow({super.key});

  @override
  State<AttestationFlow> createState() => _AttestationFlowState();
}

class _AttestationFlowState extends State<AttestationFlow> {
  int index = 0;
  String barista = '';
  String cafe = '';
  DateTime date = DateTime.now();

  List<Map<String, String>> selectedDrinks = [];
  int practiceSeconds = 0;
  List<Map<String, dynamic>> drinkScores = [];
  List<bool> theory = List<bool>.filled(12, false);

  void next() => setState(() => index++);
  void stopTimer(int seconds) => practiceSeconds = seconds;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StartCard(onNext: (b,c,d){barista=b; cafe=c; date=d; next();}),
      PrepCard(onNext: (drinks){selectedDrinks=drinks; next();}),
      DrinksCard(drinks: selectedDrinks, onDone: (scores, seconds){drinkScores=scores; stopTimer(seconds); next();}),
      TheoryCard(onDone: (answers){theory=answers; next();}),
      ResultCard(
        barista: barista,
        cafe: cafe,
        date: date,
        practiceSeconds: practiceSeconds,
        drinkScores: drinkScores,
        theory: theory,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Аттестация')),
      body: pages[index],
    );
  }
}
