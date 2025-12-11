import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/data/models/plot_model.dart';
import 'package:zameendar_web_app/data/repositories/plot_into_repository.dart';

class PlotInfoController extends GetxController {
  var plotInfos = <PlotInfoModel>[].obs;
  //var plotReport = <PlotReportModel>[].obs;
  TextEditingController productNameTextController = TextEditingController();
  final PlotInfoRepository _plotRepository = PlotInfoRepository();
  Rx<PlotInfoModel> currentPlotModel = PlotInfoModel().obs;
  get plotNameFocus => null;
  @override
  void onInit() {
    super.onInit();
    //fetchAllPlots();
    if (plotInfos.value.isEmpty) {
      fetchAllPlots();
    }
  }

  void fetchAllPlots() async {
    await fetchAllPlotInfos();
  }

  Future<void> fetchAllPlotsByProjectId(String? projectId) async {
    try {
      final allProduct = await _plotRepository.fetchAllPlotByProjectId(
        projectId,
      );
      //for (var product in allProduct) {
      plotInfos.assignAll(allProduct);
      //}
      //List<ProductModel> products = [...state.products, product];
      //SocketManager.productController.products.add(product);
      //emit(ProductLoadedState(products));
    } catch (ex) {
      //emit(ProductErrorState(ex.toString(), state.products));
    }
  }

  Future<void> fetchAllPlotInfos() async {
    try {
      final allProduct = await _plotRepository.fetchAllPlotInfos();
      plotInfos.assignAll(allProduct);
    } catch (ex) {
      //emit(ProductErrorState(ex.toString(), state.products));
    }
  }

  Future<void> fetchPlotInfoById(String plotId) async {
    try {
      // 💡 CRITICAL: Call the repository to fetch the single plot object
      final plot = await _plotRepository.getPlotById(plotId);

      if (plot != null) {
        // 💡 CRITICAL: Update the reactive variable with the single PlotInfoModel
        currentPlotModel.value = plot;
        debugPrint('PlotInfo fetched successfully for ID: $plotId');
      } else {
        // Handle case where plot is not found (API returns null/empty)
        currentPlotModel.value =
            PlotInfoModel(); // Reset or set to null/empty model
        debugPrint('Plot not found in repository for ID: $plotId');
      }
    } catch (ex) {
      // Log error if the network call or parsing fails
      debugPrint('Error fetching PlotInfo by ID $plotId: $ex');
      // Optionally rethrow or handle specific errors
    }
  }
}
