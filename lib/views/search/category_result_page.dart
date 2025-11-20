import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/controllers/produk_controller.dart'; 
import 'package:kau_app/helpers/currency_formatter.dart';
import 'package:kau_app/models/product_model.dart';

class CategoryResultPage extends StatelessWidget {
  const CategoryResultPage({super.key});

  Widget _buildProductGrid(List<ProductModel> products) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final data = products[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed('/produk', arguments: data);
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
                      data.image,
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
                        data.title, 
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.formatIDR(data.price),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          Text('${data.rating.rate}', style: const TextStyle(fontSize: 12)),
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
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final categoryName = arguments?['category_name'] ?? 'Semua Produk'; 
    final categoryId = arguments?['category_id'] ?? 'semua';
    
    final ProdukController produkController = Get.find<ProdukController>(); 

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hasil untuk kategori: $categoryName',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic
                ),
              ),
            ),
            Obx(() {
              if (produkController.isLoading.isTrue) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: CircularProgressIndicator(color: Colors.red)
                  )
                );
              }
              
              final filteredProducts = produkController.getProductsByCategory(categoryId);


              if (filteredProducts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text("Tidak ada produk tersedia dalam kategori '$categoryName'."),
                  ),
                );
              }

              return _buildProductGrid(filteredProducts);
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}