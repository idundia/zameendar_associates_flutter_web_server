import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:zameendar_web_app/core/routes.dart';
import 'package:zameendar_web_app/data/controllers/company_controller.dart';
import 'package:zameendar_web_app/data/controllers/plot_info_controller.dart';
import 'package:zameendar_web_app/data/controllers/plot_transfer_controller.dart';
import 'package:zameendar_web_app/data/controllers/project_info_controller.dart';
import 'package:zameendar_web_app/data/controllers/vendor_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  try {
    // 3. Load the environment file before running the app
    await dotenv.load(fileName: ".env");
    print("Environment variables loaded successfully.");
  } catch (e) {
    print("Failed to load .env file: $e");
  }

  // Register the controller before running the app
  Get.put(CompanyController());
  Get.put(VendorController());
  Get.put(ProjectInfoController());
  Get.put(PlotInfoController());
  Get.put(PlotTransferController());

  runApp(const ZameendarWebApp());
}

class ZameendarWebApp extends StatelessWidget {
  const ZameendarWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the title for the browser tab
      title: 'Zameendar Associates',

      // Define the primary look and feel
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ).copyWith(
          secondary: const Color(0xFF1E3A8A), // Use the custom deep blue color
        ),
        fontFamily: 'Roboto', // Use a standard web font
        useMaterial3: true,
      ),

      // Set the MainScreen as the home page
      onGenerateRoute: Routes.onGenerateRoute,

      routes: {},

      // Disable the debug banner in the corner
      debugShowCheckedModeBanner: false,
    );
  }
}
