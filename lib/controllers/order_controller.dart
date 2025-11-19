import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/product_model.dart'; 
import 'dart:async'; 

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  List<OrderModel> get packedOrders => 
      orders.where((o) => o.status.value == OrderStatus.packed).toList().obs;
  
  List<OrderModel> get shippedOrders => 
      orders.where((o) => o.status.value == OrderStatus.shipped).toList().obs;
  
  List<OrderModel> get completedOrders => 
      orders.where((o) => o.status.value == OrderStatus.completed).toList().obs;

  void addOrder(List<CartItem> items, double totalAmount, String paymentMethod) {
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      items: List.from(items), 
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      orderDate: DateTime.now(),
      status: OrderStatus.packed.obs,
    );

    orders.add(newOrder);
    
    _startStatusSimulation(newOrder);
  }

  void _startStatusSimulation(OrderModel order) {
     Get.snackbar(
        'Pesanan Diproses',
        'Pesanan Anda kini berada di tahap Dikemas.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

    Timer(const Duration(seconds: 10), () {
      if (order.status.value == OrderStatus.packed) {
        order.status.value = OrderStatus.shipped;
        Get.snackbar(
          'Pesanan Dikirim!',
          'Pesanan #${order.id.substring(order.id.length - 4)} sedang dalam perjalanan.',
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    });

    Timer(const Duration(seconds: 25), () {
      if (order.status.value == OrderStatus.shipped) {
        order.status.value = OrderStatus.completed;
        Get.snackbar(
          'Pesanan Selesai!',
          'Pesanan #${order.id.substring(order.id.length - 4)} telah sampai di tujuan.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    });
  }
}