import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/validation.dart';
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
  final _formKey = GlobalKey<FormState>(); // Form key

  IValidationService get _validationService => ValidationService();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : Scaffold(
            appBar: AppBar(),
            body: Directionality(
              textDirection: currentLocale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: _buildLoginForm(),
            ),
          );
  }

  Widget _buildLoginForm() {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

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
              localization.get('loginTitle'),
              style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black),
            ),
            SizedBox(height: verticalSpacingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildTextField(
                _emailController,
                localization.get('email'),
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
                localization.get('password'),
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
    double fontSize =
        screenWidth * 0.045; // Adjust font size based on screen width
    double verticalPadding =
        screenWidth * 0.02; // Adjust vertical padding based on screen width
    double borderRadius =
        screenWidth * 0.03; // Adjust border radius based on screen width
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: TextFormField(
        keyboardType: keyboard,
        style: TextStyle(
            color: isDark ? Colors.white : Colors.black, fontSize: fontSize),
        controller: controller,
        cursorColor: isDark ? Colors.yellow.shade700 : Colors.yellow.shade800,
        obscureText: isPassword,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide:
                BorderSide(color: isDark ? Colors.white70 : Colors.black87),
          ),
          labelStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: fontSize),
          hintStyle: TextStyle(
              color: isDark ? Colors.white10 : Colors.black12,
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
    double buttonWidth = screenWidth * 0.5; // 50% of screen width
    double buttonHeight = screenHeight * 0.08; // 8% of screen height
    double fontSize =
        screenWidth * 0.045; // Adjust font size based on screen width
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

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
        localization.get('signInButton'),
        style: TextStyle(
          color: isDark ? Colors.black : Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await userService.signIn(_emailController.text, _passwordController.text);

        toastService.showSuccessMessage(localization.get('signInSuccess'));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);

        if (e.code == 'user-not-found') {
          toastService
              .showErrorMessage(localization.get('phoneNumberNotRegistered'));
        } else if (e.code == 'wrong-password') {
          toastService.showErrorMessage(localization.get('signInError'));
        } else {
          toastService
              .showErrorMessage(localization.get('unknownErrorOccurred'));
        }
      } catch (e) {
        setState(() => isLoading = false);
        toastService.showErrorMessage(localization.get('unknownErrorOccurred'));
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
