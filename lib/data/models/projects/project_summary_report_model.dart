import 'dart:convert';

class ProjectSummaryReportModel {
  String? projectId;
  String? projectName;
  String? address;
  String? city;
  String? province;
  String? logoPicture;

  double? totalBulkPlotsPurchased;
  double? totalPlotsPurchased;

  double? totalSelfPurchases;

  double? totalPlotsSold;
  double? totalPlotsInvestorInventory;
  double? totalPlotsInvestorSold;

  String? reportDate;

  double get plotAvailable =>
      ((totalPlotsPurchased ?? 0.0) +
          (totalBulkPlotsPurchased ?? 0.0) +
          (totalSelfPurchases ?? 0.0)) -
      (totalPlotsSold ?? 0.0);

  ProjectSummaryReportModel({
    this.projectId,
    this.projectName,
    this.address,
    this.city,
    this.province,
    this.logoPicture,
    this.totalPlotsSold,
    this.totalBulkPlotsPurchased,
    this.totalPlotsPurchased,
    this.totalSelfPurchases,
    this.totalPlotsInvestorInventory,
    this.totalPlotsInvestorSold,
    this.reportDate,
  });

  ProjectSummaryReportModel.fromJson(Map<String, dynamic> json) {
    reportDate = json['reportDate'];
    projectId = json['_id'];
    projectName = json['projectName'];
    address = json['address'];
    city = json['city'];
    province = json['province'];
    logoPicture = json['logoPicture'];
    if (json['totalPlotsSold'] != null) {
      if (json['totalPlotsSold'] is Map) {
        var mapplotMarla =
            json['totalPlotsSold'].entries.map((e) => e.value).toList();
        totalPlotsSold = double.tryParse(mapplotMarla[0]);
      } else {
        totalPlotsSold = double.tryParse(json['totalPlotsSold'].toString());
      }
    }

    if (json['totalBulkPlotsPurchased'] != null) {
      if (json['totalBulkPlotsPurchased'] is Map) {
        var mapplotMarla = json['totalBulkPlotsPurchased']
            .entries
            .map((e) => e.value)
            .toList();
        totalBulkPlotsPurchased = double.tryParse(mapplotMarla[0]);
      } else {
        totalBulkPlotsPurchased =
            double.tryParse(json['totalBulkPlotsPurchased'].toString());
      }
    }

    if (json['totalSelfPurchases'] != null) {
      if (json['totalSelfPurchases'] is Map) {
        var mapSelfPurchases =
            json['totalSelfPurchases'].entries.map((e) => e.value).toList();
        totalSelfPurchases = double.tryParse(mapSelfPurchases[0]);
      } else {
        totalSelfPurchases =
            double.tryParse(json['totalSelfPurchases'].toString());
      }
    }

    if (json['totalPlotsPurchased'] != null) {
      if (json['totalPlotsPurchased'] is Map) {
        var mapplotMarla =
            json['totalPlotsPurchased'].entries.map((e) => e.value).toList();
        totalPlotsPurchased = double.tryParse(mapplotMarla[0]);
      } else {
        totalPlotsPurchased =
            double.tryParse(json['totalPlotsPurchased'].toString());
      }
    }

    if (json['totalPlotsInvestorInventory'] != null) {
      if (json['totalPlotsInvestorInventory'] is Map) {
        var mapplotMarla = json['totalPlotsInvestorInventory']
            .entries
            .map((e) => e.value)
            .toList();
        totalPlotsInvestorInventory = double.tryParse(mapplotMarla[0]);
      } else {
        totalPlotsInvestorInventory =
            double.tryParse(json['totalPlotsInvestorInventory'].toString());
      }
    }

    if (json['totalPlotsInvestorSold'] != null) {
      if (json['totalPlotsInvestorSold'] is Map) {
        var mapPlotInvestorSold =
            json['totalPlotsInvestorSold'].entries.map((e) => e.value).toList();
        totalPlotsInvestorSold = double.tryParse(mapPlotInvestorSold[0]);
      } else {
        totalPlotsInvestorSold =
            double.tryParse(json['totalPlotsInvestorSold'].toString());
      }
    }
  }
}
