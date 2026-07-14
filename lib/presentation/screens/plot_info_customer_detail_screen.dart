import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:zameendar_web_app/data/models/customer_model.dart';
import 'package:zameendar_web_app/data/models/plot_transfer_model.dart';
import 'package:zameendar_web_app/data/models/subsidary_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlotInfoCustomerDetailsScreen extends StatelessWidget {
  static const routeName = "plot_customer_details";

  // Define a required property for the data
  final PlotTransferModel plotTransferModel;

  const PlotInfoCustomerDetailsScreen({
    super.key,
    required this.plotTransferModel,
  });

  // Helper function to fetch image data as Uint8List
  // Helper function to fetch image data as Uint8List
  Future<Uint8List> _fetchImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return Uint8List(0);
    }

    try {
      // 1. Safely retrieve the base URL
      String baseUrl =
          dotenv.env['API_URL'] ?? 'https://zameendarassociates.com';

      // 2. Ensure baseUrl ends with a slash if the imageUrl doesn't start with one
      if (!baseUrl.endsWith('/') && !imageUrl.startsWith('/')) {
        baseUrl = '$baseUrl/';
      }

      // 3. Prevent a double-slash error if both have a slash
      if (baseUrl.endsWith('/') && imageUrl.startsWith('/')) {
        imageUrl = imageUrl.substring(1);
      }

      final imageUrlFull = baseUrl + imageUrl;
      debugPrint('Fetching image from: $imageUrlFull');

      final response = await http.get(Uri.parse(imageUrlFull));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        debugPrint(
          'Failed to load image from $imageUrlFull. Status: ${response.statusCode}',
        );
        return Uint8List(0);
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
      return Uint8List(0);
    }
  }

  // Helper function to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Access the required model directly from the class property
    final order = plotTransferModel;

    // --- FIX START: Correctly cast SubsidaryModel and extract nested CustomerModel ---

    // 1. Cast the dynamic field to the model it actually holds.
    final SubsidaryModel? subsidiary =
        order.transferToSubsidaryId is SubsidaryModel
            ? order.transferToSubsidaryId as SubsidaryModel
            : null;

    // 2. Safely extract the nested CustomerModel from the subsidiary's customerId field.
    final CustomerModel? customer =
        subsidiary?.customerId is CustomerModel
            ? subsidiary!.customerId as CustomerModel
            : null;

    final plotInfo = order.plotInfoId;
    final projectInfo = order.transferFromProjectId;

    // 3. Use the correct source for customer details.
    // Name and Mobile are available directly on the SubsidaryModel (from its internal parsing)
    final String customerName = subsidiary?.subsidaryName ?? 'N/A';
    final String customerMobileNo = subsidiary?.mobileNo ?? 'N/A';

    // CNIC and profilePicture are only available on the nested CustomerModel
    final String customerCnic = customer?.cnic ?? 'N/A';
    final String imageUrl = customer?.profilePicture ?? '';

    final String displayProjectName = projectInfo?['projectName'] ?? 'N/A';
    final String displayProjectCity = projectInfo?['city'] ?? 'N/A';
    final String displayProjectAddress = projectInfo?['address'] ?? 'N/A';

    final String displayPlotNo = plotInfo?['plotNo'] ?? 'N/A';
    final String displayStreet = plotInfo?['street'] ?? 'N/A';
    final String displayBlock = plotInfo?['block'] ?? 'N/A';

    // Check if the required data is missing
    if (customer == null || plotInfo == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Plot Details')),
        body: Center(
          child: Text(
            'Error: Necessary plot or customer data is missing.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Plot & Customer Details')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8.0,
              shadowColor: Colors.black.withOpacity(
                0.15,
              ), // Softer, premium drop shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0,
                ), // Rounded modern corner
              ),
              child: Container(
                // 1. Dual-tone professional background gradient
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.blueGrey.shade50.withOpacity(
                        0.5,
                      ), // Subtle tint towards the bottom
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 28.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Profile Picture ---
                      Center(
                        child: Container(
                          width: 115,
                          height: 115,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.shade200.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 16,
                                spreadRadius: 3,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: FutureBuilder<Uint8List>(
                            future: _fetchImage(imageUrl),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0F2F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.blueGrey,
                                            ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasError ||
                                  snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade50,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 58,
                                    color: Colors.blueGrey.shade300,
                                  ),
                                );
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                    image: MemoryImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- SECTION 1: CUSTOMER INFORMATION ---
                      _buildSectionHeader(
                        'Customer Profile',
                        Icons.badge_rounded,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blueGrey.shade100.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildModernDetailRow(
                              'Full Name',
                              customerName,
                              Icons.person_outline_rounded,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'CNIC Number',
                              customerCnic,
                              Icons.assignment_ind_outlined,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'Mobile Number',
                              customerMobileNo,
                              Icons.phone_android_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- SECTION 2: PROPERTY & PROJECT INFORMATION ---
                      _buildSectionHeader(
                        'Project & Location',
                        Icons.corporate_fare_rounded,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blueGrey.shade100.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildModernDetailRow(
                              'Project Name',
                              displayProjectName,
                              Icons.business_rounded,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'City',
                              displayProjectCity,
                              Icons.location_city_rounded,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'Site Address',
                              displayProjectAddress,
                              Icons.map_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- SECTION 3: PLOT SPECIFICATIONS ---
                      _buildSectionHeader(
                        'Plot Specifications',
                        Icons.grid_view_rounded,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.blueGrey.shade100.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildModernDetailRow(
                              'Plot Number',
                              displayPlotNo,
                              Icons.numbers_rounded,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'Street Address',
                              displayStreet,
                              Icons.add_road_rounded,
                            ),
                            const Divider(height: 16, thickness: 0.5),
                            _buildModernDetailRow(
                              'Sector / Block',
                              displayBlock,
                              Icons.grid_goldenratio_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /* Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Profile Picture ---
                    Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: FutureBuilder<Uint8List>(
                          future: _fetchImage(imageUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: const Color(
                                    0xFFF0F2F5,
                                  ), // Light modern grey
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError ||
                                snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              // Elegant placeholder instead of just a raw icon
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade50,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 55,
                                  color: Colors.blueGrey.shade300,
                                ),
                              );
                            }

                            // Display the circular profile image
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ), // Clean outer ring
                                image: DecorationImage(
                                  image: MemoryImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Customer Details ---
                    _buildDetailRow('Customer Name:', customerName),
                    _buildDetailRow('CNIC:', customerCnic),
                    _buildDetailRow('Mobile No:', customerMobileNo),

                    //_buildDetailRow('Transfer Date:', order.transferDate ?? 'N/A'),
                    const Divider(height: 24, thickness: 1),
                    //Project Details
                    _buildDetailRow('Project Name : ', displayProjectName),
                    _buildDetailRow('City         : ', displayProjectCity),
                    _buildDetailRow('Address      : ', displayProjectAddress),
                    const Divider(height: 24, thickness: 1),
                    // --- Plot Details ---
                    //_buildDetailRow('Plot ID:', displayPlotId),
                    _buildDetailRow('Plot No:', displayPlotNo),
                    _buildDetailRow('Street:', displayStreet),
                    _buildDetailRow('Block:', displayBlock),

                    // Add more details from the 'order' model here as necessary
                  ],
                ),
              ),
            ),*/
          ),
        ),
      ),
    );
  }
}

// Helper to build elegant, professional section titles
Widget _buildSectionHeader(String title, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey.shade700),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ],
    ),
  );
}

// Modern, scannable detail row with soft icons and contrasting typography
Widget _buildModernDetailRow(String label, String value, IconData leadingIcon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(leadingIcon, size: 18, color: Colors.blueGrey.shade300),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey.shade600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B), // Premium dark slate color
          ),
        ),
      ],
    ),
  );
}
