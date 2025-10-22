import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/produk_controller.dart';
import 'package:kau_app/models/product_model.dart'; 

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdukController produkController = Get.find();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade700, 
        elevation: 0.5,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            autofocus: true,
            onChanged: (value) {
              produkController.searchQuery.value = value;
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                Get.toNamed('/search_result', arguments: value);
              }
            },
            decoration: const InputDecoration(
              hintText: 'Cari...',
              filled: true,
              fillColor: Colors.transparent, 
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 12.0),
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
        if (produkController.isLoading.isTrue && produkController.produkList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final listToShow = produkController.filteredProdukList.isEmpty && produkController.searchQuery.isEmpty
            ? produkController.produkList
            : produkController.filteredProdukList;

        if (listToShow.isEmpty) {
             return const Center(
             child: Text(
               'Tidak ada produk untuk ditampilkan.',
               style: TextStyle(fontSize: 18, color: Colors.grey),
             ),
          );
        }
        return ListView.builder(
          itemCount: produkController.filteredProdukList.length,
          itemBuilder: (context, index) {
            final ProductModel data = produkController.filteredProdukList[index];
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Card(
                color: Colors.white, 
                elevation: 0, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  title: Text(
                    data.title, 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade800),
                  ), 
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Get.toNamed('/search_result', arguments: data.title); 
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
