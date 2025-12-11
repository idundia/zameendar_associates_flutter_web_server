//import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkHandler {
  //final HttpClient _httpClient = HttpClient();
  //
  //
  /* NetworkHandler(){
    
  } */

  //Response response;
  Future<dynamic> get(String url) async {
    try {
      var response = await http.get(formater(url));
      //log.i(response.body);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        //print(responseBody['data']);
        if (responseBody['message'] == "List is Empty") {
          return [];
        } /* else if (responseBody['data'] is List<dynamic>) {
        return (responseBody as List<dynamic>);
      } */
        /* else if (responseBody['data'] is List) {
        return (responseBody as List);
      } else if (responseBody['data'] is String) {
        return responseBody;
      } */
        return responseBody;
        //return jsonDecode(response.body);
      }

      //HttpClient get sendRequest =>_httpClient;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postMultipart(
    String url,
    Map<String, dynamic> body, {
    File? imageFile,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);

      // Add text fields from the body map
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add the image file if it exists
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture', // This field name must match your backend's expectation
            imageFile.path,
          ),
        );
      }

      // Send the request
      var response = await request.send();

      // Read the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        return json.decode(respStr);
      } else {
        final respStr = await response.stream.bytesToString();
        debugPrint(
          'Failed to upload. Status: ${response.statusCode}, Body: $respStr',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error during multipart upload: $e');
      return null;
    }
  }

  Future<dynamic> postImage(
    String url,
    Map<String, dynamic> body, {
    File? imageFile,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    Uri uri = formater(url);
    Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    //print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final headers = {'Content-Type': 'application/json'};
    Uri uri = formater(url);
    Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    //print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  }

  Future<Map<String, dynamic>?> postList(String url, dynamic data) async {
    print("Sending POST request to: $url");
    //print("Data being sent: ${jsonEncode(data)}");

    final headers = {'Content-Type': 'application/json'};
    Uri uri = formater(url);
    Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );
    //print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    final headers = {'Content-Type': 'application/json'};
    Uri uri = formater(url);
    var response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
  }

  Future<dynamic> delete(String url, Map<String, dynamic> body) async {
    final headers = {'Content-Type': 'application/json'};
    Uri uri = formater(url);
    var response = await http.delete(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
  }

  Uri formater(String url) {
    //API_URL
    //String baseUrl = dotenv.env['API_URL'].toString();
    String baseUrl = 'http://72.62.21.165:4000/api';
    return Uri.parse(baseUrl + url);
  }
}

class ApiResponse {
  bool success;
  dynamic data;
  String? message;

  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromResponse(Response response) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    //final data = response.data as dynamic;
    return ApiResponse(
      success: data["success"] as bool,
      data: data["data"] as dynamic,
      message: data["message"] ?? "Unexpected error.",
    );
    //message: data["message"]);
  }
}
