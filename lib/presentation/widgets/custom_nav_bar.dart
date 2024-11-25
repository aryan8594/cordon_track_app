import 'package:cordon_track_app/presentation/pages/dashboard_page.dart';
import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
import 'package:cordon_track_app/presentation/pages/reports_page.dart';
import 'package:cordon_track_app/presentation/pages/vehicle_search_list.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {

  int  _currentIndex = 0;

  final List<Widget> _screens = [

    DashboardPage(),
    VehicleSearchList(),
    LiveMapPage(),
    ReportsPage(),
    const Placeholder()
  ];

  
  @override
  Widget build(BuildContext context) {
    

    
    return Scaffold(

      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(8),
        child: CustomNavigationBar(
        scaleFactor: 0.1,
        elevation: 9,
        isFloating: true,
        iconSize: 30.0,
        selectedColor: const Color(0xff00AAE5),
        strokeColor: const Color.fromARGB(255, 60, 82, 121),
        unSelectedColor: Colors.white,
        backgroundColor: Colors.black,
        borderRadius: const Radius.circular(20.0),
        // blurEffect:true,
        // opacity: 0.1,
          items: [
            
          CustomNavigationBarItem(
            title: const Text("Home", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            selectedTitle: const Text("Home", style: TextStyle(color: Color.fromARGB(255, 85, 190, 225), fontWeight: FontWeight.bold),),
            icon: const Icon(
              Icons.dashboard_rounded,
            ),
          ),
          CustomNavigationBarItem(
            title: const Text("Tracking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            selectedTitle: const Text("Tracking", style: TextStyle(color: Color.fromARGB(255, 85, 190, 225), fontWeight: FontWeight.bold),),
            icon: const Icon(
              Icons.airport_shuttle_rounded,
            ),
          ),
          CustomNavigationBarItem(
            title: const Text("Live Map", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            selectedTitle: const Text("Live Map", style: TextStyle(color: Color.fromARGB(255, 85, 190, 225), fontWeight: FontWeight.bold),),
            icon: const Icon(
              Icons.explore_rounded,
            ),
          ),
          CustomNavigationBarItem(
            title: const Text("Reports", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            selectedTitle: const Text("Reports", style: TextStyle(color: Color.fromARGB(255, 85, 190, 225), fontWeight: FontWeight.bold),),
            icon: const Icon(
              Icons.summarize_rounded,
            ),
          ),
          CustomNavigationBarItem(
            title: const Text("More", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            selectedTitle: const Text("More", style: TextStyle(color: Color.fromARGB(255, 85, 190, 225), fontWeight: FontWeight.bold),),
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        ),
      ),
    );
  }
}