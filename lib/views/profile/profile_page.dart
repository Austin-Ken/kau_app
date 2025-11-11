import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart'; 
import '../../helpers/currency_formatter.dart'; // Asumsi Anda punya helper ini

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  Widget _buildOrderStatusItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.red),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  // Instance Controller
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Hanya tambahkan AppBar jika tidak digunakan di bottom navigation bar
        toolbarHeight: 0,
      ),
      body: ListView(
        children: [
          // Bagian Profil & Avatar
          SizedBox(
            height: 110, 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://cbx-prod.b-cdn.net/COLOURBOX25634105.jpg?width=800&height=800&quality=70'),
                ),
                const SizedBox(width: 20),
                Expanded( 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Austin Keine Audranabel',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed('/setting');
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 40.0,
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Bagian Pesanan Saya
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pesanan Saya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/pesanan', arguments: {'initialIndex': 0});
                        },
                        child: Row(
                          children: const [
                            Text(
                              'Lihat Semua',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOrderStatusItem(Icons.payment, 'Belum Bayar', () => Get.toNamed('/pesanan', arguments: {'initialIndex': 0})),
                      _buildOrderStatusItem(Icons.inventory, 'Dikemas', () => Get.toNamed('/pesanan', arguments: {'initialIndex': 1})),
                      _buildOrderStatusItem(Icons.local_shipping, 'Dikirim', () => Get.toNamed('/pesanan', arguments: {'initialIndex': 2})),
                      _buildOrderStatusItem(Icons.check_circle, 'Selesai', () => Get.toNamed('/pesanan', arguments: {'initialIndex': 3})),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Bagian Saldo (Sekarang Reaktif)
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- MENGGUNAKAN OBX UNTUK SALDO REAKTIF ---
                      Obx(() => Text(
                        CurrencyFormatter.formatIDR(profileController.balance.value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed('/topup');
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Top Up'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
