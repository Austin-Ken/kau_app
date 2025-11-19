import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kau_app/models/product_model.dart'; 
import '/controllers/cart_controller.dart'; 
import '/controllers/profile_controller.dart'; 
import '/controllers/order_controller.dart';
import '/models/order_model.dart';
import '../../helpers/currency_formatter.dart'; 

class ProdukPage extends StatelessWidget {
  const ProdukPage({super.key});

  void _showPaymentMethodDialog(
    BuildContext context, 
    ProductModel produk, 
    CartController cartController, 
    ProfileController profileController,
    OrderController orderController, 
  ) {
    
    final double totalAmount = produk.price;
    final formattedPrice = CurrencyFormatter.formatIDR(totalAmount);
    
    final List<CartItem> singleProductList = [
      CartItem(product: produk, quantity: 1.obs)
    ];

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
            Text('Produk: ${produk.title}', style: TextStyle(fontSize: 15, color: Colors.grey[700])),
            const SizedBox(height: 4),
            Text('Harga Total: $formattedPrice', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            const Divider(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saldo Anda Saat Ini:', style: TextStyle(fontSize: 14)),
                Text(formattedBalance, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: !isSaldoEnough ? null : () async {
                Get.back();

                await Future.delayed(const Duration(milliseconds: 300)); // Simulasi jeda UI
                final bool success = profileController.payOrder(totalAmount);
                
                if (success) {
                  orderController.addOrder(
                    singleProductList, 
                    totalAmount, 
                    "Saldo"
                  );
                  Get.offNamed('/pesanan', arguments: {'initialIndex': 0});
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

            ElevatedButton(
              onPressed: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 300)); // Simulasi jeda UI

                profileController.processCOD(totalAmount);
                
                orderController.addOrder(
                  singleProductList, 
                  totalAmount, 
                  "COD"
                );
                Get.offNamed('/pesanan', arguments: {'initialIndex': 0});
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

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final ProfileController profileController = Get.put(ProfileController()); 
    final OrderController orderController = Get.put(OrderController()); // <--- AMBIL ORDER CONTROLLER
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
        child: Obx(() => 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: cartController.isLoading.isTrue ? null : (){
                    _showPaymentMethodDialog(
                      context, 
                      produk, 
                      cartController, 
                      profileController,
                      orderController
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