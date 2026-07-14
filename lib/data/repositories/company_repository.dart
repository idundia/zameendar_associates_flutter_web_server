//import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/core/network_handler.dart';
import 'package:zameendar_web_app/data/models/company_model.dart';

class CompanyRepository {
  final _networkHandler = NetworkHandler();
  Future<CompanyModel> createCompany(CompanyModel companyModel) async {
    try {
      var response = await _networkHandler.post(
        "/company/createCompany",
        companyModel.toJson(),
      );
      return CompanyModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }

  Future<CompanyModel> updateCompany(CompanyModel companyModel) async {
    try {
      var response = await _networkHandler.put(
        "/company/${companyModel.sId}",
        companyModel.toJson(),
      );
      return CompanyModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }

  Future<RxList<CompanyModel>> getCompanyInfos(String url) async {
    late RxList<CompanyModel> companyInfos = RxList<CompanyModel>([]);
    try {
      var response = await _networkHandler.get(url);

      if (response['data'].length > 0) {
        var listData =
            (response['data'] as List)
                .map((account) => CompanyModel.fromJson(account))
                .toList();
        for (var customer in listData) {
          companyInfos.value.add(customer);
        }
        return companyInfos;
      } else {
        return RxList<CompanyModel>([]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
