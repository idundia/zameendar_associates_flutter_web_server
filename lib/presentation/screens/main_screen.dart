import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zameendar_web_app/data/controllers/project_info_controller.dart';
import 'package:zameendar_web_app/data/models/projects/project_info_model.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ProjectInfoController projectController =
      Get.find<ProjectInfoController>();
  void getAllProjects() async {
    await projectController.fetchProjects();
  }

  @override
  void initState() {
    super.initState();
    if (projectController.projects.isEmpty) {
      getAllProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Define max width for central content on large screens
    const double maxContentWidth = 1200.0;

    return Scaffold(
      // 2. Navigation Bar
      appBar: _buildAppBar(context),

      // 3. Scrollable Body
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              children: <Widget>[
                _buildHeroSection(context),
                const Divider(),
                _buildAboutUsSection(context),
                const Divider(),
                _buildProjectsSection(context),
                const Divider(),
                _buildContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Zameendar Associates',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red[900],
      actions: [
        _buildNavButton('HOME', '/'),
        _buildNavButton('ABOUT US', '/about'),
        _buildNavButton('PROJECTS', '/projects'),
        _buildNavButton('CONTACT', '/contact'),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildNavButton(String text, String route) {
    return TextButton(
      onPressed: () {
        // Implement navigation logic here (e.g., GoRouter or Navigator)
        if (text == 'ABOUT US') {
          Navigator.pushNamed(context, route);
        }
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // --- Section Builders ---
  Widget _buildHeroSection(BuildContext context) {
    // Set a fixed height for the hero section to maximize visual impact
    const double heroHeight = 600.0;

    return Container(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        children: [
          // 1. Background Image (Layer 1)
          // Ensure you have an image file (e.g., a GIF named 'real_estate_bg.gif')

          /*
          ColorFiltered(
            // Use a ColorFilter to darken the image, making the text clearer.
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(
                alpha: 0.55,
              ), // Dark overlay for text contrast
              BlendMode.darken,
            ),
            child: Image.asset(
              'assets/images/real_estate_bg.gif', // 💡 Change to your actual file path
              fit: BoxFit.cover,
              width: double.infinity,
              height: heroHeight,
            ),
          ),
*/
          // 2. Foreground Content (Layer 2)
          // This is your original text and button content, centered.
          Center(
            child: ConstrainedBox(
              // Constrain content width to match the rest of the page layout
              constraints: const BoxConstraints(maxWidth: 1200.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ZAMEENDAR ASSOCIATES",
                      style: TextStyle(
                        fontSize: 60, // Increased size for impact
                        fontWeight: FontWeight.w900,
                        color: Colors.white, // Changed to white for contrast
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "The Company aims to be the best customer service team in our profession. To develop and maintain first-class property dealings and consultancy services, ensuring customer satisfaction that drives customer loyalty.",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white70, // Changed to light color
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Action to scroll to the projects section
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 25,
                        ),
                        backgroundColor: const Color(0xFF1E3A8A), // Deep Blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'EXPLORE PROJECTS',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutUsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ABOUT US',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "Zameendar Associates is a young Pakistan-owned company registered as a private limited firm, matured into a successful and dependable firm with a wealth of experience on all types of construction buildings and property dealings.",
            style: TextStyle(fontSize: 18, color: Colors.grey[800]),
          ),
          const SizedBox(height: 15),
          const Text(
            "Our Core Principles:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20.0,
            runSpacing: 10.0,
            children: [
              _buildPillar('Competitive Price', Icons.monetization_on_outlined),
              _buildPillar('Safe Work', Icons.security),
              _buildPillar('Higher Quality', Icons.star_rate),
              _buildPillar('Customer Satisfaction', Icons.handshake),
            ], // Principles and goals based on the profile
          ),
        ],
      ),
    );
  }

  Widget _buildPillar(String title, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: const Color(0xFF1E3A8A)),
      label: Text(title, style: const TextStyle(fontSize: 16)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OUR PROJECTS',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 💡 Use Obx to rebuild the UI when projects list changes (i.e., when data arrives)
          Obx(() {
            if (projectController.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (projectController.projects.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text(
                    'No projects currently listed.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

            // Data is loaded, build the grid of project cards
            return Wrap(
              spacing: 40.0,
              runSpacing: 40.0,
              children:
                  projectController.projects
                      .map((project) => _buildProjectCard(project))
                      .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProjectCard(ProjectInfoModel project) {
    // Use a default icon if you are not storing the actual icon in the database
    IconData icon = Icons.apartment;

    return SizedBox(
      width: 280, // Fixed width for project cards
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Use the icon from the model if available, otherwise use a default
              Icon(
                icon, // Or map project.icon string to an IconData
                size: 60,
                color: const Color(0xFF1E3A8A),
              ),
              const SizedBox(height: 10),
              Text(
                project.projectName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                project.address ?? '',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    // Contact details from the profile PDF
    return Container(
      padding: const EdgeInsets.all(40.0),
      width: double.infinity,
      color: Colors.blueGrey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zameendar Associates',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Property Dealings & Consultancy Services',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CONTACT US',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              _buildContactInfo(
                Icons.location_on,
                'Hussain Abad Road Gulbahar Peshawar',
              ), // Address from profile
              _buildContactInfo(
                Icons.phone,
                '0310-9003868',
              ), // Contact from profile
              _buildContactInfo(
                Icons.phone,
                '03219053521',
              ), // Contact from profile
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
