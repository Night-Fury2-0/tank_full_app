//Library for global variables

library my_prj.globals;

import 'package:flutter/foundation.dart';
import 'graph_data.dart';

bool NotificationState = true;
bool ThemeMode = false;
Uint8List imageInFlow = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]);
Uint8List imageOutFlow = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]);

List<GraphData> inFlow = <GraphData>[];
List<GraphData> outFlow = <GraphData>[];
List<double> Tankdata = [];

int upperCount = 0;
int lowerCount = 0;
