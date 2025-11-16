import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/produk_controller.dart';
import 'package:kau_app/models/product_model.dart'; 
import 'package:kau_app/helpers/currency_formatter.dart'; // Import Formatter yang baru


class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Diasumsikan ProdukController sudah diinisialisasi
    final ProdukController produkController = Get.find();

    // Mengambil query pencarian yang dikirim dari halaman sebelumnya
    final String confirmedQuery = Get.arguments as String? ?? '';

    // Memicu filter produk segera setelah frame pertama dibangun
    // Ini memastikan filter berjalan hanya sekali ketika halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (confirmedQuery.isNotEmpty) {
        // Panggil filterProduk, yang akan memperbarui filteredProdukList
        produkController.filterProduk(confirmedQuery);
      }
    });
    
    // Perhatian: searchResults di sini mengambil List yang TIDAK reaktif 
    // pada saat build dipanggil (hanya sekali). 
    // GridView di bawah dibungkus dengan Obx untuk memantau perubahan pada filteredProdukList.
    // Jika Anda ingin menggunakan variabel lokal ini di luar Obx, Anda harus mengambilnya dari controller.
    // Mari kita gunakan Obx untuk mengakses list yang reaktif.

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil untuk "$confirmedQuery"'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Obx(() {
        // Gunakan list reaktif dari controller
        final List<ProductModel> searchResults = produkController.filteredProdukList;

        if (produkController.isLoading.isTrue && searchResults.isEmpty) {
          // Tampilkan loading jika sedang memuat dan belum ada hasil
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if (searchResults.isEmpty) {
          // Tampilkan pesan jika tidak ada hasil
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada hasil untuk kueri "$confirmedQuery".',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        // Tampilkan hasil pencarian dalam GridView
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
                // Navigasi ke halaman produk dengan detail produk
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
                          // --- PERBAIKAN FORMATTER HARGA ---
                          Text(
                            CurrencyFormatter.formatIDR(product.price),
                            // Sebelum: 'Rp${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ---------------------------------
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