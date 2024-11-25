import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/daily_report_model.dart';
import 'package:http/http.dart' as http;

class DailyReportRepository {
  final String token = "8fce96fe1288a2c2b5affeba94201267"; // Replace with dynamic token if required
  final String start = "0";
  final String length = "100";
  final String draw = "5";

  Future<dynamic> fetchDailyReport({

    required DateTime fromDate,
    required DateTime toDate,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/daily?start=${start}&length=${length}&from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}&draw=${draw}&id=${id}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Daily report API fetched.");
      final jsonData = jsonDecode(response.body);
      return DailyReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch daily report: ${response.reasonPhrase}");
    }
  }
}
