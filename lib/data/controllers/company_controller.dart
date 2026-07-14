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
  void onInit() {
    // Make onInit async to await loading
    super.onInit();
    print("CompanyController: onInit called.");
    loadCompanyInfos(); // Await the initial company info load
    print("CompanyController: Finished onInit.");
  }

  void loadCompanyInfos() async {
    isCompanyDataLoading.value = true;
    try {
      print("CompanyController: Starting to fetch company infos...");
      RxList<CompanyModel> fetchedCompanies = await _companyRepository
          .getCompanyInfos("/api/company/company_infos");
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
