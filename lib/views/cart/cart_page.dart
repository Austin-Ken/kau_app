import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart'; 
import '../../controllers/profile_controller.dart'; 
import '../../controllers/order_controller.dart'; // IMPORT BARU
import '../../models/product_model.dart'; 
import '../../helpers/currency_formatter.dart'; 
import '../../models/order_model.dart'; // IMPORT BARU untuk OrderStatus

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // --- Widget Helper: Baris Ringkasan ---
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

  // --- FUNGSI: Dialog Pemilihan Metode Pembayaran ---
  void _showPaymentMethodDialog(
    BuildContext context, 
    double totalAmount, 
    CartController cartController, 
    ProfileController profileController,
    OrderController orderController, // TAMBAH PARAMETER
  ) {
    
    final formattedPrice = CurrencyFormatter.formatIDR(totalAmount);
    
    Get.defaultDialog(
      title: "Pilih Metode Pembayaran",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      radius: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      content: Obx(() {
        final formattedBalance = CurrencyFormatter.formatIDR(profileController.balance.value);
        final isSaldoEnough = profileController.balance.value >= totalAmount;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Detail Harga Total
            Text('Total Belanja: $formattedPrice', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            const Divider(),
            
            // Tampilan Saldo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saldo Anda Saat Ini:', style: TextStyle(fontSize: 14)),
                Text(formattedBalance, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 15),

            // Opsi 1: Bayar menggunakan Saldo
            ElevatedButton(
              onPressed: !isSaldoEnough ? null : () async {
                Get.back(); // Tutup dialog sebelum proses

                await Future.delayed(const Duration(milliseconds: 300)); 
                final bool success = profileController.payOrder(totalAmount);
                
                if (success) {
                  // LOGIKA BARU: Tambahkan pesanan dan navigasi
                  orderController.addOrder(
                    cartController.cartItems.toList(), // Salin item keranjang
                    totalAmount, 
                    "Saldo"
                  );
                  cartController.clearCart(); 
                  Get.offNamed('/pesanan', arguments: {'initialIndex': 0}); // Navigasi ke Dikemas
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSaldoEnough ? Colors.blue : Colors.grey,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                isSaldoEnough ? 'Bayar Pakai Saldo' : 'Saldo Tidak Cukup',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            if (!isSaldoEnough) 
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Anda kekurangan ${CurrencyFormatter.formatIDR(totalAmount - profileController.balance.value)}', 
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            const SizedBox(height: 10),

            // Opsi 2: Cash On Delivery (COD)
            ElevatedButton(
              onPressed: () async {
                Get.back(); // Tutup dialog
                await Future.delayed(const Duration(milliseconds: 300)); 

                profileController.processCOD(totalAmount);
                
                // LOGIKA BARU: Tambahkan pesanan dan navigasi
                orderController.addOrder(
                  cartController.cartItems.toList(), 
                  totalAmount, 
                  "COD"
                );
                cartController.clearCart();
                Get.offNamed('/pesanan', arguments: {'initialIndex': 0}); // Navigasi ke Dikemas
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Cash On Delivery (COD)',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      }),
    );
  }
  // --- END FUNGSI Dialog ---

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final ProfileController profileController = Get.find<ProfileController>(); 
    final OrderController orderController = Get.find<OrderController>(); // Cari OrderController

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        elevation: 1,
      ),
      body: Obx(
        () {
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
                            borderRadius: BorderRadius.circular(12),
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
                              Obx(() => Text(
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
              _buildCheckoutSummary(context, subtotal, cartController, profileController, orderController), 
            ],
          );
        },
      ),
    );
  }

  // --- Widget: Ringkasan Checkout ---
  Widget _buildCheckoutSummary(
    BuildContext context, 
    double subtotal, 
    CartController cartController, 
    ProfileController profileController, 
    OrderController orderController, // TAMBAH PARAMETER
  ) {
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
                // PANGGIL DIALOG DENGAN OrderController
                _showPaymentMethodDialog(
                  context, 
                  grandTotal, 
                  cartController, 
                  profileController,
                  orderController,
                );
              } : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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