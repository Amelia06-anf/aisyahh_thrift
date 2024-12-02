import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _cartItems = [];

  // Getter untuk daftar item di keranjang
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Getter untuk total harga item di keranjang
  double get totalPrice => _cartItems.fold(
        0,
        (total, item) => total + (item['hargaDiskon'] ?? item['hargaAwal']),
      );

  // Menambahkan item ke keranjang
  Future<void> addToCart(String userId, Map<String, dynamic> item) async {
    // Cek apakah item sudah ada di keranjang
    final existingItemIndex =
        _cartItems.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (existingItemIndex != -1) {
      debugPrint('Item dengan ID ${item['id']} sudah ada di keranjang.');
      return;
    }

    // Tambahkan item ke daftar lokal
    _cartItems.add(item);
    notifyListeners();

    // Simpan data ke Firestore
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item['id'])
          .set(item);
    } catch (e) {
      debugPrint('Gagal menyimpan item ke Firestore: ${item['id']}, error: $e');
    }

    // Simpan juga ke SharedPreferences
    await saveCartToLocalStorage();
  }

  // Menghapus item dari keranjang
  Future<void> removeFromCart(String userId, String id) async {
    _cartItems.removeWhere((item) => item['id'] == id);
    notifyListeners();

    // Hapus data dari Firestore
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint('Gagal menghapus item dari Firestore: $id, error: $e');
    }

    // Perbarui SharedPreferences
    await saveCartToLocalStorage();
  }

  // Membersihkan semua item di keranjang
  Future<void> clearCart(String userId) async {
    _cartItems.clear();
    notifyListeners();

    // Hapus semua data di Firestore
    try {
      final cartCollection =
          _firestore.collection('users').doc(userId).collection('cart');
      final cartDocs = await cartCollection.get();
      for (var doc in cartDocs.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint('Gagal menghapus semua item dari Firestore: $e');
    }

    // Hapus data dari SharedPreferences
    await saveCartToLocalStorage();
  }

  // Simpan data keranjang ke SharedPreferences
  Future<void> saveCartToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final cartData = json.encode(_cartItems);
      await prefs.setString('cart_items', cartData);
    } catch (e) {
      debugPrint('Gagal menyimpan keranjang ke SharedPreferences: $e');
    }
  }

  // Muat data keranjang dari SharedPreferences
  Future<void> loadCartFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final cartData = prefs.getString('cart_items');
      if (cartData != null) {
        final List<dynamic> decodedData = json.decode(cartData);
        _cartItems = List<Map<String, dynamic>>.from(decodedData);
      }
    } catch (e) {
      debugPrint('Gagal memuat keranjang dari SharedPreferences: $e');
      _cartItems = [];
    }
    notifyListeners();
  }

  // Muat data keranjang dari Firestore
  Future<void> loadCartFromFirestore(String userId) async {
    try {
      final cartDocs = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      _cartItems = cartDocs.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Gagal memuat keranjang dari Firestore: $e');
    }
  }

  // Sinkronkan data keranjang dari Firestore dan SharedPreferences
  Future<void> syncCart(String userId) async {
    try {
      // Muat data dari Firestore
      await loadCartFromFirestore(userId);

      // Simpan ke SharedPreferences
      await saveCartToLocalStorage();
    } catch (e) {
      debugPrint('Gagal menyinkronkan keranjang: $e');
    }
  }
}
