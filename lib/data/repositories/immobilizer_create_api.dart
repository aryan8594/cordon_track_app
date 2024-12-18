// ignore_for_file: depend_on_referenced_packages, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/immobilizer_create_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ImmobilizerCreateRepository{
    final Ref ref;
    ImmobilizerCreateRepository(this.ref);
    DateTime scheduledTime = DateTime.now(); 
    String scheduleName = ""; 
    String vehicleCount = "1"; 
Future<ImmobilizerCreateModel?> fetchImmobilizerCreate( String vehicleArray, String event ) async{
  String token = ref.watch(tokenProvider.notifier).state;
  try{
    var immobilizerCreateURL = Uri.parse('https://cordontrack.com/api/v1/immobilize/create');
    final map = <String, dynamic>{};
    map['schedule_time'] = '${scheduledTime.toIso8601String()}';
    map['schedule_name'] = '$scheduleName';
    map['vehicle_count'] = '$vehicleCount';
    map['vehicle_array'] = '["${vehicleArray}"]';
    map['event'] = '$event';

    var response = await http.post(
      immobilizerCreateURL,
      headers: {
      'token': '$token',},
      body: map,

    );

    if (response.statusCode == 200) {

        log('Data sent to Immobilizer create');
        log(response.body);
        return ImmobilizerCreateModel.fromJson(jsonDecode(response.body));
        
    } else {
      log('Failed to ImmobilizerCreate API');
      return null;
    }

  }catch (e) {
      log("Exception caught at ImmobilizerCreate API: $e");
      return null;
  }
  }
}