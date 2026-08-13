import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkHandler {
  Future<dynamic> get(String url) async {
    try {
      // Use formater() to standardize URL construction
      Uri uri = formater(url);
      print('GET URI: $uri');

      var response = await http.get(uri);
      print('STATUS: ${response.statusCode}');
      print('RAW BODY: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody is Map && responseBody['message'] == "List is Empty") {
          return [];
        }
        return responseBody;
      } else {
        throw Exception('GET $url failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('NetworkHandler.get error: $e');
      rethrow;
    }
  }

  Future<dynamic> postMultipart(
    String url,
    Map<String, dynamic> body, {
    File? profilePictureFile,
    File? profileSignatureFile,
    File? profileBiometricFile,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      var request = http.MultipartRequest('POST', uri);

      // Add text fields from the body map
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add the image file if it exists
      if (profilePictureFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            profilePictureFile.path,
          ),
        );
      }

      if (profileSignatureFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileSignature',
            profileSignatureFile.path,
          ),
        );
      }

      if (profileBiometricFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileBiometric',
            profileBiometricFile.path,
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
    String baseUrl = dotenv.env['API_URL'] ?? '';

    if (!baseUrl.endsWith('/') && !url.startsWith('/')) {
      baseUrl = '$baseUrl/';
    }
    if (baseUrl.endsWith('/') && url.startsWith('/')) {
      url = url.substring(1);
    }

    return Uri.parse(baseUrl + url);
  }
  /*
  Uri formater(String url) {
    String baseUrl = dotenv.env['API_URL'] ?? '';

    // Ensure baseUrl ends with a slash if the url doesn't start with one
    if (!baseUrl.endsWith('/') && !url.startsWith('/')) {
      baseUrl = '$baseUrl/';
    }

    // If baseUrl already ends with a slash AND url starts with one, remove the duplicate
    if (baseUrl.endsWith('/') && url.startsWith('/')) {
      url = url.substring(1);
    }

    return Uri.parse(baseUrl + url);
  }*/

  /*
  Uri formater(String url) {
    String baseUrl = dotenv.env['API_URL'] ?? '';
    return Uri.parse(baseUrl + url);
  }*/
}

class ApiResponse {
  bool success;
  dynamic data;
  String? message;

  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromResponse(Response response) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ApiResponse(
      success: data["success"] as bool,
      data: data["data"] as dynamic,
      message: data["message"] ?? "Unexpected error.",
    );
  }
}
