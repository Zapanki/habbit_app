import 'package:flutter/material.dart';

class AchievmentView extends StatelessWidget {
  const AchievmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        title: const Text("Achievment", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]);
  }
}
