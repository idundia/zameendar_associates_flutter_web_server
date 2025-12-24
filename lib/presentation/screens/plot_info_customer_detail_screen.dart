import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zameendar_web_app/data/models/customer_model.dart';
import 'package:zameendar_web_app/data/models/plot_transfer_model.dart';
import 'package:zameendar_web_app/data/models/subsidary_model.dart';

class PlotInfoCustomerDetailsScreen extends StatelessWidget {
  static const routeName = "plot_customer_details";

  // 💡 Define a required property for the data
  final PlotTransferModel plotTransferModel;

  const PlotInfoCustomerDetailsScreen({
    super.key,
    required this.plotTransferModel,
  });

  // Helper function to fetch image data as Uint8List
  Future<Uint8List> _fetchImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      return Uint8List(0);
    }

    try {
      // Base URL should be defined in your dotenv file
      //final imageUrlFull = dotenv.env['IMAGE_URL']! + imageUrl;
      final imageUrlFull = "https://zameendarassociates.com$imageUrl";
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
    // 💡 Access the required model directly from the class property
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

    // 3. Use the correct source for customer details.
    // Name and Mobile are available directly on the SubsidaryModel (from its internal parsing)
    final String customerName = subsidiary?.subsidaryName ?? 'N/A';
    final String customerMobileNo = subsidiary?.mobileNo ?? 'N/A';

    // CNIC and profilePicture are only available on the nested CustomerModel
    final String customerCnic = customer?.cnic ?? 'N/A';
    final String imageUrl = customer?.profilePicture ?? '';

    // --- FIX END ---

    final String displayPlotId = plotInfo?['_id'] ?? 'N/A';
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
                    FutureBuilder<Uint8List>(
                      future: _fetchImage(imageUrl),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          // Display placeholder on error or no image
                          return const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Colors.grey,
                          );
                        }

                        // Display the image from memory (Uint8List)
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            snapshot.data!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // --- Customer Details ---
                    _buildDetailRow('Customer Name:', customerName),
                    _buildDetailRow('CNIC:', customerCnic),
                    _buildDetailRow('Mobile No:', customerMobileNo),

                    //_buildDetailRow('Transfer Date:', order.transferDate ?? 'N/A'),
                    const Divider(height: 24, thickness: 1),

                    // --- Plot Details ---
                    _buildDetailRow('Plot ID:', displayPlotId),
                    _buildDetailRow('Plot No:', displayPlotNo),
                    _buildDetailRow('Street:', displayStreet),
                    _buildDetailRow('Block:', displayBlock),

                    // Add more details from the 'order' model here as necessary
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
