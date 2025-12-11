class PlotInfoModel {
  //String? sId;
  //Map<String, dynamic>? sId;
  dynamic sId;
  dynamic projectInfoId;
  String? plotNo;
  String? block;
  String? street;
  String? plotSize; //5 Marla, 7 marla
  double? plotMarla; //5, 7 ,10 , 20

  double? costPerMarla;
  double? purchaseCost;
  String? barcode;
  String? qrCodeDataUrl;
  String? plotType; //residentional, commercial, constracted, non-constracted
  String? get plotFullName => 'Plot No: $plotNo Block: $block Street: $street';
  double? get plotTotalPrice_with_purchaseCost =>
      (plotMarla! * costPerMarla!) + purchaseCost!;

  double? get plotTotalPrice => (plotMarla! * costPerMarla!);
  String? createdOn;
  String? updateOn;

  PlotInfoModel(
      {this.sId,
      this.projectInfoId,
      this.plotNo,
      this.block,
      this.street,
      this.plotSize,
      this.plotMarla,
      this.costPerMarla,
      this.purchaseCost,
      this.plotType,
      this.createdOn,
      this.updateOn});

  PlotInfoModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['projectInfoId'] is Map) {
      projectInfoId = json['projectInfoId'];
    } else {
      projectInfoId = json['projectInfoId'].toString();
    }
    plotNo = json['plotNo'];
    block = json['block'];
    street = json['street'];
    plotSize = json['plotSize'];

    if (json['plotMarla'] is Map) {
      var mapplotMarla = json['plotMarla'].entries.map((e) => e.value).toList();
      plotMarla = double.tryParse(mapplotMarla[0]);
    } else {
      plotMarla = double.tryParse(json['plotMarla'].toString());
    }

    if (json['costPerMarla'] is Map) {
      var mapCostPerMarla =
          json['costPerMarla'].entries.map((e) => e.value).toList();
      costPerMarla = double.tryParse(mapCostPerMarla[0]);
    } else {
      costPerMarla = double.tryParse(json['costPerMarla'].toString());
    }
    if (json['purchaseCost'] is Map) {
      var mapPurchaseCost =
          json['purchaseCost'].entries.map((e) => e.value).toList();
      purchaseCost = double.tryParse(mapPurchaseCost[0]);
    } else {
      purchaseCost = double.tryParse(json['purchaseCost'].toString());
    }
    plotType = json['plotType'];
    createdOn = json['createdOn'];
    updateOn = json['updateOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['projectInfoId'] = projectInfoId;
    data['plotNo'] = plotNo;
    data['block'] = block;
    data['street'] = street;
    data['plotSize'] = plotSize;
    data['plotMarla'] = plotMarla;
    data['costPerMarla'] = double.tryParse(costPerMarla.toString());
    data['purchaseCost'] = double.tryParse(purchaseCost.toString());
    data['plotType'] = plotType;
    data['createdOn'] = createdOn;
    data['updateOn'] = updateOn;
    return data;
  }
}
