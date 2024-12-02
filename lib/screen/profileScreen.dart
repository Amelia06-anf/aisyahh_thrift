import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _userData;

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        _userData = doc.data();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _showEditForm(BuildContext context, String field, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Edit ${field[0].toUpperCase() + field.substring(1)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "Masukkan $field baru",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final user = _auth.currentUser;
                  if (user != null) {
                    await _firestore
                        .collection('users')
                        .doc(user.uid)
                        .update({field: controller.text.trim()});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data berhasil diperbarui")),
                    );
                    Navigator.pop(context);
                    _fetchUserData(); // Memuat ulang data setelah penyimpanan
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPasswordForm(BuildContext context) {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Ubah Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password Lama"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password Baru"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implementasi logika ubah password
                  Navigator.pop(context);
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
      ),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: const Text("Nama"),
                  subtitle: Text(_userData!['name'] ?? 'Tidak tersedia'),
                  trailing: const Icon(Icons.edit),
                  onTap: () =>
                      _showEditForm(context, "name", _userData!['name'] ?? ""),
                ),
                ListTile(
                  title: const Text("Jenis Kelamin"),
                  subtitle: Text(_userData!['gender'] ?? 'Tidak tersedia'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showEditForm(
                      context, "gender", _userData!['gender'] ?? ""),
                ),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(_userData!['email'] ?? 'Tidak tersedia'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showEditForm(
                      context, "email", _userData!['email'] ?? ""),
                ),
                ListTile(
                  title: const Text("Nomor Telepon"),
                  subtitle: Text(_userData!['phone'] ?? 'Tidak tersedia'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showEditForm(
                      context, "phone", _userData!['phone'] ?? ""),
                ),
                ListTile(
                  title: const Text("Password"),
                  subtitle: const Text("********"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    _showPasswordForm(context);
                  },
                ),
              ],
            ),
    );
  }
}
