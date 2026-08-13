import 'package:zameendar_web_app/data/controllers/company_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/data/models/account_voucher.dart';
import 'package:zameendar_web_app/data/models/supplier_ledger_model.dart';
import 'package:zameendar_web_app/data/models/vendor_info.dart';
import 'package:zameendar_web_app/data/repositories/vendor_info_repository.dart';

class VendorController extends GetxController {
  CompanyController companyController = Get.find();
  Rx<VendorInfo> currentVendorInfo = VendorInfo().obs;
  VendorInfoRepository supplierRepository = VendorInfoRepository();
  //var _customers = <CustomerModel>[].obs;
  //RxList<VoucherDetail> customerBalances = <VoucherDetail>[].obs;
  Rxn<double> previousBalance = Rxn();
  late RxList<VendorInfo> _vendors = RxList<VendorInfo>([]);
  RxList<VendorInfo> get vendorInfos => _vendors;
  List<SupplierLedgerModel> _supplierLedger = <SupplierLedgerModel>[];
  List<SupplierLedgerModel> get supplierLedger => _supplierLedger;

  TextEditingController companyNameController = TextEditingController();
  TextEditingController fatherNameTextController = TextEditingController();
  TextEditingController individualNameTextController = TextEditingController();
  TextEditingController supplierNameSearchController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController postalAddressTextController = TextEditingController();
  TextEditingController cnicTextController = TextEditingController();

  TextEditingController emailAddressTextController = TextEditingController();

  TextEditingController openingDateTextController = TextEditingController();

  TextEditingController paidInstallmentController = TextEditingController();
  TextEditingController supplierOgraiPreviousBalanceController =
      TextEditingController();
  TextEditingController supplierOgraiBalanceController =
      TextEditingController();

  RxString recordMode = "Save".obs;
  String vendorID = "";

  RxList<VendorInfo> filteredVendors = <VendorInfo>[].obs;
  //List<SubsidaryInfo> get filteredSupp...

  // This is the new method to fetch all vendors from the repository.
  Future<void> getAllVendors() async {
    try {
      final vendors = await supplierRepository.getAllVendors('/vendor_info');
      _vendors.assignAll(vendors);
    } catch (e) {
      // You should handle errors here, e.g., show a snackbar or log the error.
      print('Error fetching vendors: $e');
    }
  }

  Future<List<SupplierLedgerModel>> getSupplierLedger(
    VendorInfo supplier,
  ) async {
    _supplierLedger = await supplierRepository.getSupplierLedger(
      '/supplier/supplierledger/${supplier.sId}',
    );
    return _supplierLedger;
  }

  Future<List<SupplierLedgerModel>> getSupplierLedger_Report(
    VendorInfo supplier,
  ) async {
    _supplierLedger = await supplierRepository.getSupplierLedger_Report(
      '/supplier/supplierledger_report/${supplier.sId}',
    );
    return _supplierLedger;
  }

  Future<void> getSupplier_PreviousBalance(String subsidaryId) async {
    previousBalance.value = await supplierRepository.getAllSupplier_Balance(
      '/vendor_info/balance/$subsidaryId',
    );
    //return previouseBalance.value ?? 0.0;
  }

  Future<bool> saveVoucher(AccountVoucher voucherMain) async {
    try {
      bool success = false;
      success = await supplierRepository.saveVoucher(voucherMain);

      return success;
    } catch (ex) {
      rethrow;
    }
  }

  void updateSuppliers(List<VendorInfo> newCustomers) {
    vendorInfos.value = newCustomers;
    filterSuppliers();
  }

  Future<VendorInfo> saveVendor(VendorInfo vendorModel) async {
    var vendorInfo = VendorInfo();
    if (recordMode.value == "Save") {
      vendorInfo = await supplierRepository.save('/vendor_info', {
        "userId": companyController.currenctUserInfo.value.sId,
        "companyId": companyController.currenctCompanyInfo.value.sId,
        "companyName": vendorModel.companyName,
        "vendorName": vendorModel.vendorName,
        "fatherName": vendorModel.fatherName,
        "cnic": vendorModel.cnic,
        "mobileNo": vendorModel.mobileNo,
        "phoneNo": vendorModel.phoneNo,
        "postalAddress": vendorModel.postalAddress,
        "emailAddress": vendorModel.emailAddress,
        "vendorType": vendorModel.vendorType,
      });
      _vendors.value.add(vendorInfo);
      _vendors.refresh();
    } else if (recordMode.value == "Update") {
      vendorInfo = await supplierRepository
          .update('/vendor_info/${vendorModel.sId}', {
            "userId": companyController.currenctUserInfo.value.sId,
            "companyId": vendorModel.companyId!,
            "vendorName": vendorModel.vendorName,
            "fatherName": vendorModel.fatherName,
            "cnic": vendorModel.cnic,
            "companyName": vendorModel.companyName,
            "mobileNo": vendorModel.mobileNo,
            "phoneNo": vendorModel.phoneNo,
            "postalAddress": vendorModel.postalAddress,
            "vendorType": vendorModel.vendorType,
          });
      for (var vendor in _vendors.value) {
        if (vendor.sId == vendorModel.sId) {
          vendor.companyId = vendorInfo.companyId;
          vendor.vendorName = vendorInfo.vendorName;
          vendor.companyName = vendorInfo.companyName;
          vendor.fatherName = vendorInfo.fatherName;
          vendor.cnic = vendorInfo.cnic;
          vendor.mobileNo = vendorInfo.mobileNo;
          vendor.phoneNo = vendorInfo.phoneNo;
          vendor.postalAddress = vendorInfo.postalAddress;
          vendor.vendorType = vendorInfo.vendorType;
        }
      }
    }

    return vendorInfo;
  }

  void filterSuppliers() {
    if (supplierNameSearchController.text.isEmpty) {
      filteredVendors.value = vendorInfos.value;
    } else {
      List<VendorInfo> results =
          vendorInfos.value.where((vendor) {
            return vendor.vendorWithMobile!.toLowerCase().contains(
              supplierNameSearchController.text.toLowerCase(),
            );
          }).toList();
      filteredVendors.value = results;
    }
  }
}
