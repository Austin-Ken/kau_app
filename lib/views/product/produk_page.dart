import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/models/product_model.dart'; 
import '/controllers/cart_controller.dart'; // Import controller baru
import '../../helpers/currency_formatter.dart'; // Import CurrencyFormatter

class ProdukPage extends StatelessWidget {
  const ProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cari instance CartController. Pastikan controller ini sudah di-put/lazyPut
    // di Bindings aplikasi Anda sebelum halaman ini diakses.
    final CartController cartController = Get.put(CartController());
    final ProductModel produk = Get.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade700, 
        title: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.toNamed('/search');
          },
          child: IgnorePointer(
            child: Container( 
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: const TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  filled: true,
                  fillColor: Colors.transparent, 
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              produk.image, 
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4, 
              fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.title, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Menggunakan CurrencyFormatter.formatIDR()
                    CurrencyFormatter.formatIDR(produk.price),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kategori: ${produk.category}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produk.description, 
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 5,
              offset: const Offset(0, -2),
            )
          ]
        ),
        child: Obx(() => // Gunakan Obx untuk mengamati status loading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cartController.isLoading.isTrue ? null : (){
                    // Ketika ditekan, langsung lakukan checkout (asumsi)
                    Get.snackbar(
                      'Beli Sekarang',
                      'Melakukan checkout untuk ${produk.title}.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  // PANGGILAN API: Panggil fungsi addToCart di controller
                  onPressed: cartController.isLoading.isTrue ? null : () {
                    cartController.addToCart(produk);
                  }, 
                  
                  icon: cartController.isLoading.isTrue 
                    ? const SizedBox(
                        width: 20, 
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, 
                          strokeWidth: 2
                        )
                      ) 
                    : const Icon(Icons.add_shopping_cart, color: Colors.white,),
                  
                  label: Text(
                    cartController.isLoading.isTrue ? 'Memproses...' : 'Keranjang',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
