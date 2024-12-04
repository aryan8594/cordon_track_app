import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/reports/travelled_path_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class TravelledPathRepository {
  final String start = "0";
  final String length = "500";
  final String draw = "3";
  final Ref ref;
  TravelledPathRepository(this.ref);

  Future<dynamic> fetchTravelledPath({
    required String id,
    required DateTime fromDate,
    required DateTime toDate,
    required String timeDifference,
  }) async {
    String token = ref.watch(tokenProvider.notifier).state;
    final response = await http.get(
      Uri.parse("https://cordontrack.com/api/v1/report/travelled_path?id=$id&from_date=${fromDate.toString()}&to_date=${toDate.toString()}&start=${start}&length=${length}&draw=${draw}&time_difference=${timeDifference}"),
      headers: {"token": token},
    );

    if (response.statusCode == 200) {
      log("travelleed path report api fetched");
      final jsonData = jsonDecode(response.body);
      return TravelledPathModel.fromJson(jsonData);
      
    } else {
      throw Exception(
          "Failed to fetch travelled path: ${response.statusCode} ${response.reasonPhrase}");
    }
  }
}
