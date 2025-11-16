import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../models/product_model.dart'; 
import 'dart:async'; 

class OrderController extends GetxController {
  // RxList untuk menyimpan semua pesanan
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  // Getter yang difilter untuk setiap tab (DIKEMAS)
  List<OrderModel> get packedOrders => 
      orders.where((o) => o.status.value == OrderStatus.packed).toList().obs;
  
  // Getter yang difilter untuk setiap tab (DIKIRIM)
  List<OrderModel> get shippedOrders => 
      orders.where((o) => o.status.value == OrderStatus.shipped).toList().obs;
  
  // Getter yang difilter untuk setiap tab (SELESAI)
  List<OrderModel> get completedOrders => 
      orders.where((o) => o.status.value == OrderStatus.completed).toList().obs;

  // --- FUNGSI: Menambah Pesanan Baru ---
  void addOrder(List<CartItem> items, double totalAmount, String paymentMethod) {
    final newOrder = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unik
      items: List.from(items), 
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      orderDate: DateTime.now(),
      status: OrderStatus.packed.obs, // Mulai dari Dikemas
    );

    orders.add(newOrder);
    
    // Mulai simulasi perpindahan status
    _startStatusSimulation(newOrder);
  }

  // --- FUNGSI: Simulasi Perpindahan Status ---
  void _startStatusSimulation(OrderModel order) {
    // Pesanan baru dibuat, beri notifikasi
     Get.snackbar(
        '📦 Pesanan Diproses',
        'Pesanan Anda kini berada di tahap Dikemas.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );

    // Simulasi 1: Dikemas (Packed) -> Dikirim (Shipped) dalam 5 detik
    Timer(const Duration(seconds: 10), () {
      if (order.status.value == OrderStatus.packed) {
        order.status.value = OrderStatus.shipped;
        Get.snackbar(
          '🚛 Pesanan Dikirim!',
          'Pesanan #${order.id.substring(order.id.length - 4)} sedang dalam perjalanan.',
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    });

    // Simulasi 2: Dikirim (Shipped) -> Selesai (Completed) dalam 10 detik *setelah Dikirim* (total 15 detik dari awal)
    Timer(const Duration(seconds: 25), () {
      if (order.status.value == OrderStatus.shipped) {
        order.status.value = OrderStatus.completed;
        Get.snackbar(
          '✅ Pesanan Selesai!',
          'Pesanan #${order.id.substring(order.id.length - 4)} telah sampai di tujuan.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    });
  }
}