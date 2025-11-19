import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/views/splash/splash.dart';
import 'bindings/main_binding.dart';
import 'bindings/app_binding.dart'; 
import 'views/orders/pesanan_page.dart';
import 'views/search/search_page.dart';
import 'views/search/search_result.dart';
import 'views/product/produk_page.dart';
import 'views/setting/setting_page.dart';
import 'views/top_up/topup_page.dart';
import 'views/login/login_page.dart';
import 'views/main_screen.dart';
import 'views/cart/cart_page.dart';
import 'views/search/category_result_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kau App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: AppBindings(), 
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/mainscreen', page: () => const MainScreen(), binding: MainBindings()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/setting', page: () => const SettingPage()),
        GetPage(name: '/topup', page: () => const TopupPage()),
        GetPage(name: '/produk', page: () => const ProdukPage()),
        GetPage(name: '/pesanan', page: () => const PesananPage()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/search_result', page: () => const SearchResultPage()),
        GetPage(name: '/category_result', page: () => const CategoryResultPage()),
      ],
    );
  }
}