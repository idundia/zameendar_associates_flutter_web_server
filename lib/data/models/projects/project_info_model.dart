class ProjectInfoModel {
  //final String? id; // Your custom 'id' field
  //Map<String, dynamic>? id;
  dynamic id;
  final String? companyId;
  final String? projectName;
  final DateTime? startDate;
  final DateTime? closingDate;
  final String? address;
  final String? city;
  final String? province;
  String? logoPicture;
  final DateTime? updatedOn;
  final DateTime? createdOn;

  ProjectInfoModel({
    this.id,
    this.companyId,
    this.projectName,
    this.startDate,
    this.closingDate,
    this.address,
    this.city,
    this.province,
    this.logoPicture,
    this.updatedOn,
    this.createdOn,
  });

  factory ProjectInfoModel.fromJson(Map<String, dynamic> json) {
    return ProjectInfoModel(
      //id: json['_id'],

      id: json['_id'],

      companyId: json['companyId'] as String?,
      projectName: json['projectName'] as String?,
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      closingDate: json['closingDate'] != null
          ? DateTime.parse(json['closingDate'])
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      logoPicture: json['logoPicture'] as String?,
      updatedOn:
          json['updatedOn'] != null ? DateTime.parse(json['updatedOn']) : null,
      createdOn:
          json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'projectName': projectName,
      'startDate': startDate?.toIso8601String(),
      'closingDate':
          (closingDate != null) ? closingDate?.toIso8601String() : null,
      'address': address,
      'city': city,
      'province': province,
      'logoPicture': logoPicture,
      'updatedOn': updatedOn?.toIso8601String(),
      'createdOn': createdOn?.toIso8601String(),
    };
  }
}
