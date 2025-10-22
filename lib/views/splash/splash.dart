import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/splash_controller.dart'; 

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(), 
      builder: (s) => Scaffold(
        backgroundColor: Colors.red, 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: const Image(
                  image: AssetImage("assets/icons/KAU-logo.png"), 
                  height: 170, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
