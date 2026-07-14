import 'dart:async';
import 'package:zameendar_web_app/data/models/plot_model.dart';
import '../../core/network_handler.dart';

class PlotInfoRepository {
  final _networkHandler = NetworkHandler();
  var file;

  Future<List<PlotInfoModel>> fetchAllPlotInfos() async {
    try {
      //Response response = await _api.sendRequest.get("/product");
      var response = await _networkHandler.get("/api/plot_info/all_plots");
      if (response == null) {
        return [];
      }
      if (response['data'].length > 0) {
        return (response['data'] as List)
            .map(
              (json) => PlotInfoModel.fromJson((json as Map<String, dynamic>)),
            )
            .toList();
      } else {
        return [];
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<PlotInfoModel> getPlotById(String plotId) async {
    try {
      // Ensure you match the route prefix your backend router listens to
      var response = await _networkHandler.get(
        "/api/plot_info/plot_info/$plotId",
      );

      if (response == null || response['data'] == null) {
        return PlotInfoModel();
      }
      if (response['data'] is Map<String, dynamic>) {
        return PlotInfoModel.fromJson(response['data'] as Map<String, dynamic>);
      }
      return PlotInfoModel();
    } catch (ex) {
      print("Repository catch block triggered: $ex");
      return PlotInfoModel();
    }
  }

  /*
  Future<PlotInfoModel> getPlotById(String plotId) async {
    try {
      var response = await _networkHandler.get("/api/plot_info/$plotId");
      if (response == null) {
        return PlotInfoModel();
      }
      if (response['data'].length > 0) {
        return PlotInfoModel.fromJson(
          (response['data'] as Map<String, dynamic>),
        );
      } else {
        return PlotInfoModel();
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
*/
  Future<List<PlotInfoModel>> fetchAllPlotByProjectId(
    String? projectInfoId,
  ) async {
    try {
      var response = await _networkHandler.get(
        "/api/plot_info/by_projectId/${projectInfoId!}",
      );

      if (response['data'].length > 0) {
        return (response['data'] as List)
            .map(
              (json) => PlotInfoModel.fromJson((json as Map<String, dynamic>)),
            )
            .toList();
      } else {
        return [];
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<PlotInfoModel> addPlotInfo(PlotInfoModel plotInModel) async {
    try {
      var postUri = Uri.parse('/api/plot_info');

      var response = await _networkHandler.post(postUri.toString(), {
        "projectInfoId": plotInModel.projectInfoId,
        "plotNo": plotInModel.plotNo,
        "block": plotInModel.block,
        "street": plotInModel.street,
        "plotSize": plotInModel.plotSize,
        "plotMarla": plotInModel.plotMarla,
        "costPerMarla": plotInModel.costPerMarla,
        "purchaseCost": plotInModel.purchaseCost,
      });

      return PlotInfoModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }

  Future<PlotInfoModel> editProduct(PlotInfoModel productModel) async {
    try {
      var postUri = Uri.parse('/api/product/${productModel.sId}');

      var response = await _networkHandler.put(
        postUri.toString(),
        productModel.toJson(),
      );

      return PlotInfoModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }
}
