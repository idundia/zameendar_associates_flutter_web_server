import 'package:flutter/foundation.dart';
import 'package:zameendar_web_app/data/models/company_model.dart';
import 'package:zameendar_web_app/data/models/customer_model.dart';
import 'package:zameendar_web_app/data/models/subsidary_model.dart';
import 'package:zameendar_web_app/data/models/user_model.dart';

class PlotTransferModel {
  UserModel? user;
  dynamic plotInfoId;
  DateTime? transferDate;
  String? referenceNo;
  dynamic companyId;
  dynamic plotSaleId;

  String? transferType;

  dynamic transferFromVendorId;
  dynamic transferFromProjectId;
  dynamic transferFromSubsidaryId;

  dynamic transferToProjectId;
  dynamic transferToSubsidaryId;
  double? transferFee;

  PlotTransferModel({
    this.user,
    this.companyId,
    this.plotInfoId,
    this.transferDate,
    this.referenceNo,
    this.plotSaleId,
    this.transferType,
    this.transferFromVendorId,
    this.transferFromProjectId,
    this.transferFromSubsidaryId,
    this.transferToProjectId,
    this.transferToSubsidaryId,
    this.transferFee,
  });

  PlotTransferModel.fromJson(Map<String, dynamic> json) {
    try {
      // User
      if (json['user'] != null) {
        user = UserModel.fromJson(json['user']);
      }

      // Reference Number
      referenceNo = json['referenceNo']?.toString();

      // Transfer Type
      transferType = json['transferType']?.toString();

      // Company ID - Handle both Map and primitive types
      if (json['companyId'] != null) {
        if (json['companyId'] is Map) {
          companyId = CompanyModel.fromJson(
            json['companyId'] as Map<String, dynamic>,
          );
        } else {
          companyId = json['companyId'].toString();
        }
      }

      // Plot Info ID - Store the whole object or just the ID string
      if (json['plotInfoId'] != null) {
        if (json['plotInfoId'] is Map) {
          // Store as Map - you can access plotInfoId['plotNo'], etc.
          plotInfoId = json['plotInfoId'];
        } else {
          // It's just an ID string
          plotInfoId = json['plotInfoId'].toString();
        }
      }

      // Plot Sale ID - Store the whole object or just the ID string
      if (json['plotSaleId'] != null) {
        if (json['plotSaleId'] is Map) {
          plotSaleId = json['plotSaleId'];
        } else {
          plotSaleId = json['plotSaleId'].toString();
        }
      }

      // Transfer Date
      if (json['transferDate'] != null) {
        transferDate =
            DateTime.tryParse(json['transferDate'].toString())?.toLocal();
      }

      // Transfer From Vendor ID
      if (json['transferFromVendorId'] != null) {
        if (json['transferFromVendorId'] is Map) {
          transferFromVendorId = json['transferFromVendorId'];
        } else {
          transferFromVendorId = json['transferFromVendorId'].toString();
        }
      }

      // Transfer From Project ID - Store the whole object or just the ID string
      if (json['transferFromProjectId'] != null) {
        if (json['transferFromProjectId'] is Map) {
          transferFromProjectId = json['transferFromProjectId'];
        } else {
          transferFromProjectId = json['transferFromProjectId'].toString();
        }
      }

      // Transfer From Subsidiary ID - Handle both Map and primitive types
      if (json['transferFromSubsidaryId'] != null) {
        if (json['transferFromSubsidaryId'] is Map<String, dynamic>) {
          transferFromSubsidaryId = SubsidaryModel.fromJson(
            json['transferFromSubsidaryId'] as Map<String, dynamic>,
          );
        } else {
          transferFromSubsidaryId = json['transferFromSubsidaryId'].toString();
        }
      }

      // Transfer To Project ID - Store the whole object or just the ID string
      if (json['transferToProjectId'] != null) {
        if (json['transferToProjectId'] is Map) {
          transferToProjectId = json['transferToProjectId'];
        } else {
          transferToProjectId = json['transferToProjectId'].toString();
        }
      }

      // Transfer To Subsidiary ID - Handle both Map and primitive types
      if (json['transferToSubsidaryId'] != null) {
        if (json['transferToSubsidaryId'] is Map<String, dynamic>) {
          transferToSubsidaryId = SubsidaryModel.fromJson(
            json['transferToSubsidaryId'] as Map<String, dynamic>,
          );
        } else {
          transferToSubsidaryId = json['transferToSubsidaryId'].toString();
        }
      }

      // Transfer Fee - Handle MongoDB Decimal128 format with multiple fallbacks
      if (json['transferFee'] != null) {
        try {
          final feeValue = json['transferFee'];

          if (feeValue is num) {
            // Direct number (int or double)
            transferFee = feeValue.toDouble();
          } else if (feeValue is String) {
            // String representation of a number
            transferFee = double.tryParse(feeValue) ?? 0.0;
          } else if (feeValue is Map) {
            // MongoDB Decimal128 format - try multiple key variations
            dynamic decimalValue;

            // Try different key formats for MongoDB Decimal128
            if (feeValue.containsKey('\$numberDecimal')) {
              decimalValue = feeValue['\$numberDecimal'];
            } else if (feeValue.containsKey('numberDecimal')) {
              decimalValue = feeValue['numberDecimal'];
            } else if (feeValue.containsKey(r'$numberDecimal')) {
              decimalValue = feeValue[r'$numberDecimal'];
            }

            if (decimalValue != null) {
              // Convert to string first, then parse
              final String decimalString = decimalValue.toString();
              transferFee = double.tryParse(decimalString) ?? 0.0;
            } else {
              debugPrint(
                ' Warning: transferFee map has unexpected structure: $feeValue',
              );
              transferFee = 0.0;
            }
          } else {
            debugPrint(
              ' Warning: transferFee has unexpected type: ${feeValue.runtimeType}',
            );
            transferFee = 0.0;
          }
        } catch (e) {
          debugPrint(
            ' Error parsing transferFee: $e, value: ${json['transferFee']}',
          );
          transferFee = 0.0;
        }
      } else {
        transferFee = 0.0;
      }
    } catch (e, stackTrace) {
      debugPrint(' ERROR in PlotTransferModel.fromJson: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user'] = user?.toJson();

    // Handle companyId
    if (companyId is CompanyModel) {
      data['companyId'] = (companyId as CompanyModel).toJson();
    } else {
      data['companyId'] = companyId;
    }

    // Handle plotInfoId - extract just the _id if it's a Map
    if (plotInfoId is Map) {
      data['plotInfoId'] = plotInfoId['_id']?.toString() ?? plotInfoId;
    } else {
      data['plotInfoId'] = plotInfoId;
    }

    // Handle plotSaleId - extract just the _id if it's a Map
    if (plotSaleId is Map) {
      data['plotSaleId'] = plotSaleId['_id']?.toString() ?? plotSaleId;
    } else {
      data['plotSaleId'] = plotSaleId;
    }

    data['referenceNo'] = referenceNo;
    data['transferDate'] = transferDate?.toUtc().toIso8601String();
    data['transferType'] = transferType;

    // Handle transferFromVendorId
    if (transferFromVendorId is Map) {
      data['transferFromVendorId'] =
          transferFromVendorId['_id']?.toString() ?? transferFromVendorId;
    } else {
      data['transferFromVendorId'] = transferFromVendorId;
    }

    // Handle transferFromProjectId
    if (transferFromProjectId is Map) {
      data['transferFromProjectId'] =
          transferFromProjectId['_id']?.toString() ?? transferFromProjectId;
    } else {
      data['transferFromProjectId'] = transferFromProjectId;
    }

    // Handle transferFromSubsidaryId
    if (transferFromSubsidaryId is SubsidaryModel) {
      data['transferFromSubsidaryId'] =
          (transferFromSubsidaryId as SubsidaryModel).toJson();
    } else if (transferFromSubsidaryId is Map) {
      data['transferFromSubsidaryId'] =
          transferFromSubsidaryId['_id']?.toString() ?? transferFromSubsidaryId;
    } else {
      data['transferFromSubsidaryId'] = transferFromSubsidaryId;
    }

    // Handle transferToProjectId
    if (transferToProjectId is Map) {
      data['transferToProjectId'] =
          transferToProjectId['_id']?.toString() ?? transferToProjectId;
    } else {
      data['transferToProjectId'] = transferToProjectId;
    }

    // Handle transferToSubsidaryId
    if (transferToSubsidaryId is SubsidaryModel) {
      data['transferToSubsidaryId'] =
          (transferToSubsidaryId as SubsidaryModel).toJson();
    } else if (transferToSubsidaryId is Map) {
      data['transferToSubsidaryId'] =
          transferToSubsidaryId['_id']?.toString() ?? transferToSubsidaryId;
    } else {
      data['transferToSubsidaryId'] = transferToSubsidaryId;
    }

    data['transferFee'] = transferFee;

    return data;
  }

  // Helper methods to safely access nested data
  String? get plotNo =>
      plotInfoId is Map ? plotInfoId['plotNo']?.toString() : null;
  String? get block =>
      plotInfoId is Map ? plotInfoId['block']?.toString() : null;
  String? get street =>
      plotInfoId is Map ? plotInfoId['street']?.toString() : null;
  String? get plotSize =>
      plotInfoId is Map ? plotInfoId['plotSize']?.toString() : null;
  String? get plotId =>
      plotInfoId is Map
          ? plotInfoId['_id']?.toString()
          : plotInfoId?.toString();

  String? get fromProjectName =>
      transferFromProjectId is Map
          ? transferFromProjectId['projectName']?.toString()
          : null;
  String? get fromProjectId =>
      transferFromProjectId is Map
          ? transferFromProjectId['_id']?.toString()
          : transferFromProjectId?.toString();

  String? get toProjectName =>
      transferToProjectId is Map
          ? transferToProjectId['projectName']?.toString()
          : null;
  String? get toProjectId =>
      transferToProjectId is Map
          ? transferToProjectId['_id']?.toString()
          : transferToProjectId?.toString();

  String? get transferFromCustomerName {
    if (transferFromSubsidaryId is SubsidaryModel) {
      return (transferFromSubsidaryId as SubsidaryModel).subsidaryName;
    } else if (transferFromSubsidaryId is Map) {
      return transferFromSubsidaryId['subsidaryName']?.toString();
    }
    return null;
  }

  String? get transferToCustomerName {
    if (transferToSubsidaryId is SubsidaryModel) {
      return (transferToSubsidaryId as SubsidaryModel).subsidaryName;
    } else if (transferToSubsidaryId is Map) {
      return transferToSubsidaryId['subsidaryName']?.toString();
    }
    return null;
  }
}
