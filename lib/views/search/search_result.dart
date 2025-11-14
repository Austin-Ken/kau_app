import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/produk_controller.dart';
import 'package:kau_app/models/product_model.dart'; 

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdukController produkController = Get.find();

    final String confirmedQuery = Get.arguments as String? ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (confirmedQuery.isNotEmpty) {
        produkController.filterProduk(confirmedQuery);
      }
    });
    
    final List<ProductModel> searchResults = produkController.filteredProdukList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil untuk "$confirmedQuery"'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Obx(() {
        if (produkController.isLoading.isTrue && searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (searchResults.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada hasil untuk kueri "$confirmedQuery".',
              style: const TextStyle(fontSize: 18),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7, 
          ),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final ProductModel product = searchResults[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed('/produk', arguments: product);
              },
              child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              Text('${product.rating.rate}', style: const TextStyle(fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                  ),
              ),
            );
          },
        );
      }),
    );
  }
}
