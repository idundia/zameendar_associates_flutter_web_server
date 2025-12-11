class SupplierLedgerModel {
  int? invoiceNo;
  DateTime? voucherDate;
  String? description;

  double? previousBalance;

  double? purchaseHead;

  double? netpayable;

  double? cashHead;
  String? paymentMethod;
  double? balanceHead;

  double? dr;
  double? cr;
  double? balance;
  SupplierLedgerModel(
      {this.invoiceNo,
      this.voucherDate,
      this.description,
      this.previousBalance,
      this.purchaseHead,
      this.netpayable,
      this.cashHead,
      this.paymentMethod,
      this.balanceHead,
      this.dr,
      this.cr,
      this.balance});
  SupplierLedgerModel.fromJson(Map<String, dynamic> json) {
    //customerModelId = CustomerModel.fromJson(json["customerModelId"]);
    // sId = json["_id"];
    invoiceNo = json["invoiceNo"];
    voucherDate = DateTime.tryParse(json["voucherDate"]);
    description = json["description"];

    if (json['previousBalance'] is Map) {
      var mapPrice =
          json['previousBalance'].entries.map((e) => e.value).toList();
      previousBalance = double.tryParse(mapPrice[0]);
    } else {
      previousBalance = double.tryParse(json['previousBalance'].toString());
    }

    if (json['purchaseHead'] is Map) {
      var mapPrice = json['purchaseHead'].entries.map((e) => e.value).toList();
      purchaseHead = double.tryParse(mapPrice[0]);
    } else {
      purchaseHead = double.tryParse(json['purchaseHead'].toString());
    }
    //net payable

    if (json['netpayable'] is Map) {
      var mapPrice = json['netpayable'].entries.map((e) => e.value).toList();
      netpayable = double.tryParse(mapPrice[0]);
    } else {
      netpayable = double.tryParse(json['netpayable'].toString());
    }

    //Cash head

    if (json['cashHead'] is Map) {
      var mapPrice = json['cashHead'].entries.map((e) => e.value).toList();
      cashHead = double.tryParse(mapPrice[0]);
    } else {
      cashHead = double.tryParse(json['cashHead'].toString());
    }

    paymentMethod = json["paymentMethod"];

    if (json['balanceHead'] is Map) {
      var mapPrice = json['balanceHead'].entries.map((e) => e.value).toList();
      balanceHead = double.tryParse(mapPrice[0]);
    } else {
      balanceHead = double.tryParse(json['balanceHead'].toString());
    }

    if (json['dr'] is Map) {
      var mapPrice = json['dr'].entries.map((e) => e.value).toList();
      dr = double.tryParse(mapPrice[0]);
    } else {
      dr = double.tryParse(json['dr'].toString());
    }

    if (json['cr'] is Map) {
      var mapPrice = json['cr'].entries.map((e) => e.value).toList();
      cr = double.tryParse(mapPrice[0]);
    } else {
      cr = double.tryParse(json['cr'].toString());
    }
    if (json['cr'] is Map) {
      var mapPrice = json['cr'].entries.map((e) => e.value).toList();
      cr = double.tryParse(mapPrice[0]);
    } else {
      cr = double.tryParse(json['cr'].toString());
    }
    if (json['balance'] is Map) {
      var mapPrice = json['balance'].entries.map((e) => e.value).toList();
      balance = double.tryParse(mapPrice[0]);
    } else {
      balance = double.tryParse(json['balance'].toString());
    }
  }
}
