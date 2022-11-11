import 'dart:collection';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:syncfusion_flutter_charts/charts.dart';

/*
//Function to create a list in order to pass into the graph
List<GraphData> getdata(String path) {
  Map<String, double> graphLables = {};
  List<GraphData> dataTest = <GraphData>[];
  List<double> data = [];

  LoadingData object = LoadingData();

  object.setter();

  print(object);


  for (int i = 0; i < 30; i++) {
    data.add(double.parse(splitted[i]));
  }

  //Populates the map with dates of past 30 days from today, and random values as "liters"
  for (int i = 29; i >= 0; i--) {
    //Gets current day
    var now = DateTime.now();
    //Formats the data to Month-Day
    var formatter = DateFormat('dd-MM');
    //Gets past 30 days using 'i'
    var date = DateTime(now.year, now.month, now.day - i);

    //Creates string of the date and formats it
    String formattedDate = formatter.format(date);
    //Adding pairs to the map (using a random generator for liter values)
    graphLables[formattedDate] = data[i];
  }

  //Populate list with the dates and values from the map
  for (final mapEntry in graphLables.entries) {
    dataTest.add(GraphData(mapEntry.key, mapEntry.value));
  }

  return dataTest;
}
*/
//Create a class just for data
class GraphData {
  GraphData(this.day, this.liter);

  String day;
  double liter;
}
