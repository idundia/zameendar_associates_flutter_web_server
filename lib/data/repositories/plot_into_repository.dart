//import 'dart:convert';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zameendar_web_app/data/models/plot_model.dart';
import '../../core/network_handler.dart';

class PlotInfoRepository {
  //final _api = Api();
  final _networkHandler = NetworkHandler();
  var file;

  Future<List<PlotInfoModel>> fetchAllPlotInfos() async {
    try {
      //Response response = await _api.sendRequest.get("/product");
      var response = await _networkHandler.get("/plot_info/all_plots");
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
      //Response response = await _api.sendRequest.get("/product");

      var response = await _networkHandler.get("/plot_info/plot_info/$plotId");
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

  Future<List<PlotInfoModel>> fetchAllPlotByProjectId(
    String? projectInfoId,
  ) async {
    try {
      //Response response = await _api.sendRequest.get("/product");
      var response = await _networkHandler.get(
        "/plot_info/by_projectId/${projectInfoId!}",
      );
      //var responseBody = json.decode(response.body);
      /* if (responseBody is List<dynamic>){
        for(var product in responseBody){
          
        }
      } */

      /* ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //Convert raw data to model
       var resData = apiResponse.data;*/
      //var responseData = jsonDecode(response.body);
      //if (responseData is List<dynamic>) {
      if (response['data'].length > 0) {
        return (response['data'] as List)
            .map(
              (json) => PlotInfoModel.fromJson((json as Map<String, dynamic>)),
            )
            .toList();
      } else {
        return [];
      }
      /* if (response is List<dynamic>) {
        return (response as List<dynamic>)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        return [];
      } */
    } catch (ex) {
      rethrow;
    }
  }

  void _uploadFileState() async {
    file = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(file);
  }

  /*   void _uploadFile() async {
    //XFile file;

    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split('/').last;
    await _api.sendRequest.post(
        "https://fb8f-119-159-146-144.ngrok-free.app/photos",
        data: {"image": base64Image, "name": fileName}).then((res) {
      print(res);
    }).catchError((err) {
      print(err);
    });
  } */

  Future<PlotInfoModel> addPlotInfo(PlotInfoModel plotInModel) async {
    try {
      //String base64Image = base64Encode(productModel!.images[0]);

      /* Response response = await _api.sendRequest
          .post("/product", data: jsonEncode({"data": productModel})); */
      //io.File file = io.File(productModel.image.toString());

      //String basename = file.path.split('/').last;

      /* FormData formData = FormData.fromMap({
        "category": productModel.category,
        "title": productModel.title,
        "description": productModel.description,
        "price": productModel.price,
        "image": await MultipartFile.fromFile(file.path, filename: basename)
      }); */

      /* Response response = await _api.sendRequest
          .post("/product", data: jsonEncode(productModel)); */
      /* Response response =
          await _api.sendRequest.post("/product", data: formData); */

      //var postUri = Uri.parse('${dotenv.env['API_URL'].toString()}/product');
      var postUri = Uri.parse('/plot_info');

      /* var request = http.MultipartRequest('POST', postUri);
      request.fields['category'] = productModel.category!;
      request.fields['title'] = productModel.title!;
      request.fields['description'] = productModel.description!;
      request.fields['sizeType'] = productModel.sizeType!;
      request.fields['price'] = productModel.price.toString();
      */
      /* var response =
          await _networkHandler.post(postUri.toString(), productModel.toJson()); */
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
      /*
      request.files.add(await MultipartFile.fromPath('image', file.path,
          contentType: MediaType('application', 'x-tar')));
*/
      /* request.send().then((response){
        if (response.statusCode==200) {
          print('upload');
          
        }
      }); */
      //var streamedResponse = await request.send();
      //var response = await http.Response.fromStream(streamedResponse);
      // response.body as ProductModel;
      /*
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //Convert raw data to model
      return (apiResponse.data);*/
      return PlotInfoModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }

  Future<PlotInfoModel> editProduct(PlotInfoModel productModel) async {
    try {
      //String base64Image = base64Encode(productModel!.images[0]);

      /* Response response = await _api.sendRequest
          .post("/product", data: jsonEncode({"data": productModel})); */
      //io.File file = io.File(productModel.image.toString());

      //String basename = file.path.split('/').last;

      /* FormData formData = FormData.fromMap({
        "category": productModel.category,
        "title": productModel.title,
        "description": productModel.description,
        "price": productModel.price,
        "image": await MultipartFile.fromFile(file.path, filename: basename)
      }); */

      /* Response response = await _api.sendRequest
          .post("/product", data: jsonEncode(productModel)); */
      /* Response response =
          await _api.sendRequest.post("/product", data: formData); */

      //var postUri = Uri.parse('${dotenv.env['API_URL'].toString()}/product');
      var postUri = Uri.parse('/product/${productModel.sId}');

      /* var request = http.MultipartRequest('POST', postUri);
      request.fields['category'] = productModel.category!;
      request.fields['title'] = productModel.title!;
      request.fields['description'] = productModel.description!;
      request.fields['sizeType'] = productModel.sizeType!;
      request.fields['price'] = productModel.price.toString();
      */
      var response = await _networkHandler.put(
        postUri.toString(),
        productModel.toJson(),
      );
      /*
      request.files.add(await MultipartFile.fromPath('image', file.path,
          contentType: MediaType('application', 'x-tar')));
*/
      /* request.send().then((response){
        if (response.statusCode==200) {
          print('upload');
          
        }
      }); */
      //var streamedResponse = await request.send();
      //var response = await http.Response.fromStream(streamedResponse);
      // response.body as ProductModel;
      /*
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      //Convert raw data to model
      return (apiResponse.data);*/
      return PlotInfoModel.fromJson(response['data']);
    } catch (ex) {
      rethrow;
    }
  }
}
