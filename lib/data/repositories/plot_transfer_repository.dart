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

      if (response != null) {
        var listData =
            (response['data'] as List)
                .map((account) => PlotTransferModel.fromJson(account))
                .toList();

        plotTransfers.assignAll(listData);

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

      var response = await _networkHandler.post(
        "/plot_info/plot_transfer/save_plot_transfer",
        plotTransferModel.toJson(),
      );

      //Convert raw data to model
      if (response['data'] != null) {
        return PlotTransferModel.fromJson(response['data']);
      }
      return voucher;
    } catch (ex) {
      rethrow;
    }
  }
}
