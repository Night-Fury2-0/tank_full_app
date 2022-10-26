//Changing data, therefore a stateful widget must be used
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//This is the statefull widget class
//Extends means we're inheriting from the StateFulWifget class
class Graph extends StatefulWidget {
  //Graph({super.key});
  final String graphTitle;
  const Graph({super.key, required this.graphTitle});

  @override
  State<Graph> createState() =>
      _GraphState(); //Creates a State object and links it to the Stateful Widget
}

//This is a state object
//In here we define data, and it can change state over time.
//Whenever the data changes, it rebuilds the widget tree (Container and whatever is in it)
class _GraphState extends State<Graph> {
  List<GraphData> data = [
    GraphData('Sept 1st', 12),
    GraphData('Sept 2nd', 13),
    GraphData('Sept 3rd', 12),
    GraphData('Sept 4th', 6),
    GraphData('Sept 5th', 4),
    GraphData('Sept 6th', 5),
    GraphData('Sept 7th', 14),
    GraphData('Sept 8th', 16),
    GraphData('Sept 9th', 13),
    GraphData('Sept 10th', 9),
    GraphData('Sept 11th', 12),
    GraphData('Sept 12th', 15)
  ];
  @override

  //Build function
  Widget build(BuildContext context) {
    //Returns a widget. So when we use the Graph widget, it returns Containe, along with whatever is in there
    return Scaffold(
        body: SfCartesianChart(
            primaryXAxis: CategoryAxis(), //what does this do?
            title: ChartTitle(
                text: widget
                    .graphTitle), //widget.graphTitle is a way to get the variable parameter accepted in Graph
            series: <ChartSeries<GraphData, String>>[
          LineSeries(
              dataSource: data,
              xValueMapper: (GraphData data, _) => data.day,
              yValueMapper: (GraphData data, _) => data.liter)
        ]));
  }
}

//Create a class just for data
class GraphData {
  GraphData(this.day, this.liter);

  String day;
  double liter;
}
