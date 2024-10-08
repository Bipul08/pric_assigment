import 'package:flutter/material.dart';
import 'package:pric_assigment/auth/text_field_class.dart';
import 'package:pric_assigment/home_page.dart';
import '../main.dart';
import 'healper.dart'; // Make sure this import points to the correct location

class Authentation extends StatefulWidget {
  const Authentation({Key? key}) : super(key: key);

  @override
  State<Authentation> createState() => _AuthentationState();
}

class _AuthentationState extends State<Authentation> {
  bool isLogin = true; // Default mode is login
  bool isPasswordVisible = false; // Track password visibility
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  // Function to show a snack bar if validation fails
  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height, // Ensure full screen coverage
        color: Colors.grey, // Set the background color to grey
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 100), // Spacing from the top

                // Dynamic title for login or registration
                Text(
                  isLogin ? "Login" : "Registration", // Title changes based on mode
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 90),

                // Form
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85), // Semi-transparent form background
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Email Field
                        TextFieldClass(
                          key: ValueKey("email"),
                          hintText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!(value.contains("@"))) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              email = newValue;
                            });
                          },
                        ),

                        // Password Field with Toggle
                        TextFieldClass(
                          key: ValueKey("password"),
                          hintText: "Password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Please create a stronger password";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            setState(() {
                              password = newValue;
                            });
                          },

                        ),

                        SizedBox(height: 20),

                        // Login/Sign-Up Button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800, // Button color
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  // Use the AuthHelper class
                                  AuthHelper authHelper = AuthHelper();
                                  if (isLogin) {
                                    await authHelper.login(context, email!, password!);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                                  } else {
                                    await authHelper.signUp(email!, password!);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                                  }
                                } catch (e) {
                                  // Show a snackbar if there's an error during authentication
                                  _showSnackBar('Authentication failed');
                                }
                              } else {
                                // Show a snackbar if validation fails
                                _showSnackBar('Please enter valid email and password');
                              }
                            },
                            child: Text(
                              isLogin ? "Login" : "Sign-Up", // Button text changes based on mode
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // Toggle between Login and Sign-Up
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? "Don't have an account? Sign-Up"
                                : "Already signed up? Login",
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
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
