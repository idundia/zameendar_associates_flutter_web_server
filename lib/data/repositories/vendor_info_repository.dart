import 'package:zameendar_web_app/core/network_handler.dart';
import 'package:zameendar_web_app/data/models/account_voucher.dart';
import 'package:zameendar_web_app/data/models/subsidary_model.dart';
import 'package:zameendar_web_app/data/models/supplier_ledger_model.dart';
import 'package:zameendar_web_app/data/models/vendor_info.dart';

import 'package:get/get.dart';

class VendorInfoRepository {
  final NetworkHandler _networkHandler = NetworkHandler();
  Future<VendorInfo> save(String url, Map<String, dynamic> body) async {
    try {
      var response = await _networkHandler.post(url, body);

      return VendorInfo.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<VendorInfo> update(String url, Map<String, dynamic> body) async {
    try {
      var response = await _networkHandler.put(url, body);

      return VendorInfo.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<RxList<VendorInfo>> getAllVendors(String url) async {
    late RxList<VendorInfo> vendorInfos = RxList<VendorInfo>([]);
    try {
      var response = await _networkHandler.get(url);

      if (response['data'].length > 0) {
        List<VendorInfo> allVendors = <VendorInfo>[];

        var listData =
            (response['data'] as List)
                .map((supplier) => SubsidaryModel.fromJson(supplier))
                .toList();

        for (var subsidary in listData) {
          VendorInfo vendorInfo = VendorInfo();
          vendorInfo.sId = subsidary.vendorId.sId;
          vendorInfo.subsidaryId = subsidary.sId;
          vendorInfo.companyName = subsidary.vendorId.companyName;
          vendorInfo.vendorName = subsidary.vendorId.vendorName;
          vendorInfo.mobileNo = subsidary.vendorId.mobileNo;
          vendorInfo.emailAddress = subsidary.vendorId.emailAddress;
          vendorInfo.postalAddress = subsidary.vendorId.postalAddress;
          vendorInfo.vendorType = subsidary.vendorId.vendorType;

          allVendors.add(vendorInfo);
        }
        vendorInfos.assignAll(allVendors);
        return vendorInfos;
      } else {
        return RxList<VendorInfo>([]);
      }
      //return CustomerModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SupplierLedgerModel>> getSupplierLedger(String url) async {
    late List<SupplierLedgerModel> suppliers = <SupplierLedgerModel>[];
    try {
      var response = await _networkHandler.get(url);

      if (response['data'].length > 0) {
        var listData =
            (response['data'] as List)
                .map((customer) => SupplierLedgerModel.fromJson(customer))
                .toList();
        for (var customer in listData) {
          suppliers.add(customer);
        }
        return suppliers;
      } else {
        return <SupplierLedgerModel>[];
      }
      //return CustomerModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SupplierLedgerModel>> getSupplierLedger_Report(String url) async {
    late List<SupplierLedgerModel> suppliers = <SupplierLedgerModel>[];
    try {
      var response = await _networkHandler.get(url);

      if (response['data'].length > 0) {
        var listData =
            (response['data'] as List)
                .map((supplier) => SupplierLedgerModel.fromJson(supplier))
                .toList();
        for (var supplier in listData) {
          suppliers.add(supplier);
        }
        return suppliers;
      } else {
        return <SupplierLedgerModel>[];
      }
      //return CustomerModel.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getAllSupplier_Balance(String url) async {
    double? balance = 0;
    try {
      var response = await _networkHandler.get(url);

      if (response['data'] == null) {
        return balance = 0;
      }
      if (response['data'] > 0) {
        balance = double.tryParse(response['data'].toString());
      }
      return balance!;
    } catch (e) {
      rethrow;
    }
  }

  Future<VendorInfo> getSupplierBy_Name_or_Mobile(String url) async {
    VendorInfo supplier = VendorInfo();
    try {
      var response = await _networkHandler.get(url);
      if (response['data'].length > 0) {
        supplier = VendorInfo.fromJson(response['data']);
      }
      return supplier;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveVoucher(AccountVoucher voucherMain) async {
    try {
      var response = await _networkHandler.post(
        "/purchase/savevoucher",
        voucherMain.toJson(),
      );
      if (response['success'] == true) {
        return true;
      }
      return false;
    } catch (ex) {
      rethrow;
    }
  }
}
