import 'package:cordon_track_app/presentation/pages/live_map_page.dart';
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

    const Placeholder(),
    VehicleSearchList(),
    LiveMapPage(),
    const Placeholder(),
    const Placeholder()
  ];

  
  @override
  Widget build(BuildContext context) {
    

    
    return Scaffold(

      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
      scaleFactor: 0.5,
      elevation: 9,
      isFloating: true,
      iconSize: 30.0,
      selectedColor: const Color(0xff00AAE5),
      strokeColor: const Color(0x300c18fb),
      unSelectedColor: Colors.grey[600],
      backgroundColor: Colors.white,
      borderRadius: const Radius.circular(20.0),
      // blurEffect:true,
      // opacity: 0.1,
        items: [
          
        CustomNavigationBarItem(
          icon: const Icon(
            Icons.dashboard_rounded,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(
            Icons.airport_shuttle_rounded,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(
            Icons.explore_rounded,
          ),
        ),
        CustomNavigationBarItem(
          icon: const Icon(
            Icons.summarize_rounded,
          ),
        ),
        CustomNavigationBarItem(
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
    );
  }
}