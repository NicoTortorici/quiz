class Question {
  String question;
  List<String> answers;
  String correct;

  Question(this.question, this.answers, this.correct);

  factory Question.fromJson(Map<String, dynamic> json) {
    var list = List<String>.from(json['incorrect_answers']);
    list.add(json['correct_answer']);
    list.shuffle();
    return Question(json['question'], list, json['correct_answer']);
  }
}
