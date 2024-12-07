import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:habbit_app/first_steps/sign_up.dart';
import 'package:habbit_app/profileScreens/Achievment_view.dart';
import 'package:habbit_app/profileScreens/contact_us.dart';
import 'package:habbit_app/profileScreens/edit_profile_view.dart';
import 'package:habbit_app/profileScreens/privacy_policy.dart';
import 'package:habbit_app/settings_row.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';
import 'package:habbit_app/title_subtitle.dart';
import 'package:habbit_app/workoutTracker/workout_tracker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> _fetchUserData() async {
  try {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      }
    }
    return null;
  } catch (e) {
    debugPrint("Error fetching user data: $e");
    return null;
  }
}

Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // После выхода перенаправьте пользователя на экран входа
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const SignUpView())); // Убедитесь, что маршрут существует
  } catch (e) {
    // Обработайте ошибки выхода, если необходимо
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error signing out: $e')),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool positive = false;

  final List<Map<String, dynamic>> accountItems = [
    {
      "image": "assets/images/p_personal.png",
      "name": "Personal Data",
      "onTap": (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileView()),
        );
      },
    },
    {
      "image": "assets/images/p_achi.png",
      "name": "Achievement",
      "onTap": (BuildContext context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AchievmentView()));
        // Навигация на страницу достижений
      },
    },
    {
      "image": "assets/images/p_activity.png",
      "name": "Activity History",
      "onTap": (BuildContext context) {
        // Навигация на историю активности
      },
    },
    {
      "image": "assets/images/p_workout.png",
      "name": "Workout Progress",
      "onTap": (BuildContext context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WorkoutTrackerView()));
        // Навигация на страницу достижений
      },
    },
    // Навигация на страницу прогресса тренировок
  ];

  final List<Map<String, dynamic>> otherItems = [
    {
      "image": "assets/images/p_contact.png",
      "name": "Contact Us",
      "onTap": (BuildContext context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ContactUsView()));
      },
    },
    {
      "image": "assets/images/p_privacy.png",
      "name": "Privacy Policy",
      "onTap": (BuildContext context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen()));
      },
    },
    {
      "image": "assets/images/p_setting.png",
      "name": "Setting",
      "onTap": (BuildContext context) {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => SettingsView()));
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        actions: [
          InkWell(
            onTap: () {
              _signOut(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGray,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.logout_outlined, color: TColor.black, size: 20),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user data found"));
          }

          final userData = snapshot.data!;
          final name = userData['name'] ?? 'No Name';
          final height = userData['height']?.toString() ?? 'N/A';
          final weight = userData['weight']?.toString() ?? 'N/A';
          final dateOfBirth = userData['date_of_birth'] ?? 'N/A';
          final plan = userData['yourPlan'] ?? 'N/B';

          int age = 0;
          if (dateOfBirth != 'N/A') {
            DateTime birthDate = DateTime.parse(dateOfBirth);
            DateTime today = DateTime.now();
            age = today.year - birthDate.year;
            if (today.month < birthDate.month ||
                (today.month == birthDate.month && today.day < birthDate.day)) {
              age--;
            }
          }

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          "assets/images/u2.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              plan,
                              style: TextStyle(
                                color: TColor.gray,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: RoundButton(
                          title: "Edit",
                          type: RoundButtonType.bgGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileView(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TitleSubtitleCell(
                          title: "$height cm",
                          subtitle: "Height",
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TitleSubtitleCell(
                          title: "$weight kg",
                          subtitle: "Weight",
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TitleSubtitleCell(
                          title: age > 0 ? "$age years" : "N/A",
                          subtitle: "Age",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: accountItems.length,
                          itemBuilder: (context, index) {
                            var iObj = accountItems[index];
                            return SettingRow(
                              icon: iObj["image"].toString(),
                              title: iObj["name"].toString(),
                              onPressed: () => iObj["onTap"](context),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: TColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/p_notification.png",
                                height: 15,
                                width: 15,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  "Pop-up Notification",
                                  style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              StatefulBuilder(
                                builder: (context, setLocalState) {
                                  return CustomAnimatedToggleSwitch<bool>(
                                    current: positive,
                                    values: const [false, true],
                                    indicatorSize: const Size.square(30.0),
                                    animationDuration:
                                        const Duration(milliseconds: 200),
                                    animationCurve: Curves.linear,
                                    onChanged: (b) =>
                                        setLocalState(() => positive = b),
                                    iconBuilder: (context, local, global) {
                                      return const SizedBox();
                                    },
                                    iconsTappable: false,
                                    wrapperBuilder: (context, global, child) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            left: 10.0,
                                            right: 10.0,
                                            height: 30.0,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: positive
                                                      ? TColor.secondaryG
                                                      : [
                                                          Colors.grey[800]!,
                                                          Colors.grey[900]!
                                                        ],
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          child,
                                        ],
                                      );
                                    },
                                    foregroundIndicatorBuilder:
                                        (context, global) {
                                      return SizedBox.fromSize(
                                        size: const Size(10, 10),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: TColor.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(50.0),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black38,
                                                spreadRadius: 0.05,
                                                blurRadius: 1.1,
                                                offset: Offset(0.0, 0.8),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Other",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: otherItems.length,
                          itemBuilder: (context, index) {
                            var iObj = otherItems[index];
                            return SettingRow(
                              icon: iObj["image"].toString(),
                              title: iObj["name"].toString(),
                              onPressed: () => iObj["onTap"](context),
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
