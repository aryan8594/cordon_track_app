import 'dart:convert';
import 'dart:developer';

import 'package:cordon_track_app/data/models/login_model.dart';
import 'package:http/http.dart' as http;

String? savedToken;
Future<LoginModel?> userLogin(String user, String password) async {
  try {
    var logurl = Uri.parse("https://cordontrack.com/api/v1/auth/login/");
    var logres = await http.post(logurl, body: {
      "username": user,
      "password": password,
    });
    if (logres.statusCode == 200) {
      var jsonResponse = jsonDecode(logres.body);

      log(logres.body);

      if (jsonResponse['status'] == true) {
        LoginModel model = LoginModel.fromJson(jsonResponse);
        savedToken = model.token;
        log("Auth Token : " + "${model.token}");
        log('Login successfully');
        return model;
      } else {
        log("Login failed: ${jsonResponse['message']}");
      }
    } else{
      log("Failed with status code: ${logres.statusCode}");
    }
  } catch (e) {
    print(e);
  }
  return null;

}
