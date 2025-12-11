//import 'package:json_annotation/json_annotation.dart';
//part 'user_model.g.dart';

//@JsonSerializable()
//@JsonSerializable()
class UserModel {
  String? sId;
  String? companyId;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? city;
  String? state;
  int? profileProgress;
  //bool? isAdmin = false;
  String? role;
  //String? id;
  String? createdOn;
  String? updatedOn;

  UserModel({
    this.sId,
    this.companyId,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.profileProgress,
    this.role,
    //this.isAdmin,
    //this.id,
    this.createdOn,
    this.updatedOn,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyId = json['companyId'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    profileProgress = json['profileProgress'];
    //isAdmin = json['isAdmin'];
    role = json['role'];
    //id = json['id'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['_id'] = sId;
    data['companyId'] = companyId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['profileProgress'] = profileProgress;
    //data['isAdmin'] = isAdmin;
    data['role'] = role;
    //data['id'] = id;
    //data['createdOn'] = createdOn;
    //data['updatedOn'] = updatedOn;
    return data;
  }
}
