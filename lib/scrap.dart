//   void _addMarker(String id, LatLng location, JobPosting jobData) async {
//   BitmapDescriptor markerIcon = await getCustomMarker('assets/pin2.png', 60);

//   setState(() {
//     _markers[id] = Marker(
//       markerId: MarkerId(id),
//       position: location,
//       icon: markerIcon,
//       onTap: () {
//         _customInfoWindowController.addInfoWindow!(
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             jobData.companyName,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             jobData.jobTitle,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(height: 16),
//                 Text(
//                   jobData.description,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 ElevatedButton(
//                   onPressed: () => _showFullJobDetails(jobData),
//                   child: const Text("View Details"),
//                 ),
//               ],
//             ),
//           ),
//           location,
//         );
//       },
//     );
//   });
// }

//   void _showFullJobDetails(JobPosting jobData) {
//   // Convert job address to a displayable format
//   String locationText = "${jobData.cAddress}\n${jobData.cState} ${jobData.zipCode}";

//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Job Title and Company Name
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         jobData.companyName,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         jobData.jobTitle,
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const Divider(height: 24),

//               // Location Information
//               _buildInfoSection(
//                 icon: Icons.location_on,
//                 title: "Location",
//                 content: locationText,
//               ),
//               const SizedBox(height: 16),

//               // Job Description
//               _buildInfoSection(
//                 icon: Icons.work,
//                 title: "Description",
//                 content: jobData.description,
//               ),
//               const SizedBox(height: 16),

//               // Qualifications
//               _buildInfoSection(
//                 icon: Icons.school,
//                 title: "Qualifications",
//                 content: jobData.qualifications,
//               ),
//               const SizedBox(height: 16),

//               // Required Certifications
//               _buildInfoSection(
//                 icon: Icons.verified,
//                 title: "Required Certifications",
//                 content: jobData.requiredCerts,
//               ),
//               const SizedBox(height: 16),

//               // Responsibilities
//               _buildInfoSection(
//                 icon: Icons.assignment,
//                 title: "Responsibilities",
//                 content: jobData.responsibilities,
//               ),
//               const SizedBox(height: 16),

//               // Posted Information
//               _buildInfoSection(
//                 icon: Icons.person,
//                 title: "Posted By",
//                 content: "${jobData.whoPosted}\n${jobData.timestamp}",
//               ),
//               const SizedBox(height: 24),

//               // Apply Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add apply functionality here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     "Apply Now",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }

//   Widget _buildInfoSection({
//   required IconData icon,
//   required String title,
//   required String content,
// }) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Icon(icon, size: 20, color: Colors.grey[600]),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               content,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

