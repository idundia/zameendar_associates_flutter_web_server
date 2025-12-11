import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/data/controllers/company_controller.dart';
import 'package:zameendar_web_app/data/models/customer_model.dart';
import 'package:zameendar_web_app/data/models/plot_transfer_model.dart';
import 'package:zameendar_web_app/data/repositories/plot_transfer_repository.dart';

class PlotTransferController extends GetxController {
  // --- Repositories and Controllers ---
  final PlotTransferRepository _plotTransferRepository =
      PlotTransferRepository();
  final CompanyController companyController = Get.find<CompanyController>();

  // --- Data Storage (Raw and Filtered) ---
  final RxList<PlotTransferModel> plotTransfers = <PlotTransferModel>[].obs;
  final RxList<PlotTransferModel> _plotTransfers = <PlotTransferModel>[].obs;

  Rx<CustomerModel> selectedTransferFromCustomer = CustomerModel().obs;
  Rx<CustomerModel> selectedTransferToCustomer = CustomerModel().obs;

  // This list is displayed in the UI after filtering
  final RxList<PlotTransferModel> filteredPlotTransfers =
      <PlotTransferModel>[].obs;

  // --- Text Editing Controllers for UI Input ---
  final TextEditingController transferNoTextEditingController =
      TextEditingController();

  final TextEditingController plotNameController = TextEditingController();
  final TextEditingController plotNameSearchController =
      TextEditingController();
  final TextEditingController transferFromCustomerEditingController =
      TextEditingController();
  final TextEditingController transferToCustomerEditingController =
      TextEditingController();
  final TextEditingController transferFeeTextEditingController =
      TextEditingController(text: "0.0"); // Initialize with "0.0" for doubles

  final TextEditingController fromDateTextController = TextEditingController();
  final TextEditingController toDateTextController = TextEditingController();
  final TextEditingController transferDateTextEditingController =
      TextEditingController(); // For single date input, if any

  // --- Focus Nodes ---
  final FocusNode plotNameFocusNode = FocusNode();
  final FocusNode transferFromCustomerFocusNode = FocusNode();
  //final FocusNode headNameFocusNode = FocusNode();
  final FocusNode plotTransferFocusNode = FocusNode();
  final FocusNode plotTransferNoFocusNode = FocusNode();

  // --- Reactive State Variables ---
  final Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  final Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final RxString reportType = "detail".obs; // "detail" or "summary"
  final RxBool isLoading = false.obs;

  // --- Disposers for Listeners ---
  late final Function _companyDataLoadingDisposer;

