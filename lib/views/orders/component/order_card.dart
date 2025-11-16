import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: order.statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: #${order.id.substring(order.id.length - 6)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                Row(
                  children: [
                    Icon(order.statusIcon, size: 18, color: order.statusColor),
                    const SizedBox(width: 5),
                    Text(
                      order.statusText.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: order.statusColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.itemSummary,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(order.paymentMethod == 'COD' ? Icons.payments : Icons.account_balance_wallet, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('Metode Pembayaran: ${order.paymentMethod}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(
                      order.formattedTotal,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}