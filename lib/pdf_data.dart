//class for the data on the PDF
import 'package:intl/intl.dart';

//Output Class to output data on the PDF file
class Output {
  //Sets the time period by obtainig the current date and subtracting 30 days from it
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

  //Formats the output displayed on the pdf page with the dates and analytics
  Output(String lowAlerts, String highAlerts, String noWaterDays) {
    this.period = 'Time Period: ${this.setDate()}';
    this.lowAlerts = 'Number of Low Alerts: $lowAlerts';
    this.highAlerts = 'Number of High Alerts: $highAlerts';
    this.noWaterDays = 'Number of Days without water: $noWaterDays';
  }
}
