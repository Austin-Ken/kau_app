import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/views/orders/completed_orders.dart';
import 'package:kau_app/views/orders/packed_orders.dart';
import 'package:kau_app/views/orders/shipped_orders.dart';
import 'package:kau_app/views/orders/unpaid_orders.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final int initialIndex = arguments?['initialIndex'] ?? 0;

    return DefaultTabController(
      initialIndex: initialIndex, 
      length: 4, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Saya'),
          bottom: const TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Belum Bayar'),
              Tab(text: 'Dikemas'),
              Tab(text: 'Dikirim'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UnpaidOrders(),
            PackedOrders(),
            ShippedOrders(),
            CompletedOrders(),
          ],
        ),
      ),
    );
  }
}
