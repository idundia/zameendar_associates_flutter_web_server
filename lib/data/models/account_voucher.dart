import 'package:zameendar_web_app/data/models/vendor_info.dart';

class AccountVoucher {
  //String? sId;
  //UserModel? user;
  DateTime? voucherDate;
  VendorInfo? subsidaryInfo;
  double? previousBalance;

  double? payableAmount;

  double? paid;

  double? balance;

  String? paymentMethod;

  AccountVoucher({
    //this.sId,
    //this.user,
    this.voucherDate,
    this.subsidaryInfo,
    this.previousBalance,
    this.payableAmount,
    this.paid,
    this.balance,
    this.paymentMethod,
  });

  AccountVoucher.fromJson(Map<String, dynamic> json) {
    //sId = json['_id'];
    subsidaryInfo = VendorInfo.fromJson(json['subsidaryInfo']);

    if (json['previousBalance'] is Map) {
      var mapPrevBalance =
          json['previousBalance'].entries.map((e) => e.value).toList();
      previousBalance = double.tryParse(mapPrevBalance[0]);
    } else {
      previousBalance = double.tryParse(json['previousBalance'].toString());
    }

    if (json['payableAmount'] is Map) {
      var mapPayableBalance =
          json['payableAmount'].entries.map((e) => e.value).toList();
      payableAmount = double.tryParse(mapPayableBalance[0]);
    } else {
      payableAmount = double.tryParse(json['payableAmount'].toString());
    }

    //paid = json['paid'];
    if (json['paid'] is Map) {
      var mapPaid = json['paid'].entries.map((e) => e.value).toList();
      paid = double.tryParse(mapPaid[0]);
    } else {
      paid = double.tryParse(json['paid'].toString());
    }

    //balance = json['balance'];
    if (json['balance'] is Map) {
      var mapBalance = json['balance'].entries.map((e) => e.value).toList();
      balance = double.tryParse(mapBalance[0]);
    } else {
      balance = double.tryParse(json['balance'].toString());
    }
    paymentMethod = json['paymentMethod'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    //data['_id'] = sId;
    //data['user'] = user!.toJson();
    data['subsidaryInfo'] = subsidaryInfo!.toJson();
    data['previousBalance'] = previousBalance;
    data['payableAmount'] = payableAmount;
    data['paid'] = paid;

    data['balance'] = balance;

    data['paymentMethod'] = paymentMethod;

    return data;
  }
}
