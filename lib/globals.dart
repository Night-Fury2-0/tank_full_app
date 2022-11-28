//Library for global variables

library my_prj.globals;

import 'package:flutter/foundation.dart';
import 'graph_data.dart';

//Used to enable or disable the settings
bool NotificationState = true;
bool ThemeMode = false;

//Variables to save the screenshots of the graphs on the homescreen and render it on the downsloads page
Uint8List imageInFlow = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]);
Uint8List imageOutFlow = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]);

//Used to save the Raw Data for the graph so that the graph function could
//be called on the nav bar page to take the screen shot
List<GraphData> inFlow = <GraphData>[];
List<GraphData> outFlow = <GraphData>[];
List<double> Tankdata = [];

int upperCount = 0;
int lowerCount = 0;
int noWaterCount = 0;
