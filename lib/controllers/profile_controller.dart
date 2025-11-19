import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/currency_formatter.dart'; 

class ProfileController extends GetxController {
  final balance = 100000.0.obs; 
  final isLoading = false.obs; 

  final topupInputController = TextEditingController();

  double _cleanInput(String input) {
    String cleanString = input.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(cleanString) ?? 0.0;
  }

  Future<void> addBalance(String amountString) async {
    final double amount = _cleanInput(amountString);

    if (amount < 10000) {
      Get.snackbar(
        'Top Up Gagal',
        'Nominal Top Up minimum adalah ${CurrencyFormatter.formatIDR(10000.0)}.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black87,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2)); 
    
    balance.value += amount;
    
    isLoading.value = false;
    topupInputController.clear();
    
    Get.back();
    Get.snackbar(
      'Top Up Berhasil',
      'Saldo berhasil ditambahkan sebesar ${CurrencyFormatter.formatIDR(amount)}. Saldo Anda: ${CurrencyFormatter.formatIDR(balance.value)}.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  bool payOrder(double grandTotal) {
    if (grandTotal <= 0) {
      Get.snackbar(
        'Pembayaran Gagal',
        'Jumlah total tidak valid.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (balance.value >= grandTotal) {
      balance.value -= grandTotal;
      
      Get.snackbar(
        'Pembayaran Berhasil!',
        'Total ${CurrencyFormatter.formatIDR(grandTotal)} telah dibayarkan. Sisa saldo Anda: ${CurrencyFormatter.formatIDR(balance.value)}.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
      );
      return true;
    } else {
      final double shortfall = grandTotal - balance.value;
      Get.snackbar(
        'Saldo Kurang',
        'Saldo Anda tidak mencukupi (${CurrencyFormatter.formatIDR(balance.value)}). Dibutuhkan ${CurrencyFormatter.formatIDR(shortfall)} lagi untuk membayar pesanan ini.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.yellow.shade700,
        colorText: Colors.black,
        duration: const Duration(seconds: 5),
      );
      return false;
    }
  }

  void processCOD(double totalAmount) {
     Get.snackbar(
        'Pembelian Berhasil!',
        'Pesanan senilai ${CurrencyFormatter.formatIDR(totalAmount)} berhasil diproses dengan metode COD. Pesanan akan segera dikirim.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
  }

  @override
  void onClose() {
    topupInputController.dispose();
    super.onClose();
  }
}