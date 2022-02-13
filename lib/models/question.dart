// Tortorici Nico, 5CIA, 13/02/2022

class Question {
  String question;
  List<String> answers;
  String correct;
  String type;
  String category;
  String difficulty;

  Question({
    required this.question,
    required this.answers,
    required this.correct,
    required this.type,
    required this.difficulty,
    required this.category});

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = List<String>.from(json['incorrect_answers']);
    list.add(json['correct_answer']);
    list.shuffle();
    return Question(
        question:  json['question'],
        answers: list,
        correct: json['correct_answer'],
        category: json['category'],
        difficulty: json['difficulty'],
        type: json['type']);
  }
}
