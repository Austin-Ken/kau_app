import 'package:get/get.dart';
import '../models/product_model.dart';
import 'dart:convert';

const String baseUrl = 'https://a5462a5b-30fc-4dc8-b8d0-394b99e0ec11.mock.pstmn.io';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 15);
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await get('/products');

    if (response.statusCode == 200) {
      // 1. Ambil body sebagai String (aman)
      final String? rawBody = response.bodyString;

      if (rawBody == null || rawBody.isEmpty) {
         throw Exception('Respons body dari API kosong.');
      }

      try {
        // PERBAIKAN UTAMA: Dekode String secara manual menjadi List<dynamic>
        final decodedBody = jsonDecode(rawBody);

        // 2. Memastikan decodedBody adalah List (array)
        if (decodedBody is List) {
          final List<dynamic> responseBody = decodedBody;
          
          // Mapping List<dynamic> ke List<ProductModel>
          final List<ProductModel> products = responseBody
              .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
              .toList();
              
          return products;
        } else {
           // Jika respons 200, tetapi isinya bukan List (misal: Object {})
           throw Exception('Format data respons API tidak sesuai. Expected: JSON List, Received: ${decodedBody.runtimeType}.');
        }
      } catch (e) {
          // Tangani kesalahan JSON parse (misal: respons bukan JSON)
          throw Exception('Gagal mengurai respons JSON: ${e.toString()}');
      }

    } else {
      // Melempar exception jika status code bukan 200
      String errorMessage = response.statusText ?? 'Kesalahan tidak diketahui.';
      if (response.bodyString != null && response.bodyString!.isNotEmpty) {
          // Tambahkan pesan error dari server jika ada
          errorMessage = 'Server merespons: ${response.bodyString}';
      }
      throw Exception('Gagal memuat produk dari API. Status: ${response.statusCode}. Detail: $errorMessage');
    }
  }
}
