import 'package:aisyahh_store/cardProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AccountScreen({super.key});

  void _logout(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    try {
      // Proses logout
      await _auth.signOut();

      // Kosongkan keranjang di aplikasi
      await cartProvider.clearCart(_auth.currentUser?.uid ?? "");

      // Navigasi ke halaman SplashScreen
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

      // Notifikasi logout berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil logout')),
      );
    } catch (e) {
      // Notifikasi jika terjadi kesalahan saat logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text("Order"),
            onTap: () {
              Navigator.pushNamed(context, '/order');
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Alamat"),
            onTap: () {
              Navigator.pushNamed(context, '/address');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text("Pembayaran"),
            onTap: () {
              Navigator.pushNamed(context, '/payment');
            },
          ),
          const Divider(), // Pemisah
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Tampilkan dialog konfirmasi sebelum logout
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Apakah Anda yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout(context); // Panggil fungsi logout
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
