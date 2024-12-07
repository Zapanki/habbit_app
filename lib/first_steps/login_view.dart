import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habbit_app/home_screens/home_screen.dart';
import 'package:habbit_app/show_dialog.dart';
import 'package:habbit_app/started_screens/things/colo_extension.dart';
import 'package:habbit_app/started_screens/things/round_button.dart';
import 'package:habbit_app/started_screens/things/round_textfield.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEmailInvalid = false;
  bool _isPasswordInvalid = false;
  String _emailError = '';
  String _passwordError = '';
  bool _isPasswordVisible = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isEmailInvalid = false;
      _isPasswordInvalid = false;
      _emailError = '';
      _passwordError = '';
    });

    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      setState(() {
        _isEmailInvalid = true;
        _emailError = "Email is required with @";
      });
      return;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 8) {
      setState(() {
        _isPasswordInvalid = true;
        _passwordError =
            "Password is required and must be at least 8 characters";
      });
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Проверка существования пользователя
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      if (!userDoc.exists) {
        showMyDialog("User data not found. Please register.", context);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      showMyDialog("Failed to login: $e", context);
    }
  }

  Future<void> _loginWithFacebook(BuildContext context) async {
    try {
      // Выполнение входа через Facebook
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
          loginResult.accessToken?.tokenString ?? '',
        );

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Проверка наличия пользователя в Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Если пользователь существует, продолжаем вход
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Если пользователь не найден, показываем ошибку
          showMyDialog("No user data found. Please register before logging in.",
              context);
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        showMyDialog("Facebook Login was canceled by the user.", context);
      } else {
        showMyDialog(
            "Facebook Login failed: ${loginResult.message ?? 'Unknown error'}",
            context);
      }
    } catch (e) {
      showMyDialog("Failed to login with Facebook: $e", context);
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

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
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      showMyDialog("Failed to login with Google: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Hey there,",
                  style: TextStyle(color: TColor.gray, fontSize: 16),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  isInvalid: _isEmailInvalid,
                  errorMessage: _emailError,
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                RoundTextField(
                  controller: _passwordController,
                  hitText: "Password",
                  icon: Icons.lock,
                  obscureText: !_isPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  isInvalid: _isPasswordInvalid,
                  errorMessage: _passwordError,
                ),
                const Spacer(),
                RoundButton(
                  title: "Login",
                  onPressed: () {
                    _login(context);
                  },
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _loginWithGoogle(context);
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
                            _loginWithGoogle(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: media.width * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        _loginWithFacebook(context);
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
                              _loginWithFacebook(context);
                            },
                          )),
                    )
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don’t have an account yet? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Register",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
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
