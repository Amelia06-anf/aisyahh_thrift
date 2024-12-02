class CartItem {
  final String id;
  final String nama;
  final num hargaAwal;
  final num hargaDiskon;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.nama,
    required this.hargaAwal,
    required this.hargaDiskon,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'hargaAwal': hargaAwal,
      'hargaDiskon': hargaDiskon,
      'imageUrl': imageUrl,
    };
  }
}
