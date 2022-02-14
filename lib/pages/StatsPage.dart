// Tortorici Nico, 5CIA, 13/02/2022

import 'package:flutter/material.dart';
import 'package:quiz/models/stats.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatsPage extends StatelessWidget {
  final Stats _stats;

  StatsPage(this._stats) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: charts.PieChart<String>(
                [
                  charts.Series<ChartData, String>(
                      id: 'Questions',
                      data: [
                        ChartData('Correct', _stats.correct,
                            charts.Color.fromHex(code: '#66bb6a')),
                        ChartData('Incorrect', _stats.incorrect,
                            charts.Color.fromHex(code: '#ef5350'))
                      ],
                      domainFn: (x, _) => x.title,
                      measureFn: (x, _) => x.value,
                      labelAccessorFn: (x, _) => "${x.title}: ${x.value}",
                      colorFn: (x, _) => x.color),
                ],
                defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 200,
                  arcRendererDecorators: [new charts.ArcLabelDecorator()],
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              "Correct: ${_stats.correct}",
            ),
          ),
          Container(
            child: Text(
              "Incorrect: ${_stats.incorrect}",
            ),
          ),
          Container(
            child: Text("Correct percentage: ${_stats.percentage}%"),
          ),
          Container(
            child: Text(
                "Average attempts per answer: ${_stats.averageAttempts.toStringAsFixed(1)}"),
          ),
          Container(
            child: Text(
              "Your Score: ${_stats.score}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            child: Text("Start new quiz"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
