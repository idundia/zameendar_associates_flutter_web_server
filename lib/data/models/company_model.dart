class CompanyModel {
  String? sId;
  String? companyName;
  int? numberofUsers;
  String? address;
  String? city;
  String? state;
  String? createdOn;
  String? updatedOn;

  CompanyModel(
      {this.sId,
      this.companyName,
      this.numberofUsers,
      this.address,
      this.city,
      this.state,
      this.createdOn,
      this.updatedOn});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    if (json['_id'] != null) {
      sId = json['_id'];
    }
    companyName = json['companyName'];
    numberofUsers = json['numberofUsers'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sId != null) {
      data['_id'] = sId;
    }
    data['companyName'] = companyName;
    data['numberofUsers'] = numberofUsers;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}
