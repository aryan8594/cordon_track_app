import 'package:cordon_track_app/data/data_providers/dashbaord_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cordon_track_app/data/models/dashboard_model.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    // Listen to the provider state
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 10),
            Image.asset(
              "lib/presentation/assets/cordon_logo_2.png",
              height: 25,
              scale: 10,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, size: 25),
          ),
          const SizedBox(width: 10),
        ],
        leadingWidth: 120,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Overview",
                  style: TextStyle(fontSize: 18),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ),
          ),
          Expanded(
            child: dashboardState.when(
              data: (dashboardData) => _buildDashboardContent(dashboardData),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text("Error: $error"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(DashboardModel dashboardData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white70,
                child: Container(
                  width: 175,
                  height: 300,
                ),
              ),
              Column(
                children: [
                  Card(
                    color: Colors.white70,
                    child: Container(
                      width: 175,
                      height: 150,
                    ),
                  ),
                  Card(
                    color: Colors.white70,
                    child: Container(
                      width: 175,
                      height: 150,
                    ),
                  )
                ],
              ),
            ],
          ),
          Card(
            color: Colors.white70,
            child: Container(
              width: double.maxFinite,
              height: 400,
            ),
          )
        ],
      ),
    );
  }
}


// Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Fleet Summary Section
//       Card(
//         margin: const EdgeInsets.all(16.0),
//         child: ListTile(
//           title: Text("Total Vehicles: ${dashboardData.data?.vehicleCount ?? 'N/A'}"),
//           subtitle: Text(
//             "Running: ${dashboardData.data?.runningVehicleCount ?? 0} | Idle: ${dashboardData.data?.idleVehicleCount ?? 0}",
//           ),
//         ),
//       ),
//       // Vehicles List
//       Expanded(
//         child: ListView.builder(
//           itemCount: dashboardData.vehicles?.length ?? 0,
//           itemBuilder: (context, index) {
//             final vehicle = dashboardData.vehicles![index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: ListTile(
//                 title: Text(vehicle.location ?? 'Unknown Location'),
//                 subtitle: Text("Speed: ${vehicle.speed ?? 'N/A'} km/h"),
//                 trailing: Text(vehicle.rto ?? ''),
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   );