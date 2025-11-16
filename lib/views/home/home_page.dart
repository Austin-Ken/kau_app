import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kau_app/controllers/produk_controller.dart';
import 'package:kau_app/data/app_data.dart';
import 'package:kau_app/helpers/currency_formatter.dart'; // Import Formatter yang baru

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildCategoryIcon(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.red),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Memastikan controller sudah diinisialisasi atau dicari (diasumsikan sudah ada di Get.put/binding)
    final ProdukController produkController = Get.find<ProdukController>(); 

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade700, 
        elevation: 0.5, 
        title: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigasi ke halaman pencarian
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
              // Navigasi ke halaman keranjang
              Get.toNamed('/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 190.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 8), 
                viewportFraction: 1.0,
                enlargeCenterPage: false, // Memastikan gambar mengisi penuh lebar
              ),
              items: imgList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // Menggunakan Image.asset
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 100, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Kategori Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: <Widget>[
                  _buildCategoryIcon(Icons.shopping_bag, 'Fashion'),
                  _buildCategoryIcon(Icons.phone_android, 'Elektronik'),
                  _buildCategoryIcon(Icons.food_bank, 'Makanan'),
                  _buildCategoryIcon(Icons.sports_soccer, 'Olahraga'),
                  _buildCategoryIcon(Icons.spa, 'Kecantikan'),
                  _buildCategoryIcon(Icons.home, 'Rumah Tangga'),
                ],
              ),
            ),

            // Produk Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Untuk Kamu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () {
                  if (produkController.isLoading.isTrue) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  }
                  if (produkController.produkList.isEmpty) {
                      return const Center(
                       child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text("Tidak ada produk tersedia saat ini."),
                        ),
                      );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produkController.produkList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final data = produkController.produkList[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigasi ke detail produk
                          Get.toNamed('/produk', arguments: data);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  // Menggunakan Image.network untuk gambar produk
                                  child: Image.network(
                                    data.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title, 
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2, 
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Menggunakan CurrencyFormatter
                                    Text(
                                      CurrencyFormatter.formatIDR(data.price),
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber, size: 14),
                                        Text('${data.rating.rate}', style: const TextStyle(fontSize: 12)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
