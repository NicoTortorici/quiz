// Tortorici Nico, 5CIA, 13/02/2022

class Question {
  String question;
  List<String> answers;
  String correct;
  String type;
  String category;
  int difficulty;

  Question(
      {required this.question,
      required this.answers,
      required this.correct,
      required this.type,
      required this.difficulty,
      required this.category});

  // Trasforma i dati json in un oggetto Question.
  factory Question.fromJson(Map<String, dynamic> json) {
    var list = List<String>.from(json['incorrect_answers']);
    list.add(json['correct_answer']);
    // Bisogna mischiare le risposte, altrimenti quella corretta sarà sempre
    // alla fine.
    list.shuffle();
    return Question(
        question: json['question'],
        answers: list,
        correct: json['correct_answer'],
        category: json['category'],
        difficulty: _convertDifficulty(json['difficulty']),
        type: json['type']);
  }

  static int _convertDifficulty(String value) {
    switch (value) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 2;
    }
  }
}
