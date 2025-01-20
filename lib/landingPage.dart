import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:cdhs_app/userclass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cdhs_app/createJobPosting.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui' as ui;
import 'package:cdhs_app/JobPosting.dart';


class LandingpageScreen extends StatefulWidget {
  const LandingpageScreen({Key? key}) : super(key: key);

  @override
  State<LandingpageScreen> createState() => _LandingpageScreenState();
}

class _LandingpageScreenState extends State<LandingpageScreen> {
  static const LatLng defaultLocation = LatLng(34.2400534, -77.9912797); // Default location
  LatLng currentLocation = defaultLocation; // Initialize current location
  int _selectedIndex = 0;
  Map<String, dynamic> usersData = {};
  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};
  bool isDarkMode = false;
  bool areNotificationsEnabled = true;
  double _searchRadius = 25.0; // Added for radius search
  bool _isLoading = false;
  String? _currentZipCode;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController(); // Added for custom info window

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

  void fetchUsers() async {
   // Call the static method from UserClass
    Map<String, dynamic> data = await Userclass.fetchCurrentUserData();
    // print(data);
    setState(() {
      usersData = data;
    });
  }

  // Function to initialize the users location
  Future<void> _initializeLocation() async {
  setState(() => _isLoading = true);

  try {
    bool hasPermission = await requestLocationPermission();
    
    if (hasPermission) {
      // Get current position using Geolocator
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high
      );

      // Update current location
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Handle permission denied case if necessary
      print("Location permission denied.");
    }
  } catch (e) {
    print('Error getting location: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error getting location: $e'))
    );
  } finally {
    setState(() => _isLoading = false);
  }
}

  // Load preferences on initialization
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    areNotificationsEnabled = prefs.getBool('areNotificationsEnabled') ?? true;
  }

  // Save preferences
  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    prefs.setBool('areNotificationsEnabled', areNotificationsEnabled);
  }

