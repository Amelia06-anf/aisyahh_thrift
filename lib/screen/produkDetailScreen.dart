import 'package:aisyahh_store/cardProvider.dart';
import 'package:aisyahh_store/models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ProdukDetailScreen extends StatelessWidget {
  final String productId;

  ProdukDetailScreen({required this.productId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchProductDetail() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('produk').doc(productId).get();
      return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
    } catch (e) {
      debugPrint('Error fetching product detail: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProductDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Produk tidak ditemukan.'));
          }

          final product = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar produk
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product['imageUrl'] ?? 'https://via.placeholder.com/200',
                      height: 700,
                      width: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Nama produk
                Text(
                  product['nama'] ?? 'Nama tidak tersedia',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Harga produk
                _buildProductPrice(product),
                const SizedBox(height: 16),

                // Deskripsi produk
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product['deskripsi'] ?? 'Deskripsi tidak tersedia',
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 16),

                // Kondisi produk
                const Text(
                  'Kondisi Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kondisi: ${product['kondisi'] ?? 'Tidak diketahui'}',
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 16),

                // Ukuran produk
                const Text(
                  'Ukuran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product['ukuran'] ?? 'Ukuran tidak tersedia',
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 16),

                // Button Add to Cart
                Center(
                  child: ElevatedButton(
                    onPressed: () => _handleAddToCart(context, product),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Add To Cart'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductPrice(Map<String, dynamic> product) {
    if (product['sale'] == true && product['hargaDiskon'] != null) {
      return Row(
        children: [
          Text(
            'Rp ${product['hargaAwal']}',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Rp ${product['hargaDiskon']}',
            style: const TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      );
    }
    return Text(
      'Rp ${product['hargaAwal'] ?? '0'}',
      style: const TextStyle(
        color: Colors.brown,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  void _handleAddToCart(BuildContext context, Map<String, dynamic> product) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User tidak ditemukan! Harap login kembali.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final cartItem = CartItem(
      id: productId,
      nama: product['nama'] ?? 'Produk',
      hargaAwal: product['hargaAwal'] ?? 0,
      hargaDiskon: product['hargaDiskon'] ?? 0,
      imageUrl: product['imageUrl'] ?? '',
    );

    final isAlreadyInCart =
        cartProvider.cartItems.any((item) => item['id'] == cartItem.id);

    if (!isAlreadyInCart) {
      // Tambahkan item ke keranjang dan simpan ke Firestore
      cartProvider.addToCart(userId, cartItem.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil menambahkan ke keranjang!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk sudah ada di keranjang!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
