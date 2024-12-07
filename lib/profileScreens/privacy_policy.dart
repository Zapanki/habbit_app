import 'package:flutter/material.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Our Privacy Policy",
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your privacy is critically important to us. Below, we explain what information we collect, how we use it, and your rights regarding your data.",
              style: TextStyle(
                color: TColor.gray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            _buildPolicySection(
              title: "Information We Collect",
              content:
                  "We collect personal data such as your name, email address, and usage statistics to improve our services. We ensure that all data is securely stored and used in compliance with applicable laws.",
            ),
            const SizedBox(height: 15),
            _buildPolicySection(
              title: "How We Use Your Information",
              content:
                  "Your information is used to personalize your experience, provide support, and improve the app. We do not share your data with third parties without your explicit consent.",
            ),
            const SizedBox(height: 15),
            _buildPolicySection(
              title: "Your Rights",
              content:
                  "You have the right to access, update, or delete your personal information. If you wish to exercise these rights, please contact us through the app.",
            ),
            const SizedBox(height: 15),
            _buildPolicySection(
              title: "Contact Us",
              content:
                  "If you have any questions about this privacy policy, please reach out to us via support@habbitapp.com.",
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Thank you for trusting us with your information.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: TColor.gray,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
