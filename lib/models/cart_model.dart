import 'package:get/get.dart';

class ProductModel {
  final int id;
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

class CartItem {
  final ProductModel product;
  final RxInt quantity; 

  CartItem({required this.product, required this.quantity});
}
