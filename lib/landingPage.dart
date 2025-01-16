import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class LandingpageScreen extends StatefulWidget {
  const LandingpageScreen({Key? key}) : super(key: key);

  @override
  State<LandingpageScreen> createState() => _LandingpageScreenState();
}

class _LandingpageScreenState extends State<LandingpageScreen> {
  static const LatLng defaultLocation = LatLng(34.2400534, -77.9912797); // Default location
  LatLng currentLocation = defaultLocation; // Initialize current location
  int _selectedIndex = 0;

  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};

  // Function to request location permissions
  Future<bool> requestLocationPermission() async {
    // Check if location permissions are already granted
    var status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      // Permission already granted
      return true;
    } else if (status.isDenied || status.isRestricted) {
      // Request location permission
      status = await Permission.locationWhenInUse.request();

      if (status.isGranted) {
        // Permission granted
        return true;
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied; user must enable it manually
        openAppSettings();
        return false;
      }
    }

    // Return false if permission is denied or restricted
    return false;
  }

  Future<BitmapDescriptor> getCustomMarker(String assetPath, double width) async {
    final ImageConfiguration config = ImageConfiguration(size: Size(width, width));
    return await BitmapDescriptor.asset(config, assetPath);
  }

  // Function to add a marker to the map
  void _addMarker(String id, LatLng location) async {

    BitmapDescriptor markerIcon = await getCustomMarker('assets/pin2.png', 60);

    setState(() {
      _markers[id] = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: InfoWindow(
          title: '🍃 Scenic Spot',
          snippet: 'A peaceful place to relax and enjoy the view.',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('More Info'),
                content: const Text(
                  'This is a scenic spot with lots of greenery, a serene lake, and amazing views! Highly recommended for nature lovers. 🌳✨',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
        icon: markerIcon,
      );
    });
  }


  // Function to handle permission and update the map
  Future<void> _initializeLocation() async {
    bool hasPermission = await requestLocationPermission();
    if (hasPermission) {
      // Here you can use a location plugin like `geolocator` to get the user's actual location
      // For now, we will just set the default location
      setState(() {
        currentLocation = defaultLocation; // Replace with user's actual location if available
      });
      _addMarker('currentLocation', currentLocation);
    } else {
      print('Location permission denied');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Request permission and initialize location
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 14,
        ),
        markers: _markers.values.toSet(),
        onMapCreated: (controller) {
          mapController = controller;
          _addMarker('currentLocation', currentLocation);
        },
          mapToolbarEnabled: false, // Removes the map toolbar
          zoomControlsEnabled: false, // Removes the zoom in/out buttons
          myLocationButtonEnabled: false, // Removes the "My Location" button
      ),
      const Center(
        child: Text(
          'Create Job Posting',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location_alt_rounded),
            label: 'Create Posting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 36, 154, 209),
        unselectedItemColor: const Color.fromARGB(255, 36, 154, 209),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
