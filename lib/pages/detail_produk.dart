import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProdukPage extends StatelessWidget {
  final dynamic produk;

  DetailProdukPage({required this.produk});

  // Fungsi untuk membuka WhatsApp
  void _launchWhatsApp() async {
    final phone = '+6285736958065'; // Ganti dengan nomor WhatsApp Anda
    final message = 'Halo kak, saya ingin pesan ${produk['nama']}';
    final url = 'https://wa.me/$phone?text=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menangani deskripsi
    final deskripsiText = produk['deskripsi'] ?? 'Deskripsi tidak tersedia';
    final gambarUrl = produk['gambar']?['url'];
    final fullGambarUrl =
        gambarUrl != null ? 'http://localhost:1337$gambarUrl' : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Products'),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: EdgeInsets.all(24.0),
        children: [
          // Nama Produk
          Text(
            produk['nama'] ?? 'Nama Produk Tidak Tersedia',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Gambar Produk
          if (fullGambarUrl != null)
            Center(
              child: Image.network(
                fullGambarUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Text('Gambar tidak dapat dimuat');
                },
              ),
            )
          else
            Text('Gambar tidak tersedia'),
          SizedBox(height: 16),
          // Deskripsi Produk
          Text(
            deskripsiText,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 16),
          // Tombol untuk order via WhatsApp
          Center(
            child: ElevatedButton(
              onPressed: _launchWhatsApp,
              child: Text('Order by WhatsApp'),
            ),
          ),
        ],
      ),
    );
  }
}
