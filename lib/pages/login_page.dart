import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan Controller diinisialisasi atau ditemukan
    final loginController = Get.put(LoginController());
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Tinggi 75% dari layar untuk container login
    final containerHeight = screenHeight * 0.75;

    return Scaffold(
      // Tidak perlu AppBar karena kita ingin tampilan full screen
      body: Stack(
        children: [
          // 1. Latar Belakang Merah Penuh
          Container(
            color: Colors.red, // Menggunakan shade agar terlihat lebih elegan
            height: screenHeight,
            width: double.infinity,
          ),
          
          // 2. Container Putih (75% dari bawah)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: containerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                // Memberikan sudut melengkung di bagian atas
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              
              // Konten login di dalam SingleChildScrollView
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Selamat Datang',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      'Silakan Login ke Akun Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Field Username
                    Obx(
                      () => TextField(
                        controller: loginController.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person, color: Colors.red),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.red.shade50,
                          errorText: loginController.usernameErrorText.value.isNotEmpty
                              ? loginController.usernameErrorText.value
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Field Password
                    Obx(
                      () => TextField(
                        controller: loginController.passwordController,
                        obscureText: !loginController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock, color: Colors.red),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.red.shade50,
                          errorText: loginController.passwordErrorText.value.isNotEmpty
                              ? loginController.passwordErrorText.value
                              : null,
                          suffixIcon: IconButton(
                            onPressed: loginController.togglePasswordVisibility,
                            icon: Icon(
                              loginController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Tombol Login
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        if (loginController.validateInputs()) {
                          Get.offAllNamed('/mainscreen');
                        }
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          
          // Teks "Login" di tengah atas merah agar terlihat kontras
          Positioned(
            top: screenHeight * 0.1, // Posisi teks di bagian atas layar merah
            left: 0,
            right: 0,
            child: const Text(
              'KAU APP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
