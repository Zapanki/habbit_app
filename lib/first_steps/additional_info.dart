import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/first_steps/your_goal.dart';
import 'package:habbit_app/show_dialog.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';
import 'package:habbit_app/started_screens/things/round_dropdown_field.dart';
import 'package:habbit_app/started_screens/things/round_textfield.dart';

class AdditionalInfo extends StatefulWidget {
  const AdditionalInfo({super.key});

  @override
  State<AdditionalInfo> createState() => _CompleteAdditionalInfoState();
}

class _CompleteAdditionalInfoState extends State<AdditionalInfo> {
  TextEditingController txtDate = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String gender = 'Male';
  DateTime selectedDate = DateTime.now();
  String? weight = '';
  String height = '';
  String? yourPlan = 'To lose weight';

  void _submitAdditionalInfo() async {
    if (weight!.isEmpty || height.isEmpty) {
      showMyDialog("Please fill in all the fields", context);
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        showMyDialog("User not logged in", context);
        return;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'gender': gender,
        'weight': weight,
        'height': height,
        'date_of_birth': selectedDate.toIso8601String(),
        'yourPlan': yourPlan,
      });

      await showMyDialog(
        'You have successfully completed your profile',
        context,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WhatYourGoalView()),
      );
    } catch (e) {
      showMyDialog('Unexpected error: ${e.toString()}', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/Mask Group.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(color: TColor.gray, fontSize: 12),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: TColor.lightGray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Icon(
                                  Icons.person,
                                  color: TColor.gray,
                                )),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: gender,
                                decoration:
                                    const InputDecoration(labelText: 'Gender'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gender = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female',
                                  'Other'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.04,
                      ),
                      RoundTextField(
                        controller: txtDate,
                        hitText: "Date of Birth",
                        icon: Icons.calendar_month,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedDate = pickedDate;
                              txtDate.text =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                      ),
                      SizedBox(height: media.width * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: RoundDropdown<int>(
                              value: int.tryParse(weight!),
                              items:
                                  List<int>.generate(300, (index) => index + 1)
                                      .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  weight = newValue.toString();
                                });
                              },
                              hintText: "Your Weight",
                              icon: Icons.line_weight_outlined,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: media.width * 0.04),
                      Row(
                        children: [
                          Expanded(
                            child: RoundDropdown<int>(
                              value: int.tryParse(height),
                              items:
                                  List<int>.generate(221, (index) => index + 30)
                                      .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  height = newValue.toString();
                                });
                              },
                              hintText: "Your Height",
                              icon: Icons.height,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient:
                                  LinearGradient(colors: TColor.secondaryG),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: yourPlan,
                              decoration:
                                  const InputDecoration(labelText: 'Your Plan'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  yourPlan = newValue!;
                                });
                              },
                              items: <String>[
                                'To lose weight',
                                'To gain weight',
                                'Maintain weight',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.07,
                      ),
                      RoundButton(
                        title: "Next >",
                        onPressed: () {
                          // Проверяем, заполнены ли данные
                          if (gender.isNotEmpty &&
                              weight!.isNotEmpty &&
                              height.isNotEmpty) {
                            _submitAdditionalInfo(); // Сохраняем данные в Firestore
                          } else {
                            showMyDialog(
                                "Please fill in all the fields", context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> _showNumberInputDialog({
  required BuildContext context,
  required String title,
}) async {
  String input = '';
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            input = value;
          },
          decoration: const InputDecoration(hintText: "Enter value"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(input),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
