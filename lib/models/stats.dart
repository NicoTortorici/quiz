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

    // Se è il primo tentativo registriamo sempre la risposta.
    if (firstAttempt) _totalQuestions++;

    if (correct) {
      if (firstAttempt) {
        // Solo i primi tentativi contano per il punteggio.
        _correctAtFirst++;
        _score += question.difficulty * 10;
      }
      firstAttempt = true;
    } else {
      // Se il primo tentativo è sbagliato, sottraiamo una vita.
      if (firstAttempt) _lives--;
      firstAttempt = false;
    }
  }

  // Tutti i getters
  int get totalAttempts => _totalAttempts;
  int get correct => _correctAtFirst;
  // Calcolabile
  int get incorrect => _totalQuestions - correct;
  int get score => _score;
  int get percentage =>
      ((correct.toDouble()) / (_totalQuestions.toDouble()) * 100).toInt();
  int get lives => _lives;
  // Tentativi medi per domanda.
  double get averageAttempts =>
      (_totalAttempts.toDouble() / _totalQuestions.toDouble());
}

// Questo oggetto verrà utilizzato dalla libreria charts_flutter per creare il grafico.
class ChartData {
  String title;
  int value;
  Color color;

  ChartData(this.title, this.value, this.color);
}
