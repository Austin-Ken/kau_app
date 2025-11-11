import 'package:get/get.dart';
import 'package:flutter/material.dart'; 
import '../models/product_model.dart'; 

class CartController extends GetxController {
  
  final isLoading = false.obs;

  final RxList<CartItem> cartItems = <CartItem>[].obs;

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
        cartItems.add(CartItem(product: product, quantity: 1.obs));
      }
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

  void clearCart() {
    cartItems.clear();
    
    // Opsional: Beri notifikasi kalau keranjang bersih
    Get.snackbar(
      'Selesai', 
      'Keranjang telah dikosongkan setelah pembayaran.', 
      snackPosition: SnackPosition.BOTTOM, 
      backgroundColor: Colors.blue, 
      colorText: Colors.white
    );
  }
}
