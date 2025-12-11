import 'package:get/get.dart';
import 'package:zameendar_web_app/data/models/company_model.dart';
import 'package:zameendar_web_app/data/models/user_model.dart';
import 'package:zameendar_web_app/data/repositories/company_repository.dart';

class CompanyController extends GetxController {
  final RxList<CompanyModel> _companyInfos = <CompanyModel>[].obs;
  RxList<CompanyModel> get companyInfos => _companyInfos;

  // Initialize with a default, empty CompanyModel so .value is never null
  final Rx<CompanyModel> currenctCompanyInfo = CompanyModel().obs;

  final Rx<UserModel> currenctUserInfo = UserModel().obs;

  final CompanyRepository _companyRepository = CompanyRepository();

  // Add a loading indicator for the company data itself
  final RxBool isCompanyDataLoading = true.obs;
  final RxBool hasCompanyDataLoaded =
      false.obs; // To indicate if initial load completed

  @override
  void onInit() async {
    // Make onInit async to await loading
    super.onInit();
    print("CompanyController: onInit called.");
    await loadCompanyInfos(); // Await the initial company info load
    print("CompanyController: Finished onInit.");
  }

  Future<void> loadCompanyInfos() async {
    isCompanyDataLoading.value = true;
    try {
      print("CompanyController: Starting to fetch company infos...");
      RxList<CompanyModel> fetchedCompanies = await _companyRepository
          .getCompanyInfos("/company/company_infos");
      _companyInfos.assignAll(fetchedCompanies);

      if (_companyInfos.isNotEmpty) {
        currenctCompanyInfo.value =
            _companyInfos.first; // Set the first company as current
        print(
          "CompanyController: Company info loaded: ${currenctCompanyInfo.value.companyName}, sId: ${currenctCompanyInfo.value.sId}",
        );
      } else {
        currenctCompanyInfo.value =
            CompanyModel(); // Ensure it's still an empty model if no data
        print(
          "CompanyController: No company infos fetched. currenctCompanyInfo.sId is null.",
        );
      }
      hasCompanyDataLoaded.value = true; // Mark as loaded
    } catch (e) {
      print("CompanyController: Error loading company infos: $e");
      // Handle error: show snackbar, set currentCompanyInfo to default
      Get.snackbar(
        "Error",
        "Failed to load company info: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      hasCompanyDataLoaded.value = false; // Mark as failed to load
    } finally {
      isCompanyDataLoading.value = false;
      print(
        "CompanyController: Company info loading finished. isLoading: ${isCompanyDataLoading.value}, hasLoaded: ${hasCompanyDataLoaded.value}",
      );
    }
  }

  // You might want a method to update the current company
  void setCurrentCompany(CompanyModel company) {
    currenctCompanyInfo.value = company;
  }
}
/*
class CompanyController extends GetxController {
  final RxList<CompanyModel> _companyInfos = <CompanyModel>[].obs;
  RxList<CompanyModel> get companyInfos => _companyInfos;

  Rx<CompanyModel> currenctCompanyInfo =
      CompanyModel().obs; // Initialize with an empty model

  final CompanyRepository _companyRepository = CompanyRepository();

  // You can make onInit async if you need to await operations directly within it.
  @override
  void onInit() async {
    // Make onInit async
    super.onInit();
    print("CompanyController onInit called, starting data load...");
    await loadCompanyInfos(); // Await the data loading
    print("CompanyController: Company infos loaded.");

    // Optional: Set currentCompanyInfo if there's at least one company
    if (_companyInfos.isNotEmpty) {
      currenctCompanyInfo.value = _companyInfos.first;
      print(
          "CompanyController: Set default currentCompanyInfo to: ${currenctCompanyInfo.value.companyName}");
    } else {
      print("CompanyController: No company infos available.");
    }
  }

  Future<void> loadCompanyInfos() async {
    try {
      print("CompanyController: Fetching company infos from repository...");
      RxList<CompanyModel> fetchedAccounts =
          await _companyRepository.getCompanyInfos("/company/company_infos");
      _companyInfos.assignAll(fetchedAccounts);
      print(
          "CompanyController: Successfully assigned ${fetchedAccounts.length} company infos.");
    } catch (e) {
      print("CompanyController: Error loading company infos: $e");
      // Handle the error, e.g., show a snackbar or log to a crash reporting service
      Get.snackbar("Error", "Failed to load company information: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error);
    }
  }

  // You might want a method to update the current company
  void setCurrentCompany(CompanyModel company) {
    currenctCompanyInfo.value = company;
  }
}
*/

/*
class CompanyController extends GetxController {
  final RxList<CompanyModel> _companyInfos = <CompanyModel>[].obs;
  RxList<CompanyModel> get companyInfos => _companyInfos;

  Rx<CompanyModel> currenctCompanyInfo = CompanyModel().obs;

  final CompanyRepository _companyRepository = CompanyRepository();

  @override
  void onInit() {
    super.onInit();

    loadCompanyInfos();
  }

  Future<void> loadCompanyInfos() async {
    RxList<CompanyModel> accounts =
        await _companyRepository.getCompanyInfos("/company/company_infos");
    _companyInfos.assignAll(accounts);
  }
}
*/
