import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habbit_app/first_steps/welcome.dart';

import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Contact Us",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Loading...",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                } else {
                  String? userName = snapshot.data;
                  return Text(
                    "Hello, $userName" ?? "Guest",
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              "If you have any questions or need support, feel free to contact us:",
              style: TextStyle(
                color: TColor.gray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      const ClipboardData(text: "support@habbitapp.com"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Email was successfully copied to clipboard!')),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: TColor.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Email: support@habbitapp.com",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      const ClipboardData(text: "support@habbitapp.com"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Email was successfully copied to clipboard!')),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: TColor.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Phone: +1 234 567 890",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(
                      text: "123 Main Street, Your City, Your Country"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Address was successfully copied to clipboard!')),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: TColor.black,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Address: 123 Main Street, Your City, Your Country",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: media.width,
              child: RoundButton(
                title: "Send Message",
                onPressed: () {
                  // Add functionality to send a message or navigate to a chat screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Message was successfully sended!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
