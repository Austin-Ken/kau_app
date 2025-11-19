import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _displayFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatIDR(dynamic value) {
    if (value == null) return 'Rp 0';
    final num number = (value is String) 
      ? (num.tryParse(value) ?? 0)
      : (value as num);
      
    return _displayFormatter.format(number).replaceAll(',00', ''); 
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
    String newText = newValue.text.replaceAll('.', '').replaceAll(',', '');
    
    if (newText.isEmpty) return newValue.copyWith(text: '');

    final int? value = int.tryParse(newText);
    if (value == null) return oldValue;

    final newString = _formatter.format(value);
    
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
