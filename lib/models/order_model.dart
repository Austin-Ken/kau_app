import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../../helpers/currency_formatter.dart';

enum OrderStatus { 
  packed, 
  shipped, 
  completed 
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String paymentMethod;
  final DateTime orderDate;
  final Rx<OrderStatus> status; 

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderDate,
    required this.status,
  });

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

  String get itemSummary {
    if (items.isEmpty) return 'Tidak ada item';
    final firstItem = items.first.product.title;
    final totalQuantity = items.fold(0, (sum, item) => sum + item.quantity.value);
    return '$firstItem ${items.length > 1 ? 'dan ${items.length - 1} item lain' : ''} ($totalQuantity item)';
  }

  String get formattedTotal => CurrencyFormatter.formatIDR(totalAmount);
}