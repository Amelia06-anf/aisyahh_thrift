import 'package:aisyahh_store/cardProvider.dart';
import 'package:aisyahh_store/screen/accountScreen.dart';
import 'package:aisyahh_store/screen/cartScreen.dart';
import 'package:aisyahh_store/screen/produkDetailScreen.dart';
import 'package:aisyahh_store/screen/produkListScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchProducts({
    bool? sale,
    bool? popular,
    int limit = 2,
  }) async {
    try {
      Query query = _firestore.collection('produk');
      if (sale != null) query = query.where('sale', isEqualTo: sale);
      if (popular != null) query = query.orderBy('popular', descending: true);
      query = query.limit(limit);

      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        print('No products found');
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id, // Tambahkan ini untuk memastikan id selalu tersedia
          'nama': data['nama'],
          'merk': data['merk'],
          'hargaAwal': data['hargaAwal'],
          'hargaDiskon': data['hargaDiskon'],
          'sale': data['sale'] ?? false,
          'imageUrl': data['imageUrl'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    QuerySnapshot snapshot = await _firestore.collection('produk').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id, // Tambahkan ini untuk memastikan id selalu tersedia
        'nama': data['nama'],
        'merk': data['merk'],
        'hargaAwal': data['hargaAwal'],
        'hargaDiskon': data['hargaDiskon'],
        'sale': data['sale'] ?? false,
        'imageUrl': data['imageUrl'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int productCrossAxisCount =
        screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 6);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Produk',
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
              filled: true,
              fillColor: Colors.brown[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart,
                    color: Colors.grey), // Ikon keranjang
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Text(
                          '${cartProvider.cartItems.length}', // Menampilkan jumlah item di keranjang
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Navigasi ke CartScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(), // Navigasi ke CartScreen
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.brown),
            onPressed: () {
              // Navigasi ke halaman Account
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            _buildBanner(),

            // Produk Sale
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchProducts(sale: true, limit: productCrossAxisCount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tidak ada produk sale.'),
                  );
                }
                final saleProducts = snapshot.data!;
                return _buildProductSection(
                  context: context,
                  title: 'SALE',
                  products: saleProducts,
                  crossAxisCount: productCrossAxisCount,
                  isSale: true,
                );
              },
            ),

            // Produk Terlaris
            FutureBuilder<List<Map<String, dynamic>>>(
              future:
                  fetchProducts(popular: true, limit: productCrossAxisCount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Tidak ada produk terlaris.'),
                  );
                }
                final popularProducts = snapshot.data!;
                return _buildProductSection(
                  context: context,
                  title: 'Produk Terlaris',
                  products: popularProducts,
                  crossAxisCount: productCrossAxisCount,
                );
              },
            ),

            // Poster dan Brand
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/poster.png',
                      width: 300,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Brand - Brand Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildBrandLogo('assets/images/hm.png'),
                      _buildBrandLogo('assets/images/uniqlo.png'),
                      _buildBrandLogo('assets/images/zara.png'),
                      _buildBrandLogo('assets/images/pullbear.png'),
                      _buildBrandLogo('assets/images/mango.png'),
                      _buildBrandLogo('assets/images/bershka.png'),
                      _buildBrandLogo('assets/images/levis.png'),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Tidak ada produk yang tersedia.'),
                    );
                  }
                  final allProducts = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: productCrossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: allProducts.length,
                    itemBuilder: (context, index) {
                      final product = allProducts[index];
                      final isOnSale = product['sale'] ?? false;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProdukDetailScreen(
                                productId: product['id'],
                              ),
                            ),
                          );
                        },
                        child: Card(
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
                                    product['imageUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                                      product['nama'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      product['merk'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (isOnSale &&
                                        product['hargaDiskon'] != null)
                                      Row(
                                        children: [
                                          Text(
                                            'Rp ${product['hargaAwal'].toString()}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Rp ${product['hargaDiskon'].toString()}',
                                            style: const TextStyle(
                                              color: Colors.brown,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Text(
                                        'Rp ${product['hargaAwal'].toString()}',
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.brown[50],
          ),
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.brown,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home, color: Colors.blue),
          title: const Text('Home'),
          onTap: () {
            // Tutup drawer dan tetap di halaman home
            Navigator.pop(context);
          },
        ),
      ])),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 500,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image: AssetImage('assets/images/splash_screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: const Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hallo bestie,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Selamat Datang di Aisyah Thrift',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> products,
    required int crossAxisCount,
    bool isSale = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(
                        title: title,
                        sale: isSale,
                      ),
                    ),
                  );
                },
                child: const Text('See More'),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(
                context, // Kirim context
                product['nama'] ?? 'Nama Produk',
                product['merk'] ?? 'Tidak Ada Merk',
                product['hargaAwal'],
                product['hargaDiskon'],
                product['imageUrl'] ?? '',
                isSale,
                product, // Kirim data produk
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String nama,
    String merk,
    num hargaAwal,
    num? hargaDiskon,
    String imageUrl,
    bool isSale,
    Map<String, dynamic> product,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke ProdukDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetailScreen(productId: product['id']),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(
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
                    nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    merk,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (isSale && hargaDiskon != null)
                    Row(
                      children: [
                        Text(
                          'Rp ${hargaAwal.toString()}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rp ${hargaDiskon.toString()}',
                          style: const TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Rp ${hargaAwal.toString()}',
                      style: const TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart,
                        color: Colors.brown),
                    onPressed: () async {
                      final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';

                      // Data produk
                      final productData = {
                        'id': product['id'],
                        'nama': product['nama'],
                        'hargaAwal': product['hargaAwal'],
                        'hargaDiskon': product['hargaDiskon'],
                        'imageUrl': product['imageUrl'],
                      };

                      // Tambahkan produk ke keranjang
                      await cartProvider.addToCart(userId, productData);

                      // Tampilkan notifikasi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Produk ditambahkan ke keranjang!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogo(String assetPath) {
    return Image.asset(
      assetPath,
      width: 50,
      height: 50,
    );
  }
}
