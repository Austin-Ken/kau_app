import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import 'order_card.dart'; 

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Obx(() {
      final completed = orderController.completedOrders;
      
      if (completed.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text('Belum ada pesanan yang selesai.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: completed.length,
        itemBuilder: (context, index) {
          return OrderCard(order: completed[index]);
        },
      );
    });
  }
}