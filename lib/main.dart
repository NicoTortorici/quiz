// Tortorici Nico, 5CIA, 13/02/2022

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/pages/StatsPage.dart';
import 'dart:convert';
import 'models/question.dart';
import 'models/stats.dart';
import 'package:html/dom.dart' as htmlParser;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const questionsPerRequest = 10;

const urlString = 'https://opentdb.com/api.php?amount=$questionsPerRequest';

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Question>> futureQuestions;
  int index = 0;
  List<String>? answers;
  late Stats stats;

  // Utilizzata per ottenere dati dall'api secondo il metodo: https://docs.flutter.dev/cookbook/networking/fetch-data
  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(urlString));
    //List<Question> questions = [];
    var result = json.decode(response.body)['results'] as List<dynamic>;

    var questions = result.map<Question>((e) => Question.fromJson(e));

    return questions.toList();
  }

  @override
  void initState() {
    super.initState();
    stats = Stats();
    futureQuestions = fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // Visibility viene usato per mostrare/nascondere il tasto per completare
        // il quiz, che non deve essere visibile se non è stato risposto ancora
        // nulla. La condizione è espressa in visible.
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: const Icon(Icons.bar_chart),
            onPressed: () {
              _endQuiz();
            },
          ),
          visible: stats.totalAttempts > 0,
        ),
        // FutureBuilder utilizza una builder function per ricostruire la View
        // quando l'oggetto snapshot cambia, ovvero quando sono ricevuti dei
        // dati oppure un errore.
        body: FutureBuilder<List<Question>>(
          future: futureQuestions,
          builder: (ctx, snapshot) {
            // Si controlla che snapshot abbia dei dati.
            if (snapshot.hasData) {
              var question = snapshot.data![index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text('Lives: ${stats.lives}'),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(_parseHtmlString(question.question)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: question.answers.length,
                      //questions[index]['incorrect_answers'].length,
                      itemBuilder: (context, i) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(_parseHtmlString(question.answers[i])),
                            onTap: () => _checkAnswer(
                                question, i, snapshot.data!.length),
                          ),
                        );
                      },
                    ),
                  ),
                  // Lo skip appare solo dopo aver fatto un tentativo sbagliato.
                  Visibility(
                    visible: !stats.firstAttempt,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lo skip viene considerato come un tentativo sbagliato.
                        stats.registerAttempt(false, question);
                        _skip(snapshot.data!.length);
                      },
                      child: Text('Skip'),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError)
              return Text(snapshot.error.toString());
            // Animazione del caricamento.
            return Column(
              children: [Center(child: CircularProgressIndicator())],
            );
          },
        ));
  }

  // Salta la risposta.
  void _skip(int numOfQuestions) {
    setState(() {
      index++;
      stats.firstAttempt = true;
      // Se sono finito le domande disponibili, se ne ottengono di nuove.
      if (index >= numOfQuestions) {
        futureQuestions = fetchQuestions();
        index = 0;
      }
    });
  }

  // Termina il quiz.
  void _endQuiz() {
    var saveStats = stats;
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => StatsPage(saveStats)));

    // Si resettano le statistiche.
    setState(() {
      stats = Stats();
    });
  }

  void _checkAnswer(Question question, int answer, int numOfQuestions) {
    var correct = question.correct == question.answers[answer];
    _showMyDialog(correct);
    setState(() {
      // Si registra la risposta (corretta/non corretta)
      stats.registerAttempt(correct, question);

      // Se è corretta si passa alla domanda successiva.
      if (correct) _skip(numOfQuestions);
    });

    // Se finiscono le vite, termina il quiz.
    if (stats.lives <= 0) _endQuiz();
  }

  // Mostra un dialogo per dire se la risposta sia giusta o sbagliata.
  Future<void> _showMyDialog(bool correct) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il tasto.
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(correct ? 'Correct' : 'Incorrect!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(correct ? 'Nice job!' : 'Try again!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Interpreta la stringa html.
String _parseHtmlString(String htmlString) =>
    htmlParser.DocumentFragment.html(htmlString).text.toString();
