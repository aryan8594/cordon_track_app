import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/ignition_report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class IgnitonReportRepository {
  final String start = "0";
  final String length = "100";
  final String draw = "5";
  final Ref ref;
  IgnitonReportRepository(this.ref);

  Future<dynamic> fetchIgnitionReport({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,

  }) async {
    String token = ref.watch(tokenProvider.notifier).state;

    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/ignition?start=${start}&length=${start}&id=${id}&from_date=${fromDate.toIso8601String()}&to_date=${toDate.toIso8601String()}&draw=${draw}"),
      headers: {
        "token": token,
      },
    );

    if (response.statusCode == 200) {
      log("Ignition report API fetched.");
      final jsonData = jsonDecode(response.body);
      return IgnitionReportModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch idle report: ${response.reasonPhrase}");
    }
  }
}
