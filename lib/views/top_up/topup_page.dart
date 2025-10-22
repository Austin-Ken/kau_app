import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopupPage extends StatelessWidget {
  const TopupPage({super.key});

  @override
  Widget build(BuildContext context) {

    Widget buildAmountChip(String amount) {
      return ActionChip(
        onPressed: () {
          Get.snackbar(
            'Nominal Dipilih', 
          'Anda memilih nominal Rp$amount',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          );
        },
        label: Text(
          'RP$amount',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
          side: const BorderSide(color: Colors.black12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Up Saldo'
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo Anda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      'RP10.000',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Divider()
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
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
                buildAmountChip('10.000'),
                buildAmountChip('20.000'),
                buildAmountChip('50.000'),
                buildAmountChip('100.000'),
                buildAmountChip('250.000'),
                buildAmountChip('500.000'),
              ],
            ),
            const SizedBox(height: 24,),
            const Text(
              'Atau Masukan Nominal Lain',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12,),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp',
                hintText: ' Masukan Nominal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Top Up Sekarang', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      )
    );
  }
}