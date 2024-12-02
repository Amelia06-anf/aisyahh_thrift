import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentPage = 1; // Halaman saat ini
  final int _itemsPerPage = 10; // Jumlah data per halaman
  late List<DocumentSnapshot> _products; // Data produk yang akan dipaginasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Main Content
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Dashboard", style: TextStyle(fontSize: 20)),
          _buildAppBarActions(),
        ],
      ),
    );
  }

  Row _buildAppBarActions() {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: Colors.white),
        const SizedBox(width: 8),
        const Text(
          "Oct 25, 2024 - Nov 25, 2024",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          underline: const SizedBox(),
          dropdownColor: Colors.brown[300],
          icon: const Icon(Icons.account_circle, color: Colors.white),
          items: const [
            DropdownMenuItem(
              value: "admin",
              child: Text("Admin", style: TextStyle(color: Colors.white)),
            ),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  // Sidebar
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.brown,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Aisyah Thrift",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Divider(color: Colors.white70),
          _SidebarItem(title: "Dashboard", icon: Icons.dashboard),
          _SidebarItem(title: "Data Pesanan", icon: Icons.shopping_cart),
          _SidebarItem(title: "Data Produk Keluar", icon: Icons.exit_to_app),
          _SidebarItem(title: "Stok Produk", icon: Icons.inventory),
        ],
      ),
    );
  }

  // Main Content
  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Home > Dashboard",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildDashboardCards(),
            const SizedBox(height: 32),
            _buildTableCard(
              title: "Tabel Pesanan",
              dataTable: _buildPesananDataTable(),
            ),
            const SizedBox(height: 32),
            // Replace Row with Column to stack the tables vertically
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTableCard(
                  title: "Tabel Stok Produk",
                  dataTable: _buildStokProdukDataTable(),
                ),
                const SizedBox(height: 32),
                _buildTableCard(
                  title: "Tabel Produk Keluar",
                  dataTable: _buildProdukKeluarDataTable(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // First Card - Data Pesanan
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data Pesanan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Total Pesanan",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "↑ 80 Pesanan Baru",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Print Button
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        html.window.print(); // Open the print dialog
                      },
                      child: const Text("Print Data"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Second Card - Data Produk Keluar
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Data Produk Keluar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Produk Terjual",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "↑ 200 Produk Terjual",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Print Button
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        html.window.print(); // Open the print dialog
                      },
                      child: const Text("Print Data"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Third Card - Stok Produk from Firebase
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('produk')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text("Stok Produk: 0");
                    }

                    final products = snapshot.data!.docs;
                    final totalStok = products.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Stok Produk",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Jumlah Stok",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "↑ $totalStok Produk Tersedia",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            _printProducts(
                                products); // Panggil fungsi untuk mencetak data produk
                          },
                          child: const Text("Print Data"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// Fungsi untuk mencetak data produk dalam bentuk PDF

  void _printProducts(List<QueryDocumentSnapshot> products) async {
    final pdf = pw.Document();

    // Header tabel
    final tableHeaders = [
      "ID Produk",
      "Nama Barang",
      "Merk",
      "Harga Awal",
      "Harga Diskon",
    ];

    // Data tabel
    final tableData = products.map((product) {
      return [
        product.id,
        product['nama'] ?? 'N/A',
        product['merk'] ?? 'N/A',
        product['hargaAwal'].toString(),
        product['hargaDiskon'].toString(),
      ];
    }).toList();

    // Tambahkan halaman PDF dengan tabel
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text("Daftar Stok Produk",
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tableData,
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerDecoration: pw.BoxDecoration(
              color: PdfColor.fromHex("#eeeeee"),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: pw.FixedColumnWidth(50), // ID Produk
              1: pw.FlexColumnWidth(), // Nama Barang
              2: pw.FlexColumnWidth(), // Merk
              3: pw.FixedColumnWidth(70), // Harga Awal
              4: pw.FixedColumnWidth(70), // Harga Diskon
            },
          ),
          pw.SizedBox(height: 20),
          pw.Text("Total Produk: ${products.length}",
              style: pw.TextStyle(fontSize: 16)),
        ],
      ),
    );

    // Cetak PDF atau simpan ke file
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Table Card
  Widget _buildTableCard({
    required String title,
    required Widget dataTable,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            dataTable,
          ],
        ),
      ),
    );
  }

  // Pesanan Data Table
  Widget _buildPesananDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text("ID Pesanan")),
        DataColumn(label: Text("Nama Pelanggan")),
        DataColumn(label: Text("Tanggal Pesanan")),
        DataColumn(label: Text("Status Pengiriman")),
        DataColumn(label: Text("Total Harga")),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text("12345")),
          DataCell(Text("John Doe")),
          DataCell(Text("2024-11-25")),
          DataCell(Text("Delivered")),
          DataCell(Text("Rp 250,000")),
        ]),
        DataRow(cells: [
          DataCell(Text("12346")),
          DataCell(Text("Jane Doe")),
          DataCell(Text("2024-11-26")),
          DataCell(Text("In Process")),
          DataCell(Text("Rp 150,000")),
        ]),
      ],
    );
  }

  // Fungsi untuk mengambil data produk yang relevan berdasarkan halaman aktif
  List<DocumentSnapshot> _paginateData(List<DocumentSnapshot> data) {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    return data.sublist(
        startIndex, endIndex < data.length ? endIndex : data.length);
  }

