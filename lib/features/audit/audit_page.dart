import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/section_card.dart';
import '../../widgets/photo_uploader.dart';
import '../../core/services/pdf_service.dart';

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  final _formKey = GlobalKey<FormState>();
  final _cafe = TextEditingController();
  DateTime _date = DateTime.now();

  bool eqClean = false, storageClean = false, surfaceClean = false;
  String? cleanComment; List<String> cleanPhotos = [];

  bool labelsOk = false, noExpired = false, fifoOk = false;
  String? expComment; List<String> expPhotos = [];

  bool uniform = false, politeness = false, speed = false, standards = false, workplace = false;
  String? stdComment; List<String> stdPhotos = [];

  final _ground = TextEditingController();
  final _time = TextEditingController();
  final _out = TextEditingController();
  String? espressoComment;

  final _drinkName = TextEditingController();
  final _drinkVol = TextEditingController();
  bool dVol=false, dVis=false, dTaste=false, dTemp=false; String? dComment; List<String> dPhotos = [];

  Future<void> _makePdf() async {
    final data = <String, dynamic>{
      'Кафе': _cafe.text,
      'Дата проверки': _date,
      'Чистота': 'Оборудование:${eqClean?1:0}, Хранение:${storageClean?1:0}, Поверхность:${surfaceClean?1:0}. Комментарий:${cleanComment??''}',
      'Сроки/маркировка': 'Маркировки:${labelsOk?1:0}, Просрочка:${noExpired?1:0}, FIFO:${fifoOk?1:0}. Комментарий:${expComment??''}',
      'Стандарты работы': 'Форма:${uniform?1:0}, Вежливость:${politeness?1:0}, Скорость:${speed?1:0}, Стандарты:${standards?1:0}, Организация:${workplace?1:0}. Комментарий:${stdComment??''}',
      'Рецепт эспрессо': 'Помол, г: ${_ground.text}; Время, с: ${_time.text}; Двойной выход, г: ${_out.text}; Комм: ${espressoComment??''}',
      'Напиток': 'Название: ${_drinkName.text}; Объём: ${_drinkVol.text}; Оценки: объём ${dVol?1:0}, визуал ${dVis?1:0}, вкус ${dTaste?1:0}, температура ${dTemp?1:0}. Комм:${dComment??''}',
    };

    final photos = [...cleanPhotos, ...expPhotos, ...stdPhotos, ...dPhotos].map((p) => File(p)).toList();

    final pdf = await PdfService.createAuditPdf(title: 'Отчёт аудита', data: data, photos: photos);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF создан: ${pdf.path}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Аудит')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 96),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(controller: _cafe, decoration: const InputDecoration(labelText: 'Кафе')),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final d = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2100), initialDate: _date);
                      if (d!=null) setState(()=>_date=d);
                    },
                    icon: const Icon(Icons.date_range), label: Text('Дата: ${_date.toLocal().toString().split(' ').first}'),
                  ),
                ],
              ),
            ),

            SectionCard(title: 'Чистота', children: [
              CheckboxListTile(value: eqClean, onChanged: (v)=>setState(()=>eqClean=v??false), title: const Text('Оборудование и инвентарь')),
              CheckboxListTile(value: storageClean, onChanged: (v)=>setState(()=>storageClean=v??false), title: const Text('Зоны хранения')),
              CheckboxListTile(value: surfaceClean, onChanged: (v)=>setState(()=>surfaceClean=v??false), title: const Text('Рабочая поверхность')),
              TextFormField(onChanged: (v)=>cleanComment=v, decoration: const InputDecoration(labelText: 'Комментарий')),
              PhotoUploader(maxCount: 5, paths: cleanPhotos, onChanged: (p)=>setState(()=>cleanPhotos=[...p])),
            ]),

            SectionCard(title: 'Сроки и маркировка', children: [
              CheckboxListTile(value: labelsOk, onChanged: (v)=>setState(()=>labelsOk=v??false), title: const Text('Наличие маркировок')),
              CheckboxListTile(value: noExpired, onChanged: (v)=>setState(()=>noExpired=v??false), title: const Text('Отсутствие просроченных продуктов')),
              CheckboxListTile(value: fifoOk, onChanged: (v)=>setState(()=>fifoOk=v??false), title: const Text('Соблюдение FIFO')),
              TextFormField(onChanged: (v)=>expComment=v, decoration: const InputDecoration(labelText: 'Комментарий')),
              PhotoUploader(maxCount: 5, paths: expPhotos, onChanged: (p)=>setState(()=>expPhotos=[...p])),
            ]),

            SectionCard(title: 'Стандарты работы', children: [
              CheckboxListTile(value: uniform, onChanged: (v)=>setState(()=>uniform=v??false), title: const Text('Чистая форма бариста')),
              CheckboxListTile(value: politeness, onChanged: (v)=>setState(()=>politeness=v??false), title: const Text('Вежливость')),
              CheckboxListTile(value: speed, onChanged: (v)=>setState(()=>speed=v??false), title: const Text('Скорость работы')),
              CheckboxListTile(value: standards, onChanged: (v)=>setState(()=>standards=v??false), title: const Text('Соблюдение рецептур и стандартов')),
              CheckboxListTile(value: workplace, onChanged: (v)=>setState(()=>workplace=v??false), title: const Text('Организация рабочего места')),
              TextFormField(onChanged: (v)=>stdComment=v, decoration: const InputDecoration(labelText: 'Комментарий')),
              PhotoUploader(maxCount: 5, paths: stdPhotos, onChanged: (p)=>setState(()=>stdPhotos=[...p])),
            ]),

            SectionCard(title: 'Рецепт эспрессо', children: [
              TextFormField(controller: _ground, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Вес молотого кофе (г)')),
              TextFormField(controller: _time, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Время экстракции (с)')),
              TextFormField(controller: _out, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Выход двойного эспрессо (г)')),
              TextFormField(onChanged: (v)=>espressoComment=v, decoration: const InputDecoration(labelText: 'Комментарий')),
            ]),

            SectionCard(title: 'Напитки (быстрая проверка одного напитка)', children: [
              TextFormField(controller: _drinkName, decoration: const InputDecoration(labelText: 'Наименование')),
              TextFormField(controller: _drinkVol, decoration: const InputDecoration(labelText: 'Объём')),
              CheckboxListTile(value: dVol, onChanged: (v)=>setState(()=>dVol=v??false), title: const Text('Объём')),
              CheckboxListTile(value: dVis, onChanged: (v)=>setState(()=>dVis=v??false), title: const Text('Визуал')),
              CheckboxListTile(value: dTaste, onChanged: (v)=>setState(()=>dTaste=v??false), title: const Text('Вкус')),
              CheckboxListTile(value: dTemp, onChanged: (v)=>setState(()=>dTemp=v??false), title: const Text('Температура')),
              TextFormField(onChanged: (v)=>dComment=v, decoration: const InputDecoration(labelText: 'Комментарий')),
              PhotoUploader(maxCount: 6, paths: dPhotos, onChanged: (p)=>setState(()=>dPhotos=[...p])),
            ]),

            const SizedBox(height: 12),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _makePdf,
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text('Сформировать отчёт (PDF)'),
      ),
    );
  }
}
