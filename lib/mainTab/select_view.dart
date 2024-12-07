import 'package:flutter/material.dart';
import 'package:habbit_app/mealPlanner/meal_planner_view.dart';
import 'package:habbit_app/sleepTracker/sleep_tracker_view.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';
import 'package:habbit_app/workoutTracker/workout_tracker.dart';


class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundButton(
                title: "Workout Tracker",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutTrackerView(),
                    ),
                  );
                }),

                const SizedBox(height: 15,),

                  RoundButton(
                title: "Meal Planner",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MealPlannerView(),
                    ),
                  );
                }),

                const SizedBox(height: 15,),

                  RoundButton(
                title: "Sleep Tracker",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SleepTrackerView(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}