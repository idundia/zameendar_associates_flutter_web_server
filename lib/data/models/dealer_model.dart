class DealerModel {
  String? sId;
  dynamic subsidaryId;
  String? userId;
  String? companyId;
  String? dealerName;
  String? fatherName;
  String? cnic;
  String? postalAddress;
  String? mobileNo;
  String? emailAddress;
  String? createdOn;
  String? updatedOn;
  String? get dealerWithMobile {
    String? cust = "";
    if (dealerName == null) {
      return cust;
    }
    return '${dealerName!} ${mobileNo!}'.toLowerCase();
  }

  DealerModel({
    this.sId,
    this.userId,
    this.companyId,
    this.dealerName,
    this.fatherName,
    this.cnic,
    this.postalAddress,
    this.mobileNo,
    this.emailAddress,
    this.createdOn,
    this.updatedOn,
  });
  @override
  String toString() => '$dealerName $mobileNo';
  DealerModel.fromJson(Map<String, dynamic> json) {
    sId = json["_id"];
    /*
    // Check the type of the userId field in the JSON
    if (json["userId"] is Map<String, dynamic>) {
      // It's a populated object, so parse it
      userId = UserModel.fromJson(json["userId"]);
      userIdString = userId?.sId; // Store the ID from the populated model
    } else if (json["userId"] is String) {
      // It's just a string ID, so store it directly
      userIdString = json["userId"];
    }
*/
    subsidaryId = json["subsidaryId"];

    userId = json["userId"];
    companyId = json["companyId"];
    dealerName = json["dealerName"];
    fatherName = json["fatherName"];
    cnic = json["cnic"];
    postalAddress = json["postalAddress"];
    mobileNo = json["mobileNo"];
    emailAddress = json["emailAddress"];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = sId;
    data["userId"] = userId;
    data["companyId"] = companyId;
    data["dealerName"] = dealerName;
    data["fatherName"] = fatherName;
    data["cnic"] = cnic;
    data["postalAddress"] = postalAddress;
    data["mobileNo"] = mobileNo;
    data["emailAddress"] = emailAddress;
    data["createdOn"] = createdOn;
    data["updatedOn"] = updatedOn;
    return data;
  }
}
