import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:zameendar_web_app/core/network_handler.dart';
import 'package:zameendar_web_app/data/models/company_model.dart';
import 'package:zameendar_web_app/data/models/projects/project_info_model.dart';

class ProjectInfoRepository {
  static const String _baseUrl =
      'https://zameendarassociates.com/api'; // Example base URL
  final _networkHandler = NetworkHandler();
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final response = await _networkHandler.get('/companies');
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => CompanyModel.fromJson(item)).toList();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load companies: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return [];
    }
  }

  Future<List<ProjectInfoModel>> getAllProjects() async {
    try {
      final response = await _networkHandler.get('/projects/project_infos');
      if (response['data'].length > 0) {
        return (response['data'] as List<dynamic>)
            .map((json) => ProjectInfoModel.fromJson(json))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load projects');
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return [];
    }
  }

  Future<List<ProjectInfoModel>> getProjectByVendor(
    String vendorSubsidaryId,
  ) async {
    try {
      final response = await _networkHandler.get(
        '/projects/project_infos/vendors/$vendorSubsidaryId',
      );
      if (response['data'].length > 0) {
        return (response['data'] as List<dynamic>)
            .map((json) => ProjectInfoModel.fromJson(json))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load projects');
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return [];
    }
  }

  Future<dynamic> postMultipart(
    String url,
    Map<String, dynamic> body, {
    File? imageFile,
    String method = 'POST',
  }) async {
    try {
      //await dotenv.load(fileName: ".env");

      //String baseUrl = dotenv.env['API_URL'].toString();
      String baseUrl = 'https://zameendarassociates.com/api';
      Uri uri = Uri.parse(baseUrl + url);
      var request = http.MultipartRequest(method, uri);

      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('logoPicture', imageFile.path),
        );
      }

      var response = await request.send();

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
    } on Exception catch (e) {
      debugPrint('Error during multipart upload: $e');
      return null;
    }
  }

  // The return type should be Future<ProjectInfoModel> since it's an async function
  Future<ProjectInfoModel> createProject(
    ProjectInfoModel project, {
    File? imageFile,
  }) async {
    try {
      var responseData = await postMultipart(
        "/projects/createProject",
        project.toJson(),
        imageFile: imageFile,
      );

      // 2. Check if the responseData is valid (not null, etc.)
      if (responseData != null) {
        return ProjectInfoModel.fromJson(responseData);
      } else {
        throw Exception('Project creation failed and returned null data.');
      }
    } catch (e) {
      debugPrint('Error in createProject: $e');
      return ProjectInfoModel(); // Return empty model on failure
    }
  }

  Future<ProjectInfoModel?> updateProject(
    String id,
    ProjectInfoModel project,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$_baseUrl/projects/$id',
        ), // Assuming /api/projects/:id endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode(project.toJson()),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Project updated successfully!');
        return ProjectInfoModel.fromJson(json.decode(response.body));
      } else {
        Get.snackbar('Error', 'Failed to update project: ${response.body}');
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return null;
    }
  }

  // You might also need methods to fetch a single project by ID or all projects
  Future<ProjectInfoModel?> getProjectById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/projects/$id'));
      if (response.statusCode == 200) {
        return ProjectInfoModel.fromJson(json.decode(response.body));
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch project: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to server: $e');
      return null;
    }
  }
}