// Fungsi untuk berpindah ke halaman berikutnya
  void _nextPage() {
    setState(() {
      if (_currentPage < (_products.length / _itemsPerPage).ceil()) {
        _currentPage++;
      }
    });
  }

// Fungsi untuk kembali ke halaman sebelumnya
  void _previousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

// Fungsi untuk menampilkan tabel produk dengan pagination
  Widget _buildStokProdukDataTable() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('produk')
          .orderBy('nama') // Mengurutkan produk berdasarkan nama
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        var data = snapshot.data!.docs;

        // Memanggil fungsi pagination untuk mendapatkan data yang relevan
        var paginatedData = _paginateData(data);

        // Inisialisasi _products di sini jika diperlukan (misalnya untuk jumlah halaman)
        _products = data; // Menyimpan data ke _products

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('ID Produk')),
                DataColumn(label: Text('Nama Barang')),
                DataColumn(label: Text('Merk')),
                DataColumn(label: Text('Harga Awal')),
                DataColumn(label: Text('Harga Diskon')),
                DataColumn(label: Text('Gambar Produk')),
              ],
              rows: paginatedData.map<DataRow>((doc) {
                var produk = doc.data() as Map<String, dynamic>;
                var imageUrl = produk['imageUrl'] ?? '';
                return DataRow(cells: [
                  DataCell(Text(doc.id ?? 'N/A')),
                  DataCell(Text(produk['nama'] ?? 'N/A')),
                  DataCell(Text(produk['merk'] ?? 'N/A')),
                  DataCell(Text(produk['hargaAwal'].toString() ?? 'N/A')),
                  DataCell(Text(produk['hargaDiskon'].toString() ?? 'N/A')),
                  DataCell(
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 50, // lebar kotak gambar
                            height: 50, // tinggi kotak gambar
                            fit: BoxFit
                                .cover, // agar gambar tetap terpotong dengan proporsional
                          )
                        : const Text('No image'),
                  )
                ]);
              }).toList(),
            ),
            // Pagination Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                      _currentPage > 1 ? _previousPage : null, // Previous page
                ),
                Text('Page $_currentPage'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed:
                      _currentPage < (_products.length / _itemsPerPage).ceil()
                          ? _nextPage
                          : null, // Next page
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Produk Keluar Data Table
  Widget _buildProdukKeluarDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text("ID Produk")),
        DataColumn(label: Text("Nama Produk")),
        DataColumn(label: Text("Jumlah Terjual")),
        DataColumn(label: Text("Tanggal Terjual")),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text("12345")),
          DataCell(Text("Produk A")),
          DataCell(Text("50")),
          DataCell(Text("2024-11-25")),
        ]),
        DataRow(cells: [
          DataCell(Text("12346")),
          DataCell(Text("Produk B")),
          DataCell(Text("30")),
          DataCell(Text("2024-11-26")),
        ]),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
