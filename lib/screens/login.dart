import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../services/validation.dart';
import 'all_channels_screen.dart';
import 'base.dart';
import 'base_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends BaseScreen<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  IValidationService get _validationService => ValidationService();

  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(child: _buildLoginForm()),
    );
  }

  Widget _buildLoginForm() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double verticalSpacingSmall = screenHeight * 0.02;
    double horizontalPadding = screenWidth * 0.05;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: verticalSpacingSmall),
          Text(
            "Login",
            style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: verticalSpacingSmall),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ElevatedButton.icon(
              onPressed: () => _showEmailPasswordLogin(),
              icon: const Icon(Icons.email, color: Colors.white),
              label: const Text("Login with Email/Password"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ElevatedButton.icon(
              onPressed: () => _showPhoneOtpLogin(),
              icon: const Icon(Icons.phone, color: Colors.white),
              label: const Text("Login with Phone/OTP"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ElevatedButton.icon(
              onPressed: () => _signInWithGoogle(context), // Pass context here
              icon: const Icon(Icons.g_mobiledata, color: Colors.white),
              label: const Text("Login with Google"),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ElevatedButton.icon(
              onPressed: () => _showEmailPasswordSignup(),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text("Sign Up with Email/Password"),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmailPasswordSignup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Email/Password Signup"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  _emailController,
                  "Email",
                  _validationService.validateEmail,
                  true,
                  TextInputType.emailAddress,
                ),
                _buildTextField(
                  _passwordController,
                  "Password",
                  _validationService.validatePassword,
                  true,
                  TextInputType.visiblePassword,
                  isPassword: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _signupWithEmailPassword,
              child: const Text("Sign Up"),
            ),
          ],
        );
      },
    );
  }

  void _signupWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        toastService.showSuccessMessage("Account created successfully. You can now log in.");
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);
        if (e.code == 'email-already-in-use') {
          toastService.showErrorMessage("Email already in use.");
        } else {
          toastService.showErrorMessage("An error occurred: ${e.message}");
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showEmailPasswordLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Email/Password Login"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  _emailController,
                  "Email",
                  _validationService.validateEmail,
                  true,
                  TextInputType.emailAddress,
                ),
                _buildTextField(
                  _passwordController,
                  "Password",
                  _validationService.validatePassword,
                  true,
                  TextInputType.visiblePassword,
                  isPassword: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _loginWithEmailPassword,
              child: const Text("Sign In"),
            ),
          ],
        );
      },
    );
  }

  void _loginWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        toastService.showSuccessMessage("Signed in successfully");
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);
        if (e.code == 'user-not-found') {
          toastService.showErrorMessage("Email not registered");
        } else if (e.code == 'wrong-password') {
          toastService.showErrorMessage("Wrong password");
        } else {
          toastService.showErrorMessage("An error occurred");
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showPhoneOtpLogin() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Phone/OTP Login"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    _phoneController,
                    "Phone Number",
                    _validationService.validateNotEmpty,
                    true,
                    TextInputType.phone,
                  ),
                  if (_verificationId != null) // Show OTP field after OTP is sent
                    _buildTextField(
                      _otpController,
                      "OTP",
                      _validationService.validateNotEmpty,
                      true,
                      TextInputType.number,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _verificationId == null
                      ? () => _sendOtp(setState)
                      : _verifyOtp,
                  child: Text(_verificationId == null ? "Send OTP" : "Verify OTP"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendOtp(Function setState) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          toastService.showSuccessMessage("Phone Authentication Successful");
          Navigator.pop(context); // Close the dialog on success
        },
        verificationFailed: (FirebaseAuthException e) {
          toastService.showErrorMessage("Error: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          toastService.showSuccessMessage("OTP Sent");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = null;
          });
        },
      );
    } catch (e) {
      toastService.showErrorMessage("Error sending OTP");
    }
  }

  void _verifyOtp() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      toastService.showSuccessMessage("Phone Authentication Successful");
      Navigator.pop(context); // Close the dialog on success
    } catch (e) {
      toastService.showErrorMessage("Invalid OTP");
    }
  }


  void _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Show success message
        toastService.showSuccessMessage("Google Authentication Successful");

        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      print(e.toString());
      toastService.showErrorMessage("Google Authentication Failed");
    }
  }


  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? Function(String?) validator,
      bool required,
      TextInputType keyboard, {
        bool isPassword = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: '$label${required ? ' *' : ''}',
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
