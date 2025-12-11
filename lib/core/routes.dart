import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/data/controllers/plot_info_controller.dart';
import 'package:zameendar_web_app/data/controllers/plot_transfer_controller.dart';
import 'package:zameendar_web_app/data/models/plot_transfer_model.dart';
import 'package:zameendar_web_app/presentation/screens/main_screen.dart';
import 'package:zameendar_web_app/presentation/screens/plot_info_customer_detail_screen.dart';

class Routes {
  static Future<PlotTransferModel?> _fetchPlotTransferModel(
    String plotId,
  ) async {
    try {
      final plotTransferController = Get.find<PlotTransferController>();
      final plotInfoController = Get.find<PlotInfoController>();

      debugPrint('--- DEEP LINK DATA FETCH START ---');
      debugPrint('1. Attempting to fetch PlotInfo for ID: $plotId');

      await plotInfoController.fetchPlotInfoById(plotId);
      final plotInfo = plotInfoController.currentPlotModel.value;

      if (plotInfo?.sId == null) {
        debugPrint('1. FAILED: Plot ID $plotId not found or model is empty.');
        debugPrint('--- DEEP LINK DATA FETCH END (FAILED A) ---');
        return null;
      }

      debugPrint(' 1. SUCCESS: Plot sId found: ${plotInfo!.sId}');

      // 2. Ensure all transfer records are loaded
      await plotTransferController.getPlotTransfers();

      debugPrint(
        '2. Transfers loaded: ${plotTransferController.plotTransfers.value.length} records.',
      );

      // --- CRITICAL DEBUGGING AREA ---
      final String targetPlotSId = plotInfo.sId.toString();
      debugPrint('3. Target Plot sId for comparison: $targetPlotSId');

      var plotHistory =
          plotTransferController.plotTransfers.value.where((transfer) {
            // Check 1: Ensure plotInfoId exists on the transfer record
            if (transfer.plotInfoId == null) {
              // debugPrint('    - Transfer rejected: plotInfoId is null');
              return false;
            }

            // Check 2: Extract the ID as a string, handling both Map (populated) and String (unpopulated) forms.
            final transferPlotId =
                (transfer.plotInfoId is Map)
                    ? (transfer.plotInfoId as Map)['\_id']?.toString()
                    : transfer.plotInfoId.toString();

            // Check 3: Compare the extracted ID to the target plot's sId
            final isMatch = transferPlotId == targetPlotSId;

            // Log every ID check to find the mismatch
            if (isMatch) {
              debugPrint(
                '    - MATCH FOUND! Transfer Plot ID: $transferPlotId',
              );
            }

            return isMatch;
          }).toList();
      // --- END CRITICAL DEBUGGING AREA ---

      if (plotHistory.isEmpty) {
        debugPrint(
          ' 3. FAILED: No transfer history found for plot sId: $targetPlotSId',
        );
        debugPrint('--- DEEP LINK DATA FETCH END (FAILED B) ---');
        return null;
      }

      plotHistory.sort((a, b) => a.transferDate!.compareTo(b.transferDate!));
      debugPrint(
        ' 3. SUCCESS: Found ${plotHistory.length} transfers. Returning last one.',
      );
      debugPrint('--- DEEP LINK DATA FETCH END (SUCCESS) ---');
      return plotHistory.last;
    } catch (e, stack) {
      // Capture stack for critical errors
      debugPrint('--- CRITICAL ERROR IN _fetchPlotTransferModel ---');
      debugPrint('Exception: $e');
      debugPrint('Stack: $stack');
      debugPrint(
        'The problem is likely network connectivity or a JSON decoding error.',
      );
      debugPrint('--- DEEP LINK DATA FETCH END (FAILED C) ---');
      return null;
    }
  }

  // ... rest of the Routes class remains the same ...
  static CupertinoPageRoute onGenerateRoute(RouteSettings settings) {
    // ... (Your onGenerateRoute logic here)
    debugPrint('--- onGenerateRoute HIT: ${settings.name} ---');
    final uri = Uri.tryParse(settings.name ?? '');

    // 1. Check for the deep link pattern: /plot_info/<plot_id>
    if (uri != null &&
        uri.pathSegments.isNotEmpty &&
        uri.pathSegments.length == 2 &&
        uri.pathSegments.first == 'plot_info') {
      final plotId = uri.pathSegments[1];

      return CupertinoPageRoute(
        builder:
            (context) => FutureBuilder<PlotTransferModel?>(
              future: _fetchPlotTransferModel(
                plotId,
              ), // Call the helper to load data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    // Data loaded successfully, navigate to details screen
                    return PlotInfoCustomerDetailsScreen(
                      plotTransferModel: snapshot.data!,
                    );
                  }
                  // Handle error or not found
                  return Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: Center(
                      child: Text(
                        snapshot.hasError
                            ? 'Error loading plot data: ${snapshot.error}'
                            : 'Plot ID $plotId not found or data is incomplete.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                // Show loading state
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),
      );
    }

    // 2. Handle standard named routes (existing logic)
    switch (settings.name) {
      case PlotInfoCustomerDetailsScreen.routeName:
        var plotTransferModel = settings.arguments as PlotTransferModel;
        return CupertinoPageRoute(
          builder:
              (context) => PlotInfoCustomerDetailsScreen(
                plotTransferModel: plotTransferModel,
              ),
        );
      default:
        return CupertinoPageRoute(builder: (context) => MainScreen());
    }
  }
}
