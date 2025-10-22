import 'package:flutter/material.dart';

// Model untuk item yang ada di dalam sebuah pesanan
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({required this.name, required this.quantity, required this.price});
}

// Model untuk satu pesanan lengkap
class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final String status; // Misalnya: 'Diproses', 'Dikirim', 'Selesai', 'Dibatalkan'
  final double totalAmount;
  final List<OrderItem> items;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
  });

  // Getter untuk menentukan warna berdasarkan status
  Color get statusColor {
    switch (status) {
      case 'Selesai':
        return Colors.green.shade600;
      case 'Dikirim':
        return Colors.blue.shade600;
      case 'Diproses':
        return Colors.orange.shade600;
      case 'Dibatalkan':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
