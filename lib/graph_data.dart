import 'dart:math';
import 'package:intl/intl.dart';

//Function to create a list in order to pass into the graph
List<GraphData> getdata() {
  Map<String, double> graphLables = {};
  var rand = Random();
  List<GraphData> dataTest = <GraphData>[];

  //Populates the map with dates of past 30 days from today, and random values as "liters"
  for (int i = 30; i >= 0; i--) {
    //Gets current day
    var now = DateTime.now();
    //Formats the data to Month-Day
    var formatter = DateFormat('MM-dd');
    //Gets past 30 days using 'i'
    var date = DateTime(now.year, now.month, now.day - i);

    //Creates string of the date and formats it
    String formattedDate = formatter.format(date);
    //Adding pairs to the map (using a random generator for liter values)
    graphLables[formattedDate] = rand.nextInt(300).toDouble();
  }

  //Populate list with the dates and values from the map
  for (final mapEntry in graphLables.entries) {
    dataTest.add(GraphData(mapEntry.key, mapEntry.value));
  }

  print(graphLables);

  return dataTest;
}

//Create a class just for data
class GraphData {
  GraphData(this.day, this.liter);

  String day;
  double liter;
}

void main() {
  getdata();
}
