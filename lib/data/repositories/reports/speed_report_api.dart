// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/speed_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SpeedReportRepository {
  final String start = "0";
  final String length = "100";
  final String draw = "5";
  final Ref ref;
  SpeedReportRepository(this.ref);

  Future<dynamic> fetchSpeedReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String speed,
  }) async {
    String token = ref.watch(tokenProvider.notifier).state;
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
