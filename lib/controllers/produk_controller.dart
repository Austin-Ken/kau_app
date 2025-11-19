import 'package:get/get.dart';
import '../services/api_service.dart'; 
import '../models/product_model.dart';
import 'dart:developer';

class ProdukController extends GetxController {
  final ApiService _apiService = Get.put(ApiService()); 
  
  final produkList = <ProductModel>[].obs;
  final filteredProdukList = <ProductModel>[].obs; 
  final isLoading = true.obs;

  var searchQuery= ''.obs;

  @override
  void onInit() {
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
      final List<ProductModel> products = await _apiService.getProducts();
      
      produkList.assignAll(products);
      filteredProdukList.assignAll(products); 
      
    } catch (e) {
      log('API ERROR DETAIL: $e', name: 'ProdukController');
      
      Get.snackbar(
        "Error API", 
        e.toString().contains('Status') || e.toString().contains('Gagal memuat') ? e.toString() : "Terjadi kesalahan saat memproses data produk.",
        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
        colorText: Get.theme.snackBarTheme.actionTextColor,
      );
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

  List<ProductModel> getProductsByCategory(String categoryId) {
    if (categoryId.toLowerCase() == 'semua') {
      return produkList;
    }
    
    return produkList
        .where((product) => product.category.toLowerCase() == categoryId.toLowerCase())
        .toList();
  }
}