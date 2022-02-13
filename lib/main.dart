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
        primarySwatch: Colors.blue,
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

const url_string = 'https://opentdb.com/api.php?amount=10';

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Question>> futureQuestions;

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse(url_string));
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

  int index = 0;
  List<String>? answers;
  late Stats stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            child: const Icon(Icons.bar_chart),

            onPressed: () {
              var saveStats = stats;
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => StatsPage(saveStats)));

              setState(() {
                stats = Stats();
              });
            },
          ),
          visible: stats.totalAttempts > 0,
        ),
        body: FutureBuilder<List<Question>>(
          future: futureQuestions,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var question = snapshot.data![index];
              return Column(
                children: [
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
                            title: Text(question.answers[i]),
                            onTap: () {
                              var correct =
                                  question.correct == question.answers[i];
                              _showMyDialog(correct);
                              setState(() {
                                stats.registerAttempt(correct);

                                if (correct) index++;

                                if (index >= snapshot.data!.length) {
                                  index = 0;
                                  futureQuestions = fetchQuestions();
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError)
              return Text(snapshot.error.toString());
            return Column(
              children: [Center(child: CircularProgressIndicator())],
            );
          },
        ));
  }

  Future<void> _showMyDialog(bool correct) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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

String _parseHtmlString(String htmlString) => htmlParser.DocumentFragment.html(htmlString).text.toString();