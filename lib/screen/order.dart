import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatelessWidget {
  final String userId =
      "OPqCjmRkhSh9TMz3BjV0MhAyHLO2"; // Ganti dengan user ID yang relevan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('order')
            .orderBy('item',
                descending: true) // Mengurutkan berdasarkan tanggal
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada pesanan.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.brown.shade200),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['id'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Divider(
                        color: Colors.brown.shade200,
                        height: 20.0,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Status Pesanan  ',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey.shade700),
                          children: [
                            TextSpan(
                              text: order['status'] ?? '',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Jumlah Barang  ${order['items'] ?? 0} Barang Terbeli',
                        style: TextStyle(
                            fontSize: 14.0, color: Colors.grey.shade700),
                      ),
                      SizedBox(height: 8.0),
                      Text.rich(
                        TextSpan(
                          text: 'Harga  ',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey.shade700),
                          children: [
                            TextSpan(
                              text:
                                  'Rp. ${order['price']?.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
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
    );
  }
}

void main() => runApp(MaterialApp(
      home: OrderScreen(),
    ));
