import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'models/question.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
    /*.then((response) {
      var jsondata = json.decode(response.body);
      this.questions = jsondata['results'];
      return 
    });*/
    List<Question> questions = [];
    var result = json.decode(response.body)['results'] as List<dynamic>;
    result.forEach((value) {
      questions.add(Question.fromJson(value));
    });

    return questions;
  }

  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestions();
  }

  int index = 0;
  List<String>? answers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
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
                      itemCount: question.answers
                          .length, //questions[index]['incorrect_answers'].length,
                      itemBuilder: (context, i) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(question.answers[i]),
                            onTap: () {
                              var correct =
                                  question.correct == question.answers[i];
                              _showMyDialog(correct);
                              setState(() {
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
            return Text('Loading...');
          },
        )
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
        );
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
                Text(correct ? 'Nice job.' : 'Try again!'),
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

String _parseHtmlString(String htmlString) {
  var text = html.Element.span()..appendHtml(htmlString);
  return text.innerText;
}
