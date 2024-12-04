import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';
import 'package:cordon_track_app/data/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late String savedToken;

// StateNotifier to manage login state
class LoginStateNotifier extends StateNotifier<AsyncValue<LoginModel?>> {
  final Ref ref; // Add a Ref field to access providers
  LoginStateNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      var logurl = Uri.parse("https://cordontrack.com/api/v1/auth/login/");
      var logres = await http.post(logurl, body: {
        "username": username,
        "password": password,
      });

      if (logres.statusCode == 200) {
        var jsonResponse = jsonDecode(logres.body);
        log(logres.body);

        if (jsonResponse['status'] == true) {
          LoginModel model = LoginModel.fromJson(jsonResponse);
          savedToken = model.token!; // Save token globally or to token provider
          ref.read(tokenProvider.notifier).state = savedToken; // Update tokenProvider
          log("Auth Token : ${model.token}");
          state = AsyncValue.data(model); // Set success state
        } else {
          log("Login failed: ${jsonResponse['message']}");
          state = AsyncValue.error(jsonResponse['message'], StackTrace.current);
        }
      } else {
        log("Failed with status code: ${logres.statusCode}");
        state = AsyncValue.error(
          "Failed with status code: ${logres.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      log("Login error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }
}



// Create the provider for login
final loginProvider =
    StateNotifierProvider<LoginStateNotifier, AsyncValue<LoginModel?>>(
        (ref) => LoginStateNotifier(ref));


final tokenProvider = StateProvider<String>((ref) => ""); // Start with an empty string



// Update the tokenProvider after a successful login
// ref.read(tokenProvider.notifier).state = model.token;
//  final token = ref.watch(tokenProvider);
