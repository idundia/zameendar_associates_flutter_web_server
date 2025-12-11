import 'package:get/get.dart';
import 'package:zameendar_web_app/core/network_handler.dart';
import 'package:zameendar_web_app/data/models/plot_transfer_model.dart';

class PlotTransferRepository {
  final NetworkHandler _networkHandler = NetworkHandler();

  Future<RxList<PlotTransferModel>> getPlotTransfers(String url) async {
    late RxList<PlotTransferModel> plotTransfers = RxList<PlotTransferModel>(
      [],
    );
    try {
      var response = await _networkHandler.get(url);

      //if (response != null && response['data'].length > 0) {
      if (response != null) {
        var listData =
            (response['data'] as List)
                .map((account) => PlotTransferModel.fromJson(account))
                .toList();
        /*
        for (var customer in listData) {
          expenseVoucherDetails.value.add(customer);
        }
        */
        plotTransfers.assignAll(listData);
        //print(listData);
        return plotTransfers;
      } else {
        return RxList<PlotTransferModel>([]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlotTransferModel> savePlotTransfer(
    PlotTransferModel plotTransferModel,
  ) async {
    try {
      PlotTransferModel voucher = PlotTransferModel();
      /* Response response = await _api.sendRequest
          .post("/order", data: jsonEncode(orderModel.toJson())); */
      var response = await _networkHandler.post(
        "/plot_info/plot_transfer/save_plot_transfer",
        plotTransferModel.toJson(),
      );
      /* ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      } */
      //Convert raw data to model
      //return OrderModel.fromJson(apiResponse.data);
      if (response['data'] != null) {
        return PlotTransferModel.fromJson(response['data']);
      }
      return voucher;
    } catch (ex) {
      rethrow;
    }
  }
}
