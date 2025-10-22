import 'package:get/get.dart';
import 'package:flutter/material.dart'; 
import '../models/product_model.dart'; 

class CartController extends GetxController {
  
  final isLoading = false.obs;

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Getter yang disederhanakan: Sekarang mengembalikan double (bukan RxDouble).
  // Perhitungan ini otomatis reaktif karena menggunakan properti reaktif (cartItems, item.quantity).
  double get totalCartPrice {
    return cartItems.fold(
      0.0, 
      (sum, item) => sum + (item.product.price * item.quantity.value)
    );
  }

  void addToCart(ProductModel product) {
    isLoading.value = true; 
    try {
      final index = cartItems.indexWhere((item) => item.product.id == product.id);

      if (index >= 0) {
        cartItems[index].quantity.value++;
      } else {
        // Menggunakan item.quantity.value (RxInt) untuk inisialisasi
        cartItems.add(CartItem(product: product, quantity: 1.obs));
      }
      // Tidak perlu cartItems.refresh() jika menggunakan RxList methods (add/remove)
      Get.snackbar(
        'Keranjang', 
        '${product.title} telah diperbarui.', 
        snackPosition: SnackPosition.TOP, 
        backgroundColor: Colors.green, 
        colorText: Colors.white
      );

    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan: $e', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; 
    }
  }

  void incrementQuantity(CartItem item) {
    item.quantity.value++;
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
    } else {
      removeItem(item);
    }
  }

  void removeItem(CartItem item) {
    cartItems.removeWhere((cartItem) => cartItem.product.id == item.product.id);
    Get.snackbar('Dihapus', '${item.product.title} telah dihapus.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
  }
}
