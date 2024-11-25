import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/idle_report_model.dart';
import 'package:http/http.dart' as http;

class IdleReportRepository {
  final String token = "8fce96fe1288a2c2b5affeba94201267"; // Replace with dynamic token if required
    final String start = "0";
  final String length = "100";
  final String draw = "5";

  Future<dynamic> fetchIdleReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String time,
  }) async {

    final response = await http.get(
        Uri.parse("https://cordontrack.com/api/v1/report/idle?start=${start}&length=${length}&id=${id}&from_date=${fromDate.toString()}&to_date=${toDate.toString()}&draw=${draw}&time=${time}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Idle report API fetched.");
      final jsonData = jsonDecode(response.body);
      return IdleReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch idle report: ${response.reasonPhrase}");
    }
  }
}
