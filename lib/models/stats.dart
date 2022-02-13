// Tortorici Nico, 5CIA, 13/02/2022

import 'package:charts_flutter/flutter.dart';

class Stats {
  int _totalQuestions = 0;
  int _correctAtFirst = 0;
  int _totalAttempts = 0;

  bool firstAttempt = true;

  void registerAttempt(bool correct) {
    _totalAttempts++;
    if (firstAttempt) _totalQuestions++;

    if (correct ) {

      if (firstAttempt)
        _correctAtFirst++;
      firstAttempt = true;
    } else firstAttempt = false;

    print("correct: ${_correctAtFirst.toDouble()}");
    print("incorrect: ${incorrect}");
    print("total: ${_totalQuestions.toDouble()}");
    print('percentage: ${(( _correctAtFirst.toDouble()) / (_totalQuestions.toDouble()))}');
  }

  int get totalAttempts => _totalAttempts;

  int get correct => _correctAtFirst;

  int get incorrect => _totalQuestions - correct;

  int get percentage
    => ( ( correct.toDouble()) / (_totalQuestions.toDouble()) * 100).toInt();

  double get averageAttempts
      => (_totalAttempts.toDouble() / _totalQuestions.toDouble());
}

class ChartData {
  String title;
  int value;
  Color color;

  ChartData(this.title, this.value, this.color);
}
