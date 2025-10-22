import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Formatter untuk menampilkan nilai mata uang (e.g., Rp 10.000)
  static final NumberFormat _displayFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0, // Tidak menggunakan desimal untuk Rupiah
  );

  /// Mengubah angka menjadi string format Rupiah untuk TAMPILAN di UI.
  /// Contoh: 1500000.00 menjadi "Rp1.500.000"
  static String formatIDR(dynamic value) {
    if (value == null) return 'Rp 0';
    // Menggunakan tryParse untuk menangani String atau int/double
    final num number = (value is String) 
      ? (num.tryParse(value) ?? 0)
      : (value as num);
      
    return _displayFormatter.format(number).replaceAll(',00', ''); 
    // Mengganti pengganda desimal default ',00' jika ada (opsional)
  }
}

/// [TextInputFormatter] untuk memformat input angka secara real-time 
/// saat user mengetik (tanpa 'Rp').
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('id');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Hapus semua pemisah ribuan dan desimal
    String newText = newValue.text.replaceAll('.', '').replaceAll(',', '');
    
    // Jika kosong, kembalikan kosong
    if (newText.isEmpty) return newValue.copyWith(text: '');

    // Coba parse menjadi integer
    final int? value = int.tryParse(newText);
    if (value == null) return oldValue; // Jika bukan angka, kembalikan nilai lama

    // 2. Format nilai integer
    final newString = _formatter.format(value);
    
    // 3. Kembalikan TextEditingValue baru dengan format ribuan
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
