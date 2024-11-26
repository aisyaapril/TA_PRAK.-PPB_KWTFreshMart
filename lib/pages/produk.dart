import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'detail_produk.dart';

final dio = Dio();

class ProdukPage extends StatefulWidget {
  final dynamic produk;

  const ProdukPage({super.key, this.produk});

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List produkList = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await dio.get('http://localhost:1337/api/authors');
      produkList = response.data['data'];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Tani'),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        actions: const [],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: produkList.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0, // Tinggi bayangan kartu
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailProdukPage(produk: produkList[index]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Nama Produk
                    Text(
                      produkList[index]['nama'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Gambar Produk (opsional)
                    if (produkList[index]['gambar']?['url'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'http://localhost:1337${produkList[index]['gambar']['url']}',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Gambar tidak tersedia');
                          },
                        ),
                      ),
                    const SizedBox(height: 18.0),

                    // Tombol "Detail Produk"
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailProdukPage(produk: produkList[index]),
                          ),
                        );
                      },
                      child: const Text('Detail Produk'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Jumlah kolom dalam grid
          crossAxisSpacing: 10, // Jarak horizontal antar kartu
          mainAxisSpacing: 10, // Jarak vertikal antar kartu
          childAspectRatio: 0.6, // Rasio lebar dan tinggi kartu,
        ),
      ),
    );
  }
}
