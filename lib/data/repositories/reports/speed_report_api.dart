import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/models/reports/speed_report_model.dart';
import 'package:http/http.dart' as http;

class SpeedReportRepository {
  final String token = "8fce96fe1288a2c2b5affeba94201267"; // Replace with a dynamic token if needed
  final String start = "0";
  final String length = "100";
  final String draw = "5";

  Future<dynamic> fetchSpeedReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String speed,
  }) async {

    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/speed?start=${start}&length=${length}&id=${id}&from_date=${fromDate.toString()}&to_date=${toDate.toString()}&draw=${draw}&speed=${speed.toString()}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Speed Report API fey=tched");
      final jsonData = jsonDecode(response.body);
      return SpeedReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch speed report: ${response.reasonPhrase}");
    }
  }
}
