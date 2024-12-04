import 'dart:io';

import 'package:cordon_track_app/data/data_providers/login_provider.dart';
import 'package:cordon_track_app/presentation/pages/immobalizer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming LoginModel has properties like name and empId
class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the loginProvider for changes
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      body: loginState.when(
        data: (loginModel) {
          if (loginModel!.data == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Picture and Name Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      backgroundColor:Colors.white,
                      backgroundImage:AssetImage("lib/presentation/assets/cordon_logo_1.png"),
                      radius: 50,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${loginModel.data?.name}', // Use name from loginModel
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Username: ${loginModel.data?.username}', // Use empId from loginModel
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Email: ${loginModel.data?.email}', // Use empId from loginModel
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'City: ${loginModel.data?.city}', // Use empId from loginModel
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                      width: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Profile Options List
                ProfileOption(
                  icon: Icons.power_settings_new_rounded,
                  text: 'Immobalizer',
                  onTap: () {
                    // Handle Trip Details tap
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ImmobalizerListPage()));
                  },
                ),
                // Add other ProfileOption widgets here...
                ProfileOption(
                  icon: Icons.logout,
                  text: 'Logout',
                  color: Colors.red,
                  onTap: () {
                    // Handle Logout tap
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Icon(
                              Icons.message,
                              color: Color.fromRGBO(144, 202, 220, 1),
                              size: 35.0,
                              semanticLabel: 'Logout?',
                            ),
                            content: const Text(
                                'Are you sure, you want to Log Out?'),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () {
                                    if (Platform.isAndroid) {
                                      SystemNavigator.pop();
                                    } else if (Platform.isIOS) {
                                      exit(0);
                                    }
                                  },
                                  child: const Text('OK')),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const ProfileOption({super.key, 
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.lightBlueAccent),
      title: Text(text, style: const TextStyle(fontSize: 18)),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
    );
  }
}
