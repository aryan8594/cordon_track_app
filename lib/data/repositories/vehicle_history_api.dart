// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/vehicle_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class HistoryVehicleRepository{
    final Ref ref;
    HistoryVehicleRepository(this.ref);
Future<VehicleHistoryModel?> fetchVehicleHistory( String slectedVehicleID, DateTime fromDate, DateTime toDate) async{
  String token = ref.watch(tokenProvider.notifier).state;
  try{
    var vehicleHistoryURL = Uri.parse('https://cordontrack.com/api/v1/vehicle/route_playback_new');
    final map = <String, dynamic>{};
    map['id'] = '$slectedVehicleID';
    map['from_date'] = '$fromDate';
    map['to_date'] = '$toDate';

    var response = await http.post(
      vehicleHistoryURL,
      headers: {
      'Token': '$token',},
      body: map,

    );

    if (response.statusCode == 200) {

        log('Data Fetched From API for VehicleSpecificHistory');
        return VehicleHistoryModel.fromJson(jsonDecode(response.body));
        
    } else {
      log('Failed to load VehicleSpecificHistory');
      return null;
    }

  }catch (e) {
      log("Exception caught at history API: $e");
      return null;
  }
  }
}