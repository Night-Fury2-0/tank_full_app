//class for the data on the PDF
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

class Output {
  String setDate() {
    var now = DateTime.now();
    var formatter = DateFormat('MMM-dd-yyyy');
    var date = DateTime(now.year, now.month, now.day - 30);
    String formattedDate = formatter.format(date);
    String currentDate = formatter.format(now);
    return '${formattedDate} to ${currentDate}';
  }

  String period = '';
  String lowAlerts = '';
  String highAlerts = '';
  String noWaterDays = '';

  Output(String lowAlerts, String highAlerts, String noWaterDays) {
    this.period = 'Time Period: ${this.setDate()}';
    this.lowAlerts = 'Number of Low Alerts: $lowAlerts';
    this.highAlerts = 'Number of High Alerts: $highAlerts';
    this.noWaterDays = 'Number of Days without water: $noWaterDays';
  }
}
