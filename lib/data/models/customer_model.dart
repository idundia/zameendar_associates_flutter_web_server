import 'package:zameendar_web_app/data/models/company_model.dart';
import 'package:zameendar_web_app/data/models/user_model.dart';

class CustomerModel {
  String? sId;
  String? subsidaryId;
  int? customerId;
  String? userIdString; // A new field to hold the raw ID
  dynamic userId; // The nullable UserModel
  String? companyIdString;
  dynamic companyId;
  String? customerName;
  String? fatherName;
  String? cnic;
  String? postalAddress;
  String? residentionalAddress;
  String? occupation;
  String? nationality;
  String? mobileNo;
  String? resNo;
  String? emailAddress;
  String? profilePicture;
  String? password;
  String? customerType;
  String? createdOn;
  String? updatedOn;
  String? get customerWithMobile {
    String? cust = "";
    if (customerName == null) {
      return cust;
    }
    return '${customerName!} ${mobileNo!}';
  }

  CustomerModel({
    this.customerId,
    this.subsidaryId,
    this.sId,
    this.userId,
    this.companyId,
    this.customerName,
    this.fatherName,
    this.cnic,
    this.postalAddress,
    this.residentionalAddress,
    this.occupation,
    this.nationality,
    this.mobileNo,
    this.resNo,
    this.emailAddress,
    this.profilePicture,
    this.password,
    this.customerType,
    this.createdOn,
    this.updatedOn,
  });
  @override
  String toString() => '$customerName $mobileNo';
  CustomerModel.fromJson(Map<String, dynamic> json) {
    sId = json["_id"];
    // Check the type of the userId field in the JSON
    if (json["userId"] != null) {
      if (json["userId"] is Map<String, dynamic>) {
        // It's a populated object, so parse it
        userId = UserModel.fromJson(json["userId"]);
        userIdString = userId?.sId; // Store the ID from the populated model
      } else if (json["userId"] is String) {
        // It's just a string ID, so store it directly
        userIdString = json["userId"];
      }
    }

    // Do the same for companyId
    if (json["companyId"] is Map<String, dynamic>) {
      companyId = CompanyModel.fromJson(json["companyId"]);
      companyIdString = companyId?.sId;
    } else if (json["companyId"] is String) {
      companyIdString = json["companyId"];
    }
    customerId = json["customerId"];

    customerName = json["customerName"];
    fatherName = json["fatherName"];
    cnic = json["cnic"];
    postalAddress = json["postalAddress"];
    residentionalAddress = json["residentionalAddress"];
    occupation = json["occupation"];
    nationality = json["nationality"];
    mobileNo = json["mobileNo"];
    resNo = json["resNo"];
    emailAddress = json["emailAddress"];
    profilePicture = json["profilePicture"];
    password = json["password"];
    customerType = json["customerType"];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["userId"] = userId;
    data["companyId"] = companyId;
    data["customerName"] = customerName;
    data["fatherName"] = fatherName;
    data["cnic"] = cnic;
    data["postalAddress"] = postalAddress;
    data["residentionalAddress"] = residentionalAddress;
    data["occupation"] = occupation;
    data["nationality"] = nationality;
    data["mobileNo"] = mobileNo;
    data["resNo"] = resNo;
    data["emailAddress"] = emailAddress;
    data["profilePicture"] = profilePicture;
    data["password"] = password;
    data["customerType"] = customerType;

    return data;
  }
}
