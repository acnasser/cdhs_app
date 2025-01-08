

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps; // Google Maps
import 'package:latlong2/latlong.dart' as lat; // latlong2 library
import '../widgets/widgets.dart' as JB;

class JobSource extends StatefulWidget {
  @override
  JobScreen createState() => JobScreen();
}

class JobScreen extends State<JobSource> {
  final Set<gmaps.Marker> _markers = {}; // Specify Google Maps Marker
  late gmaps.GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _addCustomMarker();
  }

  void _addCustomMarker() {
    _markers.add(
      gmaps.Marker(
        markerId: gmaps.MarkerId('marker_1'),
        position: gmaps.LatLng(37.7749, -122.4194), // Use Google Maps LatLng
        icon: gmaps.BitmapDescriptor.defaultMarker,
        onTap: () {
          
          _showLocationDetails("San Francisco", "This is the location of San Francisco.");
        },
      ),
    );
  }



  void _showLocationDetails(String title, String description) {


    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 16)),
          ], 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Map Marker')),
      body: gmaps.GoogleMap(
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(37.7749, -122.4194), // Use Google Maps LatLng
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}



// OPTION 2
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

// class JobSource extends StatefulWidget {
//   @override
//   JobScreen createState() => JobScreen();
// }

// class JobScreen extends State<JobSource> {
//   final Set<gmaps.Marker> _markers = {};
//   late gmaps.GoogleMapController _mapController;

//   gmaps.Marker? _selectedMarker; // Track the tapped marker
//   Offset _markerPosition = Offset(0, 0); // Position of the card
//   bool _isCardVisible = false; // Track card visibility

//   @override
//   void initState() {
//     super.initState();
//     _addCustomMarker();
//   }

//   void _addCustomMarker() {
//     _markers.add(
//       gmaps.Marker(
//         markerId: gmaps.MarkerId('marker_1'),
//         position: gmaps.LatLng(37.7749, -122.4194),
//         icon: gmaps.BitmapDescriptor.defaultMarker,
//         onTap: () {
//           _showFloatingCard("San Francisco", "This is the location of San Francisco.",
//               gmaps.LatLng(37.7749, -122.4194));
//         },
//       ),
//     );
//   }

//   void _showFloatingCard(String title, String description, gmaps.LatLng position) async {
//     // Convert LatLng position to screen coordinates
//     final screenPosition = await _mapController.getScreenCoordinate(position);

//     setState(() {
//       _markerPosition = Offset(screenPosition.x.toDouble(), screenPosition.y.toDouble());
//       _isCardVisible = true;
//       _selectedMarker = gmaps.Marker(markerId: gmaps.MarkerId(title));
//     });
//   }

//   void _hideFloatingCard() {
//     setState(() {
//       _isCardVisible = true;
//       _selectedMarker = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Custom Floating Marker Card')),
//       body: Stack(
//         children: [
//           gmaps.GoogleMap(
//             initialCameraPosition: gmaps.CameraPosition(
//               target: gmaps.LatLng(37.7749, -122.4194),
//               zoom: 10,
//             ),
//             markers: _markers,
//             onMapCreated: (controller) => _mapController = controller,
//             onTap: (_) => _hideFloatingCard(), // Hide card when map is tapped
//           ),
//           if (_isCardVisible) ...[
//             Positioned(
//               top: _markerPosition.dy , // Adjust position above the marker
//               left: _markerPosition.dx , // Center horizontally
//               child: GestureDetector(
//                 onTap: _hideFloatingCard, // Hide when the card is tapped
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.white,
//                   child: Container(
//                     width: 150,
//                     padding: const EdgeInsets.all(8),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "San Francisco",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           "This is the location of San Francisco.",
//                           style: TextStyle(fontSize: 12),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


// OPTION 3

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

// class JobSource extends StatefulWidget {
//   const JobSource({super.key});

//   @override
//   JobScreen createState() => JobScreen();
// }

// class JobScreen extends State<JobSource> {
//   final Set<gmaps.Marker> _markers = {};
//   late gmaps.GoogleMapController _mapController;

//   bool _isCardVisible = false; // Tracks if the card is visible
//   String _jobTitle = "";
//   String _companyName = "";
//   String _location = "";
//   String _salary = "";
//   String _datePosted = "";

//   String? mapStyle;

//   void _setMapStyle() async {
//    mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
//   }
  



//   @override
//   void initState() {
//     super.initState();
//     _addCustomMarker();
//     _setMapStyle(); 
//   }

//   void _addCustomMarker() {
//     _markers.add(
//       gmaps.Marker(
//         markerId: gmaps.MarkerId('marker_1'),
//         position: gmaps.LatLng(37.7749, -122.4194), // San Francisco
//         icon: gmaps.BitmapDescriptor.defaultMarker,
        
//         onTap: () {
//           _showLocationDetails(
//             jobTitle: "Senior Dev",
//             companyName: "Microsoft",
//             location: "Virginia",
//             salary: "80-90k",
//             datePosted: "12/17/24",
//           );
//         },
//       ),
//     );
//   }

//   void _showLocationDetails({
//     required String jobTitle,
//     required String companyName,
//     required String location,
//     required String salary,
//     required String datePosted,
//   }) {
//     setState(() {
//       _jobTitle = jobTitle;
//       _companyName = companyName;
//       _location = location;
//       _salary = salary;
//       _datePosted = datePosted;
//       _isCardVisible = true; // Show the card
//     });
//   }

//   void _hideCard() {
//     setState(() {
//       _isCardVisible = false; // Hide the card
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Custom Map Marker')),
//       body: Stack(
//         children: [

          
//           gmaps.GoogleMap(
//             padding: const EdgeInsets.only(bottom: 0), // Adjust as necessary

//             initialCameraPosition: gmaps.CameraPosition(
//               target: gmaps.LatLng(37.7749, -122.4194), // San Francisco
//               zoom: 10,
//             ),
//             markers: _markers,
//             onMapCreated: (controller) => _mapController = controller,
//             onTap: (_) => _hideCard(), // Hide card when the map is tapped
//              zoomControlsEnabled: false,
//              style: mapStyle,
//           ),


//           if (_isCardVisible)
//             Positioned(
//               bottom: 20,
//               left: 20,
//               right: 20,
//               child: JobCard(
//                 jobTitle: _jobTitle,
//                 companyName: _companyName,
//                 location: _location,
//                 salary: _salary,
//                 datePosted: _datePosted,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class JobCard extends StatelessWidget {
//   const JobCard({
//     super.key,
//     required this.jobTitle,
//     required this.companyName,
//     required this.location,
//     required this.salary,
//     required this.datePosted,
//   });

//   final String jobTitle;
//   final String companyName;
//   final String location;
//   final String salary;
//   final String datePosted;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               jobTitle,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               companyName,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               location,
//               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               salary,
//               style: const TextStyle(fontSize: 14, color: Colors.green),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Posted: $datePosted",
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
