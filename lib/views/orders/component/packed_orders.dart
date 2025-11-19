import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/order_controller.dart';
import 'order_card.dart';

class PackedOrders extends StatelessWidget {
  const PackedOrders({super.key});
  
  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Obx(() {
      final packed = orderController.packedOrders;
      
      if (packed.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text('Tidak ada pesanan yang sedang dikemas.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: packed.length,
        itemBuilder: (context, index) {
          return OrderCard(order: packed[index]);
        },
      );
    });
  }
}