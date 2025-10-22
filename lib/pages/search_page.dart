import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/produk_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdukController produkController = Get.find();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[224],
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            autofocus: true,
            onChanged: (value) {
              produkController.filterProduk(value);
            },
            decoration: InputDecoration(
              hintText: 'Cari...',
              filled: true,
              fillColor: Colors.transparent, 
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Obx(() {
        if (produkController.filteredProdukList.isEmpty) {
          return const Center(
            child: Text(
              'Produk tidak ditemukan.',
              style: TextStyle(
                fontSize: 18,
              ),
              ),
          );
        }
        return ListView.builder(
          itemCount: produkController.filteredProdukList.length,
          itemBuilder: (context, index) {
            final data = produkController.filteredProdukList[index];
            return Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Card(
                  color: Colors.grey[350],
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: Text(data['name']),
                    onTap: () {
                      Get.toNamed('/search_result', arguments: data['name']);
                    },
                  ),
                ),),
              ],
            );
          },
        );
      }),
    );
  }
}
