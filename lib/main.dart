// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habbit_app/first_steps/started_view.dart';
import 'package:habbit_app/home_screens/home_screen.dart';
import 'package:habbit_app/mealPlanner/meal_planner_view.dart';
import 'package:habbit_app/photo_progress/photo_progress_view.dart';
import 'package:habbit_app/profileScreens/profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';

void main() async {
  // AwesomeNotifications().initialize(
  //     null,
  //     [
  //       NotificationChannel(
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           defaultColor: Colors.teal,
  //           importance: NotificationImportance.High,
  //           enableLights: true,
  //           enableVibration: true,
  //           playSound: true)
  //     ],
  //     debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: AuthService().handleAuthState(),
    );
  }
}

class AuthService {
  Widget handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const MainScreen(); // Перенаправляем на главный экран с навигацией
          } else {
            return const StartedView();
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  // void initState() {
  //   AwesomeNotifications().isNotificationAllowed().then(
  //     (isAllowed) {
  //       if (!isAllowed) {
  //         AwesomeNotifications().requestPermissionToSendNotifications();
  //       }
  //     },
  //   );
  //   super.initState();
  // }

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MealPlannerView(),
    const PhotoProgressView(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.blue,
            color: Colors.grey,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.local_activity,
                text: 'Workout',
              ),
              GButton(
                icon: Icons.photo_library,
                text: 'Progress',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
