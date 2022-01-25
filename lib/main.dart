import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  dynamic questions;

  void doGet() {
    http.get(Uri.parse(url_string)).then((response) {
      var jsondata = json.decode(response.body);
      this.questions = jsondata['results'];

      print(this.questions);
      // Qui inserisci il codice opportuno per gestire lo stato:
      setState(() {});

      // debug (esempi di stampa dei dati contenuti nel json)
      print("First question: " + questions[0]['question']);
      print("First correct answer: " + questions[0]['correct_answer']);
      print("Category: " + questions[0]['category']);
    });
  }

  @override
  void initState() {
    doGet();
    super.initState();
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
      body: Column(
        children: [
          Text(this.questions[index]['question']),
          Expanded(
            child: ListView.builder(
              itemCount: questions[index].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Lider'),
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
