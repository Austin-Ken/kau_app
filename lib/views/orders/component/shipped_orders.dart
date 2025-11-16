import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import 'order_card.dart'; 

class ShippedOrders extends StatelessWidget {
  const ShippedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Obx(() {
      final shipped = orderController.shippedOrders;
      
      if (shipped.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text('Tidak ada pesanan yang sedang dikirim.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: shipped.length,
        itemBuilder: (context, index) {
          return OrderCard(order: shipped[index]);
        },
      );
    });
  }
}