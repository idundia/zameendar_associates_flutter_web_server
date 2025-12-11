import 'package:zameendar_web_app/data/models/customer_model.dart';
import 'package:zameendar_web_app/data/models/dealer_model.dart';
import 'package:zameendar_web_app/data/models/vendor_info.dart';

class SubsidaryModel {
  String? sId;

  dynamic customerId;
  dynamic dealerId;
  dynamic vendorId;

  String? subsidaryId;
  String? subsidaryName;
  String? mobileNo;
  String? subsidaryType;
  SubsidaryModel({
    this.subsidaryId,
    this.subsidaryName,
    this.mobileNo,
    this.subsidaryType,
  });

  SubsidaryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subsidaryId = json['_id'];
    if (json['customerId'] != null) {
      if (json['customerId'] is Map) {
        customerId = CustomerModel.fromJson(json['customerId']);
        //subsidaryId = customerId.sId.toString();
        subsidaryName = customerId.customerName.toString();
        mobileNo = customerId.mobileNo.toString();
      }
    }

    if (json['dealerId'] != null) {
      if (json['dealerId'] is Map) {
        dealerId = DealerModel.fromJson(json['dealerId']);
        //subsidaryId = dealerId.sId.toString();
        subsidaryName = dealerId.dealerName.toString();
        mobileNo = dealerId.mobileNo.toString();
      }
    }

    if (json['vendorId'] != null) {
      if (json['vendorId'] is Map) {
        vendorId = VendorInfo.fromJson(json['vendorId']);
        //subsidaryId = vendorId.sId.toString();
        subsidaryName =
            "${vendorId.vendorName.toString()} ${vendorId.companyName.toString()}";
        mobileNo = vendorId.mobileNo.toString();
      }
    }
    subsidaryType = json['subsidaryType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['dealerId'] = dealerId;
    data['vendorId'] = vendorId;
    data['subsidaryType'] = subsidaryType;
    return data;
  }
}
