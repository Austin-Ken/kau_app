import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/views/orders/pesanan_page.dart';
import '../controllers/main_controller.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mainController = Get.put(MainController());

    final List<Widget> pages = [
      HomePage(),
      PesananPage(),
      ProfilePage(),
    ];
    return Scaffold(
      body: Obx(
        () => pages[mainController.currentIndex.value]
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changePage,
          selectedItemColor: const Color.fromARGB(255, 255, 17, 0),
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ], 
          ),
      ),
    );
  }
}