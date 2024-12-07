import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit_app/first_steps/additional_info.dart';
import 'package:habbit_app/first_steps/login_view.dart';
import 'package:habbit_app/show_dialog.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';
import 'package:habbit_app/started_screens/things/round_textfield.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNameInvalid = false;
  bool _isEmailInvalid = false;
  bool _isPasswordInvalid = false;
  bool _isConfirmPasswordInvalid = false;
  bool isCheck = false;
  bool isPasswordVisible = false;

  String _nameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';

  Future<void> _register(BuildContext context) async {
    setState(() {
      _isNameInvalid = false;
      _isEmailInvalid = false;
      _isPasswordInvalid = false;
      _isConfirmPasswordInvalid = false;
      _nameError = '';
      _emailError = '';
      _passwordError = '';
      _confirmPasswordError = '';
    });

    if (_nameController.text.isEmpty || _nameController.text.length < 2) {
      setState(() {
        _isNameInvalid = true;
        _nameError = 'Name is required at least 2 characters';
      });
      return;
    }
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      setState(() {
        _isEmailInvalid = true;
        _emailError = 'Email is required with @';
      });
      return;
    }
    if (_passwordController.text.length < 8 ||
        _passwordController.text.isEmpty) {
      setState(() {
        _isPasswordInvalid = true;
        _passwordError = 'Password must be at least 8 characters';
      });
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _isPasswordInvalid = true;
        _isConfirmPasswordInvalid = true;
        _confirmPasswordError = 'Passwords do not match';
      });
      return;
    }

    try {
      // Регистрация пользователя в Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Сохранение данных в Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'uid': userCredential.user!.uid,
        'theme': 'light',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdditionalInfo()),
      );
    } catch (e) {
      showMyDialog('Error: $e', context);
    }
  }

  Future<void> _registerWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken?.tokenString ?? '');

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Проверка наличия пользователя в Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        if (!userDoc.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
            'theme': 'light',
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdditionalInfo()),
        );
      } else if (loginResult.status == LoginStatus.cancelled) {
        showMyDialog("Facebook Sign-In was canceled by the user.", context);
      } else {
        showMyDialog(
            "Facebook Sign-In failed: ${loginResult.message ?? 'Unknown error'}",
            context);
      }
    } catch (e) {
      showMyDialog("Failed to register with Facebook: $e", context);
    }
  }

  Future<void> _registerWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        showMyDialog("Google Sign-In was canceled by the user.", context);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Проверка наличия пользователя в Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'uid': userCredential.user!.uid,
          'theme': 'light',
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdditionalInfo()),
      );
    } catch (e) {
      debugPrint("Error during Google Sign-In: $e");
      showMyDialog("Failed to login: $e", context);
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TColor.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                RoundTextField(
                  controller: _nameController,
                  hitText: 'Name',
                  icon: Icons.person,
                  isInvalid: _isNameInvalid,
                  errorMessage: _nameError,
                ),
                const SizedBox(height: 16),
                RoundTextField(
                  controller: _emailController,
                  hitText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  isInvalid: _isEmailInvalid,
                  errorMessage: _emailError,
                ),
                const SizedBox(height: 16),
                RoundTextField(
                  controller: _passwordController,
                  hitText: 'Password',
                  icon: Icons.lock,
                  obscureText: !isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  isInvalid: _isPasswordInvalid,
                  errorMessage: _passwordError,
                ),
                const SizedBox(height: 16),
                RoundTextField(
                  controller: _confirmPasswordController,
                  hitText: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscureText: !isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  isInvalid: _isConfirmPasswordInvalid,
                  errorMessage: _confirmPasswordError,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.gray,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "By continuing you accept our Privacy Policy and\nTerm of Use",
                        style: TextStyle(color: TColor.gray, fontSize: 10),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                RoundButton(
                    title: "Register",
                    onPressed: () {
                      _register(context);
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.gray.withOpacity(0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _registerWithGoogle(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.gray.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SignInButton(
                          Buttons.google,
                          text: "",
                          onPressed: () {
                            _registerWithGoogle(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        _registerWithFacebook(context);
                      },
                      child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: TColor.white,
                            border: Border.all(
                              width: 1,
                              color: TColor.gray.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SignInButton(
                            Buttons.facebook,
                            text: "",
                            onPressed: () async {
                              _registerWithFacebook(context);
                            },
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
