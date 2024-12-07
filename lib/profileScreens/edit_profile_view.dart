import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/profileScreens/custom_button.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode(); // Добавлено FocusNode
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String gender = 'Male';
  DateTime selectedDate = DateTime.now();
  String weight = '';
  String height = '';
  String yourPlan = 'To lose weight';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? '';
            gender = data['gender'] ?? 'Male';
            selectedDate = DateTime.parse(
                data['date_of_birth'] ?? DateTime.now().toString());
            weight = data['weight']?.toString() ?? '';
            height = data['height']?.toString() ?? '';
            yourPlan = data['yourPlan'] ?? 'To lose weight';
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData(String field, dynamic value) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({field: value});
        debugPrint('$field updated to $value');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your data has been updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error updating $field: $e');
    }
  }

  Future<void> _showSelectionDialog({
    required String title,
    required List<String> options,
    required String currentValue,
    required void Function(String) onSelected,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: currentValue,
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                      Navigator.of(context).pop();
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/u2.png"),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("Name"),
              subtitle: TextFormField(
                focusNode: _nameFocusNode,
                controller: _nameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your name',
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            // const Divider(),
            ListTile(
              title: const Text("Gender"),
              subtitle: Text(gender),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showSelectionDialog(
                    title: 'Select Gender',
                    options: ['Male', 'Female', 'Other'],
                    currentValue: gender,
                    onSelected: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text("Date of Birth"),
              subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            ListTile(
              title: const Text("Weight"),
              subtitle: Text("$weight kg"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showSelectionDialog(
                    title: 'Select Weight',
                    options:
                        List.generate(300, (index) => (index + 1).toString()),
                    currentValue: weight,
                    onSelected: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text("Height"),
              subtitle: Text("$height cm"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showSelectionDialog(
                    title: 'Select Height',
                    options:
                        List.generate(220, (index) => (index + 30).toString()),
                    currentValue: height,
                    onSelected: (value) {
                      setState(() {
                        height = value;
                      });
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text("Training Plan"),
              subtitle: Text(yourPlan),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _showSelectionDialog(
                    title: 'Select Training Plan',
                    options: [
                      'To lose weight',
                      'To gain weight',
                      'Maintain weight',
                      'Other'
                    ],
                    currentValue: yourPlan,
                    onSelected: (value) {
                      setState(() {
                        yourPlan = value;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            BottomAppBar(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RoundButton(
                  type: RoundButtonType.bgSGradient,
                  onPressed: () async {
                    await _updateUserData('name', _nameController.text);
                    await _updateUserData('gender', gender);
                    await _updateUserData(
                        'date_of_birth', selectedDate.toIso8601String());
                    await _updateUserData('weight', weight);
                    await _updateUserData('height', height);
                    await _updateUserData('yourPlan', yourPlan);
                  },
                  title: 'Save Changes',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
