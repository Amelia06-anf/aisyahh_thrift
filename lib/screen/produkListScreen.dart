import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final bool? sale;
  final bool? popular;

  ProductListScreen({required this.title, this.sale, this.popular});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengambil data produk
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    Query query = _firestore.collection('produk');
    if (widget.sale != null)
      query = query.where('sale', isEqualTo: widget.sale);
    if (widget.popular != null)
      query = query.orderBy('popular', descending: true);

    QuerySnapshot snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'nama': data['nama'],
        'merk': data['merk'],
        'hargaAwal': data['hargaAwal'],
        'hargaDiskon': data['hargaDiskon'],
        'imageUrl': data['imageUrl'],
        'sale': data['sale'] ?? false,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan jumlah kolom berdasarkan lebar layar
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600
        ? 2 // Tampilan mobile
        : (screenWidth < 900 ? 3 : 5); // Tampilan tablet & desktop

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.brown,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada produk ditemukan.'));
          }
          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Jumlah kolom berdasarkan layar
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75, // Rasio tampilan produk
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          product['imageUrl'] ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['nama'] ?? 'Nama Produk',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            product['merk'] ?? 'Tidak Ada Merk',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (product['sale'] && product['hargaDiskon'] != null)
                            Row(
                              children: [
                                Text(
                                  'Rp ${product['hargaAwal']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rp ${product['hargaDiskon']}',
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              'Rp ${product['hargaAwal']}',
                              style: const TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