// Function to fetch job postings from Firestore that match the user's zipcode
  Future<void> _fetchJobPostings() async {
    try {
      // Fetch current user's zipcode from the usersData
      String? userZipCode = usersData['CZip']; // Assuming 'zipcode' is stored in usersData

      if (userZipCode == null) {
        print("User zip code not found.");
        return;
      }

      // Query Firestore for job postings with the same zip code
      var querySnapshot = await FirebaseFirestore.instance
          .collection('JobPostings') // Replace with your Firestore collection name
          .where('ZipCode', isEqualTo: userZipCode) // Match ZipCode with user's
          .get();

      // Loop through the documents and add markers to the map
      for (var doc in querySnapshot.docs) {
        var jobData = JobPosting.fromFirestore(doc); // Assuming you have a fromFirestore method
        LatLng jobLocation = LatLng(jobData.latitude, jobData.longitude); // Assuming latitude and longitude are stored

        _addMarker(doc.id, jobLocation, jobData);
      }
    } catch (e) {
      print("Error fetching job postings: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching job postings: $e'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Request permission and initialize location
    fetchUsers();
    _fetchJobPostings(); // Fetch job postings when the page is initialized
  }

  void _addMarker(String id, LatLng location, JobPosting jobData) async {
    BitmapDescriptor markerIcon = await getCustomMarker('assets/pin2.png', 60);

    setState(() {
      _markers[id] = Marker(
        markerId: MarkerId(id),
        position: location,
        icon: markerIcon,
        onTap: () {
          _showJobPostingDetails(jobData); // Show the job details when marker is tapped
        },
      );
    });
  }

  void _showJobPostingDetails(JobPosting jobData) {
  // Convert job address to a displayable format
  String locationText = "${jobData.cAddress}\n${jobData.cState} ${jobData.zipCode}";

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Job Title and Company Name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobData.companyName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        jobData.jobTitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Location Information
              _buildInfoSection(
                icon: Icons.location_on,
                title: "Location",
                content: locationText,
              ),
              const SizedBox(height: 16),

              // Job Description
              _buildInfoSection(
                icon: Icons.work,
                title: "Description",
                content: jobData.description,
              ),
              const SizedBox(height: 16),

              // Qualifications
              _buildInfoSection(
                icon: Icons.school,
                title: "Qualifications",
                content: jobData.qualifications,
              ),
              const SizedBox(height: 16),

              // Required Certifications
              _buildInfoSection(
                icon: Icons.verified,
                title: "Required Certifications",
                content: jobData.requiredCerts,
              ),
              const SizedBox(height: 16),

              // Responsibilities
              _buildInfoSection(
                icon: Icons.assignment,
                title: "Responsibilities",
                content: jobData.responsibilities,
              ),
              const SizedBox(height: 16),

              // Posted Information
              _buildInfoSection(
                icon: Icons.person,
                title: "Posted By",
                content: "${jobData.whoPosted}", //\n${jobData.timestamp}",
              ),
              const SizedBox(height: 24),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle apply functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Apply Now",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildInfoSection({
  required IconData icon,
  required String title,
  required String content,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.grey[600]),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    
    // Starting widget list
    List<Widget> widgetOptions = <Widget>[
      // Map Page
      Stack(
        children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 14,
          ),
          markers: _markers.values.toSet(),
          onMapCreated: (controller) {
            mapController = controller;
            _customInfoWindowController.googleMapController = controller;
          },
          onTap: (position) {
            _customInfoWindowController.hideInfoWindow!();
          },
          onCameraMove: (position) {
            _customInfoWindowController.onCameraMove!();
          },
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: 200,
          width: 300,
          offset: 35,
        ),
        
        // Radius Slider
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Search for Nearby Jobs',
                          style: const TextStyle(fontSize: 16),
                        ),
                        // Replace Slider with a button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _fetchJobPostings();  // Fetch job postings when the button is pressed
                            });
                          },
                          child: const Text("Find Jobs"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
            ),
          ),
        ),),
        
        // Loading Indicator (if data is being fetched)
        if (_isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      
      // Create job posting page
      const CreateJobPosting(),
            
      // Settings Page
      Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        // Section: Account Settings
        const ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Account Settings'),
          subtitle: Text('Manage your account settings'),
        ),
        const Divider(),

        // Section: Theme Mode (Light/Dark)
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Theme Mode'),
          trailing: Switch(
            value: isDarkMode, // Replace with your theme state
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                // Update theme mode
                // Add theme change logic here
              });
            },
          ),
        ),
        const Divider(),

        // Section: Notifications
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: Switch(
            value: areNotificationsEnabled, // Replace with your notification state
            onChanged: (value) {
              setState(() {
                areNotificationsEnabled = value;
                // Update notifications setting logic
              });
            },
          ),    
        ),
        const Divider(),

        // Section: Language
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('Choose your preferred language'),
          onTap: () {
            // Navigate to Language settings
            // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsPage()));
          },
        ),
        const Divider(),

        // Section: Privacy
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('Privacy'),
          subtitle: const Text('Manage privacy settings'),
          onTap: () {
            // Navigate to Privacy settings page
          },
        ),
        const Divider(),

        // Section: Logout
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            // Implement logout functionality here
            // Example: Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
    ),
   ),

      // Profile Page
      Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        
        children: [
          // Profile Header (Profile Picture + Name)
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/example_logo.png'), // Replace with user's profile image
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Text(
              (usersData['FName']+ ' ' + usersData['LName']) ?? 'Default Name', // Replace with the user's name
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8.0),
          const Center(
            child: Text(
              'Software Engineer', // Replace with user's job title
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20.0),

          // User Information (Email, Phone)
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(usersData['Email'] ?? 'Default Email'), // Replace with user's email
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(usersData['Phone'] ?? 'Default Email'), // Replace with user's phone number
          ),
          // const ListTile(
          //   leading: Icon(Icons.location_on),
          //   title: Text('Location'),
          //   subtitle: Text('New York, USA'), // Replace with user's location
          // ),
          const SizedBox(height: 20.0),

          // Edit Profile Button
          ElevatedButton(
            onPressed: () {
              // Navigate to the edit profile page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
      ),
      
      // View applicants -- This will be implemented later, once users can hit 'apply' on the map page
      const CreateJobPosting(),
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
            label: 'Add Job',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Applicants',
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



