import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/idle_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class IdleReportRepository {
    final String start = "0";
  final String length = "100";
  final String draw = "5";
  final Ref ref;
IdleReportRepository(this.ref);
  Future<dynamic> fetchIdleReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String time,
  }) async {
    String token = ref.watch(tokenProvider.notifier).state;

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
