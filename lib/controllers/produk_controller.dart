import 'package:get/get.dart';
// Ganti import http dengan import service baru
import '../services/api_service.dart'; 
import '../models/product_model.dart';
import 'dart:developer'; // Import untuk fungsi log

class ProdukController extends GetxController {
  // Inisialisasi Service API di sini
  final ApiService _apiService = ApiService(); 
  
  final produkList = <ProductModel>[].obs;
  final filteredProdukList = <ProductModel>[].obs; 
  final isLoading = true.obs;

  var searchQuery= ''.obs;

  @override
  void onInit() {
    // Agar ApiService siap sebelum digunakan
    _apiService.onInit();
    
    fetchProducts();
    debounce(searchQuery, (query) {
      filterProduk(query);
    }, time: const Duration(milliseconds: 500));
    super.onInit();
  }

  void fetchProducts() async {
    isLoading.value = true;
    try {
      // PANGGILAN MENGGUNAKAN GETCONNECT
      final List<ProductModel> products = await _apiService.getProducts();
      
      produkList.assignAll(products);
      filteredProdukList.assignAll(products); 
      
    } catch (e) {
      // DEBUGGING: Cetak error detail ke konsol
      log('API ERROR DETAIL: $e', name: 'ProdukController');
      
      // Tangani exception dari ApiService
      Get.snackbar("Error API", e.toString().contains('Status') ? e.toString() : "Tidak dapat terhubung ke server. Pastikan koneksi internet stabil.");
    } finally {
      isLoading.value = false;
    }
  }
  
  void filterProduk(String query) {
    if (query.isEmpty) {
      filteredProdukList.assignAll(produkList);
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    
    final results = produkList.where((product) {
      final title = product.title.toLowerCase();
      final category = product.category.toLowerCase();
      
      return title.contains(lowerCaseQuery) || category.contains(lowerCaseQuery);
    }).toList();

    filteredProdukList.assignAll(results);
  }

}
