import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/validation.dart';
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
  final _formKey = GlobalKey<FormState>();

  IValidationService get _validationService => ValidationService();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : Scaffold(
            appBar: AppBar(),
            body: Center(child: _buildLoginForm()),
          );
  }

  Widget _buildLoginForm() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = screenWidth * 0.06;
    double horizontalPadding = screenWidth * 0.05;
    double verticalSpacingSmall = screenHeight * 0.022;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: verticalSpacingSmall),
            Text(
              "Login",
              style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: verticalSpacingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildTextField(
                _emailController,
                "Email",
                _validationService.validateEmail,
                true,
                TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: verticalSpacingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildTextField(
                _passwordController,
                "password",
                _validationService.validatePassword,
                true,
                TextInputType.visiblePassword,
              ),
            ),
            SizedBox(height: verticalSpacingSmall),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? Function(String?) validator,
      bool required,
      TextInputType keyboard,
      {bool isPassword = false}) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Responsive adjustments
    double fontSize = screenWidth * 0.045;
    double verticalPadding = screenWidth * 0.02;
    double borderRadius = screenWidth * 0.03;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: TextFormField(
        selectionControls: EmptyTextSelectionControls(),
        keyboardType: keyboard,
        style: TextStyle(color: Colors.black, fontSize: fontSize),
        controller: controller,
        cursorColor: Colors.cyan,
        cursorOpacityAnimates: true,
        obscureText: isPassword,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide:
                const BorderSide(color: Colors.black87),
          ),
          labelStyle: TextStyle(
              color: Colors.black87,
              fontSize: fontSize),
          hintStyle: TextStyle(
              color: Colors.black12,
              fontSize: fontSize * 0.9),
          labelText: '$label${required ? ' *' : ''}',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildLoginButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Responsive button size and font size adjustments
    double buttonWidth = screenWidth * 0.5;
    double buttonHeight = screenHeight * 0.08;
    double fontSize = screenWidth * 0.045;

    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        fixedSize: Size(buttonWidth, buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        "Sign In",
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await userService.signIn(
            _emailController.text, _passwordController.text);

        toastService.showSuccessMessage("Signed in successfully");
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);

        if (e.code == 'user-not-found') {
          toastService
              .showErrorMessage("Phone Number Not Registered");
        } else if (e.code == 'wrong-password') {
          toastService.showErrorMessage("signInError");
        } else {
          toastService
              .showErrorMessage("unknownErrorOccurred");
        }
      } catch (e) {
        setState(() => isLoading = false);
        toastService.showErrorMessage("unknownErrorOccurred");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
