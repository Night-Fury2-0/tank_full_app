//Changing data, therefore a stateful widget must be used
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_data.dart';
import 'package:flutter/services.dart';

//This is the statefull widget class
//Extends means we're inheriting from the StateFulWifget class
class Graph extends StatefulWidget {
  //Graph({super.key});
  final String graphTitle;
  List<GraphData> data;
  Graph(
      {super.key,
      required this.graphTitle,
      required this.data}); //Constructor of the graph class. Takes graph title and graph data

  @override
  State<Graph> createState() =>
      _GraphState(); //Creates a State object and links it to the Stateful Widget
}

//This is a state object.
//In here we define data, and it can change state over time.
//Whenever the data changes, it rebuilds the widget tree (Container and whatever is in it)
class _GraphState extends State<Graph> {
  @override

  //Build function
  Widget build(BuildContext context) {
    //Returns a widget. So when we use the Graph widget, it returns Container, along with whatever is in there
    return Scaffold(
        body: SfCartesianChart(
            tooltipBehavior: TooltipBehavior(
                enable: true,
                header: 'Liters'), //For the coordinate pop-op thing
            zoomPanBehavior: ZoomPanBehavior(
              //Enable zoom features
              enableMouseWheelZooming: true,
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: "Days"),
            ),
            primaryYAxis: NumericAxis(title: AxisTitle(text: "Liters")),
            title: ChartTitle(
                text: widget
                    .graphTitle), //widget.graphTitle is a way to get the variable parameter accepted in Graph
            series: <ChartSeries<GraphData, String>>[
          //Area chart is the type of graph that was used
          AreaSeries(
              dataSource:
                  widget.data, //Uses "data" variable accepted in constructor
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 33, 184, 243),
                Color.fromARGB(255, 3, 115, 244)
              ]),
              opacity: 0.75,
              xValueMapper: (GraphData data, _) =>
                  data.day, //Uses "day" memeber of graph class for x-axis
              yValueMapper: (GraphData data, _) =>
                  data.liter), //Uses "liter" member of graph class for y-axis
        ]));
  }
}

class GraphFullView extends StatefulWidget {
  const GraphFullView({super.key, this.minigraph});
  final Widget?
      minigraph; //minigraph is the "variable" that accepts the graph for fullview

  @override
  State<GraphFullView> createState() => _GraphFullViewState();
}

class _GraphFullViewState extends State<GraphFullView> {
  @override
  void initState() {
    //this forces the full view graph to landscape mode
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  //
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Full View'),
      ),
      body: Container(
        child: widget
            .minigraph, //calls the graph that is passed into GraphFullView
      ),
    );
  }

  @override
  dispose() {
    //This returns the app to portrait mode after exiting full view graph
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

//Function used to build the graph on a full page when fullscreen button is clicked
void onTapExpand(BuildContext context, Widget graph) {
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => GraphFullView(
                minigraph: graph,
              )));
}
