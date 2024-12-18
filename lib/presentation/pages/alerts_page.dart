import 'package:cordon_track_app/data/data_providers/alerts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsModel = ref.watch(newAlertsProvider);

    return Scaffold(
      // //colorScheme.secondary,
      appBar: AppBar(
        // //colorScheme.primary,
        title: const Text("Alerts"),
      ),
      body: alertsModel == null ||
              alertsModel.data == null ||
              alertsModel.data!.isEmpty
          ? const Center(
              child: Text("No Alerts available."),
            )
          : ListView.builder(
              itemCount: alertsModel.data!.length,
              itemBuilder: (context, index) {
                final alert = alertsModel.data![index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RTO Number: ${alert.rto ?? "Not Available"}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Text("Vehicle ID: ${alert.vehicleId ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        Text("Datetime: ${alert.datetime ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        Text("Alert Type: ${alert.alertType ?? 'N/A'}"),
                        const SizedBox(height: 4),
                        SelectableText("Message: ${alert.message ?? 'N/A'}"),
                        const SizedBox(height: 4),

                        const SizedBox(height: 4),
                        // SelectableText("Message: ${alert.email ?? 'N/A'}"),
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.vertical,
                        //     child: SelectableText(
                        //       "Message: ${alert.message ?? 'N/A'}",
                        //       style: const TextStyle(color: Colors.black54),
                        //       textAlign: TextAlign.start,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
