import 'package:aisyahh_store/screen/addressForm.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showAddAddressForm = false;

  // Fungsi untuk mendapatkan userId pengguna yang sedang login
  String? get userId => _auth.currentUser?.uid;

  // Fungsi untuk mengambil daftar alamat dari Firestore
  Stream<QuerySnapshot> getAddresses() {
    if (userId == null) {
      return const Stream
          .empty(); // Jika tidak ada pengguna login, kembalikan stream kosong
    }
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .snapshots();
  }

  // Fungsi untuk menambah alamat baru ke Firestore
  Future<void> addAddress(Map<String, dynamic> addressData) async {
    if (userId == null) {
      debugPrint('Pengguna tidak login');
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .add(addressData);
      setState(() {
        _showAddAddressForm = false; // Tutup form setelah berhasil menambahkan
      });
    } catch (e) {
      debugPrint('Gagal menambahkan alamat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ship To"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _showAddAddressForm =
                    !_showAddAddressForm; // Tampilkan atau sembunyikan form
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Daftar alamat
          StreamBuilder<QuerySnapshot>(
            stream: getAddresses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('Belum ada alamat yang ditambahkan.'));
              }

              final addresses = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address =
                      addresses[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address['firstName'] ?? 'Nama Tidak Tersedia',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(address['addressLine1'] ?? ''),
                          Text(address['addressLine2'] ?? ''),
                          Text('${address['city']}, ${address['province']}'),
                          Text('Kode Pos: ${address['postalCode']}'),
                          Text('Telp: ${address['phone']}'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Logika edit alamat
                                },
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Logika hapus alamat
                                  addresses[index].reference.delete();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Form tambah alamat
          if (_showAddAddressForm)
            AddAddressForm(
              onSave:
                  addAddress, // Panggil fungsi addAddress saat form disimpan
              onCancel: () {
                setState(() {
                  _showAddAddressForm = false; // Tutup form
                });
              },
            ),
        ],
      ),
    );
  }
}
