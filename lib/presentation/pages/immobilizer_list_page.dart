// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:cordon_track_app/data/data_providers/immobilizer_create_provider.dart';
import 'package:cordon_track_app/data/data_providers/immobilizer_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImmobilizerListPage extends ConsumerStatefulWidget {
  const ImmobilizerListPage({super.key});

  @override
  ConsumerState<ImmobilizerListPage> createState() =>
      _ImmobilizerListPageState();
}

class _ImmobilizerListPageState extends ConsumerState<ImmobilizerListPage> {
  late Timer _timer;
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.invalidate(
          immobilizerListProvider); // Refresh the list every 10 seconds
    });

    _searchController.addListener(() {
      _searchQuery.value = _searchController.text.trim();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final immobilizerListAsyncValue = ref.watch(immobilizerListProvider);

    return Scaffold(
      // //colorScheme.secondary,
      appBar: AppBar(
        // //colorScheme.primary,
        title: const Text('Immobilizer List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by RTO Number..',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: immobilizerListAsyncValue.when(
        data: (immobilizerList) {
          final dataList = immobilizerList?.data ?? [];
          if (dataList.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return ValueListenableBuilder<String>(
            valueListenable: _searchQuery,
            builder: (context, query, _) {
              final filteredList = query.isEmpty
                  ? dataList
                  : dataList
                      .where((data) =>
                          data.rto
                              ?.toLowerCase()
                              .contains(query.toLowerCase()) ??
                          false)
                      .toList();

              if (filteredList.isEmpty) {
                return const Center(child: Text('No matching results'));
              }

              return ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final data = filteredList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Center(child: Text(data.rto ?? 'Unknown Event')),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Vehicle ID: ${data.vehicleId ?? "N/A"}'),
                          Text('Vehicle IMEI: ${data.imei ?? "N/A"}'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildImmobilizerButton(context, ref, data.imei!,
                                  'stop', 'Immobilize'),
                              _buildImmobilizerButton(context, ref, data.imei!,
                                  'start', 'Mobilize'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Icon(
                    Icons.signal_wifi_connected_no_internet_4_rounded,
                    size: 200,
                    color: Colors.redAccent,
                  ),
                  Text(
                    "NO INTERNET\nAVAILABLE",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer()
                ],
              ),
      ),
    );
  }

  Widget _buildImmobilizerButton(
    BuildContext context, WidgetRef ref, String imei, String event, String action) {
  return InkWell(
    onTap: () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Are you sure you want to ${event == 'stop' ? 'Immobilize' : 'Mobilize'} this Vehicle?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        _handleImmobilizerAction(
          context: context,
          ref: ref,
          imei: imei,
          event: event,
        );
      }
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
            color: event == 'stop' ? Colors.redAccent : Colors.greenAccent),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(8),
      child: Text(action),
    ),
  );
}

void _handleImmobilizerAction({
  required BuildContext context,
  required WidgetRef ref,
  required String imei,
  required String event,
}) async {
  final repository = ref.read(immobilizerCreateRepoProvider);

  // Show a loading indicator during the API call
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    // Make the API call
    final response = await repository.fetchImmobilizerCreate(imei, event);

    // Log response for debugging
    log("Immobilizer Response: $response");

    // Dismiss the loading dialog
    Navigator.of(context).pop();

    // Show the result dialog with the response
    if (response != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(
              Icons.message,
              color: Color.fromRGBO(144, 202, 220, 1),
              size: 35.0,
              semanticLabel: 'Action Result',
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Message: ${response.message ?? 'No message'}"),
                Text("Event: ${response.command?.event ?? 'N/A'}"),
                Text("Device Model: ${response.command?.deviceModel ?? 'N/A'}"),
                Text("Status: ${response.command?.status ?? 'N/A'}"),
                Text("Command Message: ${response.command?.message ?? 'N/A'}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    Navigator.of(context).pop(); // Dismiss the loading dialog
    // Handle errors
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text("Failed to execute action: $e"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

}
