import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:zameendar_web_app/core/routes.dart';
import 'package:zameendar_web_app/data/controllers/company_controller.dart';
import 'package:zameendar_web_app/data/controllers/plot_info_controller.dart';
import 'package:zameendar_web_app/data/controllers/plot_transfer_controller.dart';
import 'package:zameendar_web_app/data/controllers/project_info_controller.dart';

//import 'package:zameendar_web_app/data/controllers/vendor_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  try {
    // Ensure file name matches your actual env file (.env or env.json in key=value format)
    await dotenv.load(fileName: ".env");
    print("Environment variables loaded successfully.");
  } catch (e) {
    print("Failed to load .env file: $e");
  }

  // Run app FIRST so the widget tree and GetX context exist
  runApp(const ZameendarWebApp());
}

class ZameendarWebApp extends StatelessWidget {
  const ZameendarWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Change MaterialApp to GetMaterialApp
    return GetMaterialApp(
      title: 'Zameendar Associates',

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(secondary: const Color(0xFF1E3A8A)),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      // 2. Initialize controllers inside initialBinding AFTER GetMaterialApp is ready
      initialBinding: BindingsBuilder(() {
        Get.put(CompanyController());
        Get.put(ProjectInfoController());
        Get.put(PlotInfoController());
        Get.put(PlotTransferController());
      }),

      onGenerateRoute: Routes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
