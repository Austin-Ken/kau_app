import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/currency_formatter.dart'; // Digunakan untuk notifikasi

class ProfileController extends GetxController {
  // Saldo pengguna diinisialisasi sebagai RxDouble agar reaktif
  final balance = 100000.0.obs; // Saldo awal yang lebih besar
  final isLoading = false.obs; // Status loading untuk simulasi Top Up

  // Controller untuk input nominal top-up di halaman TopupPage
  final topupInputController = TextEditingController();

  // --- Helper: Membersihkan input string untuk diubah menjadi double ---
  double _cleanInput(String input) {
    String cleanString = input.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(cleanString) ?? 0.0;
  }

  // --- Fungsi: Simulasi Top Up Saldo ---
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
    // Simulasi penundaan jaringan 2 detik
    await Future.delayed(const Duration(seconds: 2)); 
    
    // Proses penambahan saldo
    balance.value += amount;
    
    isLoading.value = false;
    topupInputController.clear();
    
    Get.back(); // Kembali ke halaman sebelumnya
    Get.snackbar(
      'Top Up Berhasil 🎉',
      'Saldo berhasil ditambahkan sebesar ${CurrencyFormatter.formatIDR(amount)}. Saldo Anda: ${CurrencyFormatter.formatIDR(balance.value)}.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // --- Fungsi: Logika Pembayaran Pesanan ---
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

    // Cek Saldo
    if (balance.value >= grandTotal) {
      // Saldo Mencukupi: Kurangi saldo
      balance.value -= grandTotal;
      
      Get.snackbar(
        'Pembayaran Berhasil! 💰',
        'Total ${CurrencyFormatter.formatIDR(grandTotal)} telah dibayarkan. Sisa saldo Anda: ${CurrencyFormatter.formatIDR(balance.value)}.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
      );
      return true;
    } else {
      // Saldo Kurang: Beri notifikasi
      final double shortfall = grandTotal - balance.value;
      Get.snackbar(
        'Saldo Kurang ⚠️',
        'Saldo Anda tidak mencukupi (${CurrencyFormatter.formatIDR(balance.value)}). Dibutuhkan ${CurrencyFormatter.formatIDR(shortfall)} lagi untuk membayar pesanan ini.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.yellow.shade700,
        colorText: Colors.black,
        duration: const Duration(seconds: 5),
      );
      return false;
    }
  }

  @override
  void onClose() {
    topupInputController.dispose();
    super.onClose();
  }
}
