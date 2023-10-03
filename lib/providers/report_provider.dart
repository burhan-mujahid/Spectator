import 'package:flutter/foundation.dart';

import '../models/report_model.dart';
import '../user_screens/edit_complaint_screen.dart';

class ReportProvider extends ChangeNotifier {
  Report? _report;

  Report? get report => _report;

  void updateReport(Report updatedReport) {
    _report = updatedReport;
    notifyListeners();
  }
}
