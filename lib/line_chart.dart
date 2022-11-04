//Changing data, therefore a stateful widget must be used
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'graph_data.dart';
import 'package:flutter/services.dart';

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
  List<GraphData> data = getdata();
  @override

  //Build function
  Widget build(BuildContext context) {
    //Returns a widget. So when we use the Graph widget, it returns Containe, along with whatever is in there
    return Scaffold(
        body: SfCartesianChart(
            backgroundColor: Colors.white,
            tooltipBehavior: TooltipBehavior(enable: true, header: 'Liters'),
            zoomPanBehavior: ZoomPanBehavior(
              enableMouseWheelZooming: true,
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
            ),
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                title: AxisTitle(text: "Liters")), //what does this do?
            title: ChartTitle(
                text: widget
                    .graphTitle), //widget.graphTitle is a way to get the variable parameter accepted in Graph
            series: <ChartSeries<GraphData, String>>[
          AreaSeries(
              dataSource: data,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 33, 184, 243),
                Color.fromARGB(255, 3, 115, 244)
              ]),
              opacity: 0.75,
              xValueMapper: (GraphData data, _) => data.day,
              yValueMapper: (GraphData data, _) => data.liter),
        ]));
  }
}

class GraphFullView extends StatefulWidget {
  const GraphFullView({this.minigraph});
  final Widget? minigraph;

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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Full View'),
      ),
      body: Container(
        child: widget.minigraph,
      ),
    );
  }

  @override
  dispose() {
    //THis returns the app to portrait mode after exiting full view graph
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}

void onTapExpand(BuildContext context, Widget graph) {
  Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => GraphFullView(
                minigraph: graph,
              )));
}
