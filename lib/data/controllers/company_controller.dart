import 'package:flutter/material.dart';
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
          .getCompanyInfos("/company/company_infos");
      _companyInfos.assignAll(fetchedCompanies);

      if (_companyInfos.isNotEmpty) {
        currenctCompanyInfo.value = _companyInfos.first;
        print(
          "CompanyController: Company info loaded: ${currenctCompanyInfo.value.companyName}",
        );
      } else {
        currenctCompanyInfo.value = CompanyModel();
        print("CompanyController: No company infos fetched.");
      }
      hasCompanyDataLoaded.value = true;
    } catch (e) {
      print("CompanyController: Error loading company infos: $e");

      // Safely trigger snackbar only if overlay context is ready
      if (Get.context != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Error",
            "Failed to load company info: $e",
            snackPosition: SnackPosition.BOTTOM,
          );
        });
      }
      hasCompanyDataLoaded.value = false;
    } finally {
      isCompanyDataLoading.value = false;
      print("CompanyController: Company info loading finished.");
    }
  }

  // You might want a method to update the current company
  void setCurrentCompany(CompanyModel company) {
    currenctCompanyInfo.value = company;
  }
}
