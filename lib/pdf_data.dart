//class for the data on the PDF

class Output {
  String period = '';
  String lowAlerts = '';
  String highAlerts = '';
  String noWaterDays = '';

  Output(String period, String lowAlerts, String highAlerts, String noWaterDays) {
    this.period = 'Time Period: $period';
    this.lowAlerts = 'Number of Low Alerts: $lowAlerts';
    this.highAlerts = 'Number of High Alerts: $highAlerts';
    this.noWaterDays = 'Number of Days without water: $noWaterDays';
  }
}
