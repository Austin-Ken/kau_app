import 'package:get/get.dart';

// --- MODEL PRODUCT ---
class ProductModel {
  final int id;
  // Memastikan ada properti 'title' dan 'image'
  final String title; 
  final String image; 
  final double price;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });
}

// --- MODEL CART ITEM ---
class CartItem {
  final ProductModel product;
  // Quantity adalah RxInt (Reactive)
  final RxInt quantity; 

  CartItem({required this.product, required this.quantity});
}
