import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart'; // Asumsi CartItem ada di sini
import '../../helpers/currency_formatter.dart';

// Enum untuk Status Pesanan
enum OrderStatus { 
  packed, // Dikemas
  shipped, // Dikirim
  completed // Selesai
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime orderDate;
  // Rx<OrderStatus> agar status pesanan reaktif dan bisa update UI
  final Rx<OrderStatus> status; 

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderDate,
    required this.status,
  });

  // Helper untuk mendapatkan deskripsi status
  String get statusText {
    switch (status.value) {
      case OrderStatus.packed:
        return 'Dikemas';
      case OrderStatus.shipped:
        return 'Dikirim';
      case OrderStatus.completed:
        return 'Selesai';
    }
  }

  // Helper untuk mendapatkan warna status
  Color get statusColor {
    switch (status.value) {
      case OrderStatus.packed:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.green;
    }
  }

  // Helper untuk mendapatkan ikon status
  IconData get statusIcon {
    switch (status.value) {
      case OrderStatus.packed:
        return Icons.shopping_bag_outlined;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
    }
  }

  // Helper untuk mendapatkan ringkasan item
  String get itemSummary {
    if (items.isEmpty) return 'Tidak ada item';
    final firstItem = items.first.product.title;
    final totalQuantity = items.fold(0, (sum, item) => sum + item.quantity.value);
    return '$firstItem ${items.length > 1 ? 'dan ${items.length - 1} item lain' : ''} ($totalQuantity item)';
  }

  // Helper untuk memformat total
  String get formattedTotal => CurrencyFormatter.formatIDR(totalAmount);
}