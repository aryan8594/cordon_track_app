// ignore_for_file: use_build_context_synchronously

import 'package:cordon_track_app/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
  import 'package:permission_handler/permission_handler.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;



Future<bool> requestLocationPermission() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    status = await Permission.locationWhenInUse.request();
  }
  return status.isGranted;
}


  final List<Map<String, String>> _carouselItems = [
    // item 1
    {
      'title': 'Welcome to Cordon Track !',
      'description':
          'Track your fleet seamlessly and stay in control at all times.',
      'image': 'lib/presentation/assets/carosel1.png',
    },
    //item 2
    {
      'title': 'Monitor your fleet with powerful features:',
      'description':
          '-Real-time vehicle tracking\n-Geofence alerts & speed reports\n-Fleet utilization insights',
      'image': 'lib/presentation/assets/carosel2.png',
    },
    //item 3
    {
      'title': 'Grant necessary Permissions:',
      'description':
          'To provide the best experience, we need access to your location, contacts, and file storage for tracking, communication, and data storage.',
      'image': 'lib/presentation/assets/carosel3.png',
    },
    //item 4
    {
      'title': 'Almost There!',
      'description':
          'You are all set! Log in now to start managing your fleet and tracking vehicles in real-time.',
      'image': 'lib/presentation/assets/carosel4.png',
    },
  ];
  @override
  Widget build(BuildContext context) {
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
            const Spacer(),
            CarouselSlider.builder(
              itemCount: _carouselItems.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //carousel image
                    Image.asset(_carouselItems[itemIndex]['image']!),
                  ],
                );
              },
              options: CarouselOptions(
                height: 350,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    // _currentIndex = index;
                  });
                },
              ),
              carouselController: _controller,
            ),
            Stack(
              children: [
                Container(
                  height: 325,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      child: Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: _carouselItems.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //carousel Title
                                  Text(
                                    _carouselItems[itemIndex]['title']!,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  //carousel Description
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      _carouselItems[itemIndex]['description']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              );
                            },
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: 200,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            carouselController: _controller,
                          ),
                          const SizedBox(height: 20),
                          //login/next button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 50),
                                backgroundColor:
                                    const Color.fromRGBO(144, 202, 220, 1),
                              ),
                              onPressed: () async {
                                if (_currentIndex ==
                                    _carouselItems.length - 1) {
                                  // Navigate to login screen
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isFirstTime', false);
                                  requestLocationPermission();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                } else {
                                  _controller.nextPage();
                                }
                              },
                              child: Text(
                                _currentIndex == _carouselItems.length - 1
                                    ? 'Login'
                                    : 'Next',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
