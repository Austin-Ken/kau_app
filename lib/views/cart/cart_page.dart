import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart'; 
import '../../models/product_model.dart'; 
import '../../helpers/currency_formatter.dart'; 

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red.shade700 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        elevation: 1,
      ),
      body: Obx(
        () {
          // --- KOREKSI: Akses langsung (tanpa .value) ---
          final List<CartItem> cartItems = cartController.cartItems;
          final double subtotal = cartController.totalCartPrice;

          if (cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('Keranjang Anda kosong.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text('Yuk, cari produk menarik!', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final CartItem item = cartItems[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.image, 
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60, height: 60, color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            item.product.title,
                            maxLines: 2, 
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CurrencyFormatter.formatIDR(item.product.price), 
                                style: const TextStyle(
                                  color: Colors.red, 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // item.quantity adalah RxInt, jadi kita bungkus lagi dalam Obx untuk perubahan kuantitas
                              Obx(() => Text(
                                // Menggunakan .value di sini karena item.quantity adalah RxInt, 
                                // dan ini di dalam Obx lokal yang berbeda.
                                'Subtotal: ${CurrencyFormatter.formatIDR(item.product.price * item.quantity.value)}', 
                                style: TextStyle(
                                  color: Colors.grey[700], 
                                  fontSize: 14,
                                ),
                              )),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.black54),
                                onPressed: () {
                                  cartController.decrementQuantity(item);
                                },
                              ),
                              // Menggunakan Obx untuk menampilkan kuantitas RxInt
                              Obx(() => Text(
                                '${item.quantity.value}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () {
                                  cartController.incrementQuantity(item);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
                                  cartController.removeItem(item);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildCheckoutSummary(context, subtotal), 
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, double subtotal) {
    const double deliveryFee = 15000;
    final double grandTotal = subtotal + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(77),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3), 
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSummaryRow('Subtotal Barang', CurrencyFormatter.formatIDR(subtotal)),
          _buildSummaryRow('Biaya Pengiriman', CurrencyFormatter.formatIDR(deliveryFee)),

          const Divider(height: 20),

          _buildSummaryRow(
            'Total Pembayaran', 
            CurrencyFormatter.formatIDR(grandTotal), 
            isTotal: true
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: subtotal > 0 ? () {
                Get.snackbar('Checkout Berhasil', 'Pesanan dengan total ${CurrencyFormatter.formatIDR(grandTotal)} akan diproses.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green, colorText: Colors.white);
              } : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
