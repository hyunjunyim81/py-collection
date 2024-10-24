import 'dart:collection';

import 'package:real_estate/api/table/excel_reader.dart';
import 'package:real_estate/service/collection_step.dart';

class CollectionService
{
  final Queue<CollectionStep> _steps = Queue<CollectionStep>();
  bool _isRunning = false;
  bool _isExcute = false;

  Future<void> init() async {
    var vList = await ExcelReader.village();
    for (var v in vList) {
      for (var dong in v.dongList) {
        _steps.addLast(CollectionStep(gu: v.gu, dong: dong));
      }
    }
  }

  void start() async {
    if (_isRunning) return;
    _isRunning = true;
    _collecting(this);
  }

  void end() async {
    if (!_isRunning) return;
    await cancel();
  }

  Future<void> cancel() async {
    _isRunning = false;
    await Future.doWhile(() {
      return _isExcute ==  true;
    });
  }

  static void _collecting(CollectionService service) async {
    if (!service._isRunning) {
      service._isExcute = false;
      return;
    }
    service. _isExcute = true;
    var step = service._steps.first;
    var isComplete = await step.next();
    if (isComplete) {
      step.complete();
      service._steps.removeFirst();
      service._steps.addLast(step);
    }
    await Future.delayed(const Duration(milliseconds: 300));
    _collecting(service);
  }
}