  @override
  void onInit() {
    super.onInit();
    print("PlotTransferController: onInit called.");

    // 1. Initialize Date Controllers and Reactive Dates
    final now = DateTime.now();
    // Set fromDate to the start of the current day (midnight)
    fromDate.value = DateTime(now.year, now.month, now.day);
    // Set toDate to the very end of the current day (just before midnight of next day)
    toDate.value = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    // Update text controllers with formatted dates
    fromDateTextController.text = DateFormat(
      'dd-MMM-yyyy',
    ).format(fromDate.value!);
    toDateTextController.text = DateFormat('dd-MMM-yyyy').format(toDate.value!);

    // Initialize the new expense/asset entry date (if used elsewhere in UI)
    transferDateTextEditingController.text = DateFormat(
      'dd-MM-yyyy hh:mm a',
    ).format(now);

    // 2. Listen for Company Data Loading (Crucial for dependent fetches)
    _companyDataLoadingDisposer = ever(companyController.isCompanyDataLoading, (
      bool isLoadingStatus,
    ) {
      if (!isLoadingStatus &&
          companyController.currenctCompanyInfo.value.sId != null) {
        print(
          "DailyExpenseController: Company data loaded. Loading initial expenses and assets.",
        );
        getPlotTransfers(); // Consolidate initial loading
      } else if (!isLoadingStatus &&
          companyController.currenctCompanyInfo.value.sId == null) {
        print(
          "DailyExpenseController: Company data load finished, but sId is null. Cannot load expenses/assets.",
        );
        Get.snackbar(
          'Error',
          'Company data not available. Cannot load expense/asset data.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });

    // 3. Listen to search text field changes for immediate filtering
    plotNameSearchController.addListener(searchPlotTransfers);
  }

  /// Handles new expense data received from a socket.
  void addExpenseFromSocket(dynamic plotTransferData) {
    PlotTransferModel receivedPlotTransfer; // Renamed for clarity
    if (plotTransferData is Map<String, dynamic>) {
      receivedPlotTransfer = PlotTransferModel.fromJson(plotTransferData);
    } else if (plotTransferData is PlotTransferModel) {
      receivedPlotTransfer = plotTransferData;
    } else {
      print(
        "SocketManager: Unknown Expense data type received: ${plotTransferData.runtimeType}",
      );
      return;
    }

    plotTransfers.insert(0, receivedPlotTransfer); // Add to raw list
    searchPlotTransfers(); // Re-run search to update filtered list if it matches current filters
    print('New Expense added via socket: ${receivedPlotTransfer.plotInfoId}');
  }

  /// Filters the _expenseVouchers list based on search text and date range.
  void searchPlotTransfers() {
    // No need for isLoading.value = true/false here if this is called frequently
    // by text listeners. It's too granular and might cause flickers.
    // Only use isLoading for actual async operations.

    final String searchText = plotNameSearchController.text.toLowerCase();
    final DateTime? selectedFromDate = fromDate.value;
    final DateTime? selectedToDate = toDate.value;

    final List<PlotTransferModel> tempFilteredList =
        plotTransfers.where((plotTransfer) {
          final String headName =
              plotTransfer.plotInfoId?['plotNo'].toLowerCase() ?? '';
          final DateTime? transferDate = plotTransfer.transferDate;

          // Filter by expense head name
          final bool matchesSearchText = headName.contains(searchText);

          // Filter by date range
          bool isInDateRange = true;
          if (transferDate == null) {
            isInDateRange =
                false; // A voucher without a date cannot be in a date range
          } else {
            // Normalize voucherDate to start of day for comparison
            final DateTime normalizedVoucherDate = DateTime(
              transferDate.year,
              transferDate.month,
              transferDate.day,
            );

            if (selectedFromDate != null) {
              // Compare with start of selectedFromDate
              final DateTime fromStartOfDay = DateTime(
                selectedFromDate.year,
                selectedFromDate.month,
                selectedFromDate.day,
              );
              if (normalizedVoucherDate.isBefore(fromStartOfDay)) {
                isInDateRange = false;
              }
            }
            if (selectedToDate != null) {
              // Compare with end of selectedToDate
              final DateTime toEndOfDay = DateTime(
                selectedToDate.year,
                selectedToDate.month,
                selectedToDate.day,
                23,
                59,
                59,
                999,
              );
              if (normalizedVoucherDate.isAfter(toEndOfDay)) {
                isInDateRange = false;
              }
            }
          }

          return matchesSearchText && isInDateRange;
        }).toList();

    filteredPlotTransfers.assignAll(tempFilteredList);
    print(
      "DailyExpenseController: Filtered expenses count: ${filteredPlotTransfers.length}",
    );
  }

  /// Filters the _assetVouchers list based on search text and date range.

  /// Fetches all expense vouchers for a given company ID.
  Future<void> getPlotTransfers() async {
    // isLoading.value = true; // Managed by _loadInitialData now
    try {
      //final timestamp = DateTime.now().millisecondsSinceEpoch;
      //final url = '/plot_transfer/fetch_plot_transfer?cachebust=$timestamp';
      final url = '/plot_info/plot_transfer/fetch_plot_transfer';
      var fetchedPlotTransfer = await _plotTransferRepository.getPlotTransfers(
        url,
      );
      plotTransfers.assignAll(fetchedPlotTransfer);
    } catch (e) {
      print("PlotTransferController: Error fetching Plot Transfer: $e");
      Get.snackbar(
        'Error',
        'Failed to load Plot Transfer: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    // finally { isLoading.value = false; } // Managed by _loadInitialData now
  }

  /// Opens a date picker to select the "From" date and triggers a search.
  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      fromDate.value = DateTime(
        picked.year,
        picked.month,
        picked.day,
      ); // Set to start of the day
      fromDateTextController.text = DateFormat(
        'dd-MMM-yyyy',
      ).format(fromDate.value!);
      searchPlotTransfers(); // Trigger search for both expenses and assets
    }
  }

  /// Opens a date picker to select the "To" date and triggers a search.
  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? DateTime.now(),
      firstDate:
          fromDate.value ??
          DateTime(2000), // Ensure toDate is not before fromDate
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      toDate.value = DateTime(
        picked.year,
        picked.month,
        picked.day,
        23,
        59,
        59,
        999,
      ); // Set to end of the day
      toDateTextController.text = DateFormat(
        'dd-MMM-yyyy',
      ).format(toDate.value!);
      searchPlotTransfers(); // Trigger search for both expenses and assets
    }
  }

  /// Saves a new expense voucher.
  Future<PlotTransferModel> savePlotTransfer(
    PlotTransferModel plotTransferModel,
  ) async {
    isLoading.value = true;
    try {
      PlotTransferModel newEntry = await _plotTransferRepository
          .savePlotTransfer(plotTransferModel);

      //SocketManager.singleton.socket?.emit('new_plot_Transfer', newEntry);

      return newEntry;
    } catch (e) {
      print("PlotTransferController: Error saving Plot transfer: $e");
      Get.snackbar(
        'Error',
        'Failed to save Plot Transfer: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow; // Rethrow to allow the calling widget to handle if needed
    } finally {
      isLoading.value = false;
    }
  }

  /// Clears various text fields and resets focus.
  void clearTextFields(BuildContext context) {
    transferDateTextEditingController.clear();
    transferFeeTextEditingController.text =
        "0.0"; // Reset to "0.0" for consistency

    // Reset date filters (optional, depending on UX)
    final now = DateTime.now();
    fromDate.value = DateTime(now.year, now.month, now.day);
    toDate.value = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    fromDateTextController.text = DateFormat(
      'dd-MMM-yyyy',
    ).format(fromDate.value!);
    toDateTextController.text = DateFormat('dd-MMM-yyyy').format(toDate.value!);
    // Trigger search after clearing/resetting filters
    searchPlotTransfers();

    FocusScope.of(context).requestFocus(plotNameFocusNode);
  }

  @override
  void onClose() {
    print("PlotTransferController: onClose called. Disposing resources.");
    _companyDataLoadingDisposer(); // Dispose the ever listener
    plotNameSearchController.removeListener(searchPlotTransfers);

    // Dispose all TextEditingControllers
    fromDateTextController.dispose();
    toDateTextController.dispose();
    transferDateTextEditingController.dispose();
    transferFeeTextEditingController.dispose();

    // Dispose all FocusNodes
    plotNameFocusNode.dispose();
    plotTransferFocusNode.dispose();

    super.onClose();
  }
}

// Ensure Formatter class is accessible or defined within this file/project
class Formatter {
  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  static DateTime? parseDate(String dateString) {
    try {
      // Handles 'dd-MM-yyyy' (from your previous code)
      final parts = dateString.split(
        '-',
      ); // Changed from '/' to '-' based on your DateFormat usage
      if (parts.length == 3) {
        // Assuming format is dd-MM-yyyy or dd-MMM-yyyy (will attempt parse)
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      // If the format is 'dd-MMM-yyyy', need to handle month name parsing or use parseStrict
      // Example for 'dd-MMM-yyyy':
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      return formatter.parseStrict(dateString);
    } catch (e) {
      print("Error parsing date: $dateString, $e");
    }
    return null;
  }
}
