import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zameendar_web_app/data/controllers/company_controller.dart';
import 'package:zameendar_web_app/data/controllers/vendor_controller.dart';
import 'package:zameendar_web_app/data/models/projects/project_info_model.dart';
import 'package:zameendar_web_app/data/repositories/project_info_repository.dart';

class ProjectInfoController extends GetxController {
  final CompanyController companyController = Get.find();
  final VendorController vendorController = Get.find();
  final ProjectInfoRepository _projectRepository = ProjectInfoRepository();

  RxList<ProjectInfoModel> projects = <ProjectInfoModel>[].obs;
  Rxn<ProjectInfoModel> selectedProject = Rxn<ProjectInfoModel>();
  // Text Editing Controllers
  //final TextEditingController vendorNameTextControler = TextEditingController();

  final TextEditingController projectNameTextControler =
      TextEditingController();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController startDateTextController = TextEditingController();
  final TextEditingController closingDateTextController =
      TextEditingController();

  // Reactive Variables
  //final Rx<CompanyModel?> selectedCompany = Rxn<CompanyModel>();
  //final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  final Rx<DateTime?> startDate = Rxn<DateTime>();
  final Rx<DateTime?> closingDate = Rxn<DateTime>();
  final RxBool isLoading = false.obs;
  final RxString recordMode = "Save".obs; // "Save" or "Update"
  //String? currentProjectId;
  Map<String, dynamic>? currentProjectId;
  FocusNode projectNameFocus = FocusNode();

  File? logoPicture;

  @override
  void onInit() {
    super.onInit();
    //fetchCompanies();
    fetchProjects();
  }
  /*
  Future<void> fetchCompanies() async {
    isLoading.value = true;
    try {
      final fetchedCompanies = await _projectRepository.getAllCompanies();
      companies.assignAll(fetchedCompanies);
      if (companies.isNotEmpty) {
        // Optionally pre-select the first company or a default one
        // selectedCompany.value = companies.first;
      }
    } finally {
      isLoading.value = false;
    }
  }*/

  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      final fetchedProjects = await _projectRepository.getAllProjects();
      projects.assignAll(fetchedProjects);
      if (projects.isNotEmpty) {
        selectedProject.value = projects.first;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProjectsByVendors(String vendorSubsidaryId) async {
    isLoading.value = true;
    try {
      final fetchedProjects = await _projectRepository.getProjectByVendor(
        vendorSubsidaryId,
      );
      projects.assignAll(fetchedProjects);
      if (projects.isNotEmpty) {
        selectedProject.value = projects.first;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(
    BuildContext context,
    Rx<DateTime?> dateRx,
    TextEditingController textController,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateRx.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateRx.value = picked;
      textController.text = DateFormat('dd-MMM-yyyy').format(picked);
    }
  }

  void setProjectForEdit(ProjectInfoModel project) {
    recordMode.value = "Update";
    currentProjectId = project.id; // Use your custom 'id' field
    projectNameTextControler.text = project.projectName ?? '';
    addressController.text = project.address ?? '';
    cityController.text = project.city ?? '';
    provinceController.text = project.province ?? '';

    if (project.startDate != null) {
      startDate.value = project.startDate;
      startDateTextController.text = DateFormat(
        'dd-MMM-yyyy',
      ).format(project.startDate!);
    } else {
      startDate.value = null;
      startDateTextController.clear();
    }

    if (project.closingDate != null) {
      closingDate.value = project.closingDate;
      closingDateTextController.text = DateFormat(
        'dd-MMM-yyyy',
      ).format(project.closingDate!);
    } else {
      closingDate.value = null;
      closingDateTextController.clear();
    }
    /*
    // Find and set the selected company
    if (project.companyId != null) {
      selectedCompany.value =
          companies.firstWhereOrNull((comp) => comp.sId == project.companyId);
    } else {
      selectedCompany.value = null;
    }*/
  }

  Future<void> saveProject() async {
    /*
    if (selectedCompany.value == null) {
      Get.snackbar('Error', 'Please select a Company.');
      return;
    }*/
    if (projectNameTextControler.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        provinceController.text.isEmpty ||
        startDate.value ==
            null //||
    //closingDate.value == null
    ) {
      Get.snackbar('Error', 'Please fill all required fields.');
      return;
    }

    isLoading.value = true;
    final project = ProjectInfoModel(
      id: recordMode.value == "Update" ? currentProjectId : null,
      companyId:
          companyController
              .currenctCompanyInfo
              .value
              .sId, //selectedCompany.value!.sId,
      projectName: projectNameTextControler.text.trim(),
      startDate: startDate.value,
      closingDate: closingDate.value,
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      province: provinceController.text.trim(),
      logoPicture: logoPicture?.path,
    );

    try {
      if (recordMode.value == "Save") {
        ProjectInfoModel projectNew = await _projectRepository.createProject(
          project,
          imageFile: logoPicture,
        );

        if (projectNew != null) {
          projects.add(projectNew);
        }
      } else {
        await _projectRepository.updateProject(
          currentProjectId!['projectInfoId'],
          project,
        );
      }
      clearForm();
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    projectNameTextControler.clear();
    addressController.clear();
    cityController.clear();
    provinceController.clear();
    startDateTextController.clear();
    closingDateTextController.clear();
    startDate.value = null;
    closingDate.value = null;
    recordMode.value = "Save";
    currentProjectId = null;
  }

  @override
  void onClose() {
    projectNameTextControler.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    startDateTextController.dispose();
    closingDateTextController.dispose();
    super.onClose();
  }
}
