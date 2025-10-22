import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/produk_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdukController produkController = Get.find<ProdukController>();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: produkController.produkList.length,
          itemBuilder: (context, index) {
            final item = produkController.produkList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Image.network(
                  item['image']as String,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item['name']as String),
                subtitle: Text('Rp${item['price']!}'),
                trailing: Text('Jumlah: ${item['quantity']!}'),
              ),
            );
          },
        ),
      ),
    );
  }
}