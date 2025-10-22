import 'package:get/get.dart';
import '../controllers/produk_controller.dart';
import '../controllers/cart_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ProdukController>(ProdukController());
    Get.put<CartController>(CartController()); 
  }
}
