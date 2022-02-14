// Tortorici Nico, 5CIA, 13/02/2022

import 'package:charts_flutter/flutter.dart';
import 'package:quiz/models/question.dart';

class Stats {
  int _totalQuestions = 0;
  int _correctAtFirst = 0;
  int _totalAttempts = 0;
  int _lives = 5;
  int _score = 0;

  bool firstAttempt = true;

  void registerAttempt(bool correct, Question question) {
    _totalAttempts++;
    if (firstAttempt) _totalQuestions++;

    if (correct) {
      if (firstAttempt) {
        _correctAtFirst++;
        _score += question.difficulty * 10;
      }
      firstAttempt = true;
    } else {
      if (firstAttempt) _lives--;
      firstAttempt = false;
    }
  }

  int get totalAttempts => _totalAttempts;
  int get correct => _correctAtFirst;
  int get incorrect => _totalQuestions - correct;
  int get score => _score;
  int get percentage =>
      ((correct.toDouble()) / (_totalQuestions.toDouble()) * 100).toInt();
  int get lives => _lives;

  double get averageAttempts =>
      (_totalAttempts.toDouble() / _totalQuestions.toDouble());
}

class ChartData {
  String title;
  int value;
  Color color;

  ChartData(this.title, this.value, this.color);
}
