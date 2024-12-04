import 'dart:developer';

import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/data/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController userField = TextEditingController();

  TextEditingController passwordField = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        userField.text = prefs.getString('username') ?? '';
        passwordField.text = prefs.getString('password') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    return Scaffold(
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/presentation/assets/caroselBG.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                Image.asset(
                  "lib/presentation/assets/cordon_logo_3.png",
                  scale: 16,
                ),
                const Spacer(),
                Container(
                  height: 495,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: userField,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          PasswordField(
                            autoFocus: false,
                            controller: passwordField,
                            color: Colors.lightBlueAccent,
                            passwordConstraint:
                                r'^[a-zA-Z0-9!@#$%^&*()_+={}\[\]:;"\<>,.?\/\\|`~ -]+$',
                            hintText: 'Password',
                            border: PasswordBorder(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.shade100,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue.shade100,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    width: 2, color: Colors.red.shade200),
                              ),
                            ),
                            errorMessage: "This Field can't be empty.",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const Text("Remember Me"),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (loginState is AsyncLoading)
                            const CircularProgressIndicator(),
                          if (loginState is AsyncError)
                            Text("Error: ${loginState.error}"),
                          if (loginState is AsyncData &&
                              loginState.value != null)
                            const Text("Welcome, Logging you in!"),
                          InkWell(
                            onTap: () async {
                              try {
                                await ref.read(loginProvider.notifier).login(
                                      userField.text.toString(),
                                      passwordField.text.toString(),
                                    );

                                if (rememberMe) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('rememberMe', true);
                                  await prefs.setString(
                                      'username', userField.text);
                                  await prefs.setString(
                                      'password', passwordField.text);
                                } else {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('rememberMe');
                                  await prefs.remove('username');
                                  await prefs.remove('password');
                                }

                                final loginState = ref.read(loginProvider);
                                if (loginState is AsyncData &&
                                    loginState.value != null) {
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/navBar');
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Container(
                              width: 280,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(144, 202, 220, 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(82, 135, 132, 1)
                                          .withOpacity(0.25),
                                      spreadRadius:
                                          9, // Increased spread radius
                                      blurRadius: 15,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.all(15),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //text
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  //Icon
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Icon(
                                          Icons.message,
                                          color:
                                              Color.fromRGBO(144, 202, 220, 1),
                                          size: 35.0,
                                          semanticLabel:
                                              'Text to announce in accessibility modes',
                                        ),
                                        content: const Text(
                                            'Please contact our Company Support/Admin to get your password changed.'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('OK')),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
