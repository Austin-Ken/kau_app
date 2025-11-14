import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart'; 
import '../../helpers/currency_formatter.dart'; 

class TopupPage extends StatelessWidget {
  const TopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    Widget buildAmountChip(String amount) {
      // Menghilangkan format Rupiah dan titik agar fungsi addBalance bisa memproses
      String cleanAmount = amount.replaceAll('.', ''); 
      double value = double.tryParse(cleanAmount) ?? 0.0;

      return ActionChip(
        onPressed: () {
          // Panggil fungsi top up dengan string nominal yang bersih
          profileController.addBalance(cleanAmount);
        },
        label: Text(
          CurrencyFormatter.formatIDR(value).replaceAll('IDR', 'RP'),
          style: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Saldo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saldo Saat Ini
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Anda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Obx(() => Text(
                      CurrencyFormatter.formatIDR(profileController.balance.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    )),
                    const Divider()
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20,),
            
            // Pilihan Nominal Chip
            const Text(
              'Pilih Nominal Top Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12,),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: [
                buildAmountChip('10000'),
                buildAmountChip('20000'),
                buildAmountChip('50000'),
                buildAmountChip('100000'),
                buildAmountChip('250000'),
                buildAmountChip('500000'),
              ],
            ),
            
            const SizedBox(height: 24,),
            
            // Input Nominal Lain
            const Text(
              'Atau Masukan Nominal Lain',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12,),
            TextField(
              controller: profileController.topupInputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                hintText: ' Masukan Nominal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            
            const SizedBox(height: 24,),
            
            // Tombol Top Up Sekarang (dengan Loading State)
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: profileController.isLoading.value ? null : () {
                  // Panggil fungsi top up dengan string dari TextField
                  profileController.addBalance(profileController.topupInputController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: profileController.isLoading.value 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                    )
                  : const Text('Top Up Sekarang', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            )),
          ],
        ),
      )
    );
  }
}
