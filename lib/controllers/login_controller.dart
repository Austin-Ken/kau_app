import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  var isPasswordVisible = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var usernameErrorText = RxString('');
  var passwordErrorText = RxString('');

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(_validateUsername);
    passwordController.addListener(_validatePassword);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void _validateUsername() {
    if (usernameController.text.length < 6 && usernameController.text.isNotEmpty) {
      usernameErrorText.value = 'Username minimal 6 karakter';
    } else {
      usernameErrorText.value = '';
    }
  }

  void _validatePassword() {
    if (passwordController.text.length < 8 && passwordController.text.isNotEmpty) {
      passwordErrorText.value = 'Password minimal 8 karakter';
    } else {
      passwordErrorText.value = '';
    }
  }

  bool validateInputs() {
    if (usernameController.text.length < 6) {
      usernameErrorText.value = 'Username minimal 6 karakter';
      return false;
    } else {
      usernameErrorText.value = '';
    }

    if (passwordController.text.length < 8) {
      passwordErrorText.value = 'Password minimal 8 karakter';
      return false;
    } else {
      passwordErrorText.value = '';
    }

    return true;
  }
}