import 'package:flutter/material.dart';

class DemoState extends ChangeNotifier {
  int _step = 0;
  int get step => _step;

  void nextStep() {
    _step = (_step + 1) % 3;
    notifyListeners();
  }
}
