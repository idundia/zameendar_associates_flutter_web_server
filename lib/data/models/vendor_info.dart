class VendorInfo {
  String? sId;
  String? subsidaryId;
  String? userId; // A new field to hold the raw ID
  String? companyId;
  String? vendorName;
  String? companyName;
  String? fatherName;
  String? cnic;
  String? phoneNo;
  String? mobileNo;
  String? emailAddress;
  String? postalAddress;
  String? vendorType; // individual or company
  String? createdOn;
  String? updatedOn;
  String? get vendorFullName {
    return '${vendorName ?? ''}${companyName ?? ''}';
  }

  String? get vendorWithMobile {
    return '${vendorName ?? ''}${companyName ?? ''} ${mobileNo ?? ''}';
  }

  VendorInfo({
    this.sId,
    this.userId,
    this.companyId,
    this.vendorName,
    this.companyName,
    this.fatherName,
    this.cnic,
    this.phoneNo,
    this.mobileNo,
    this.postalAddress,
    this.vendorType,
    this.createdOn,
    this.updatedOn,
  });
  @override
  String toString() => '$vendorName $mobileNo';
  VendorInfo.fromJson(Map<String, dynamic> json) {
    sId = json["_id"];
    subsidaryId = json["subsidaryId"];
    userId = json["userId"];
    companyId = json["companyId"];
    companyName = json["companyName"];
    vendorName = json["vendorName"];
    fatherName = json["fatherName"];
    cnic = json["cnic"];
    mobileNo = json["mobileNo"];
    phoneNo = json["phoneNo"];
    postalAddress = json["postalAddress"];
    vendorType = json["vendorType"];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = sId;
    data["userId"] = userId;
    data["companyId"] = companyId;
    data["vendorName"] = vendorName;
    data["companyName"] = companyName;
    data["fatherName"] = fatherName;
    data["cnic"] = cnic;
    data["mobileNo"] = mobileNo;
    data["phoneNo"] = phoneNo;
    data["postalAddress"] = postalAddress;
    data["vendorType"] = vendorType;
    data["createdOn"] = createdOn;
    data["updatedOn"] = updatedOn;
    return data;
  }
}
