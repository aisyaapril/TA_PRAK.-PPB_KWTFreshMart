import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  getHttp() async {
    final response = await dio.get('http://localhost:1337/api/kegiatans');
    kegiatanText = response.data['data'];
    setState(() {});
  }

  List kegiatanText = [];

  bool isLoading = false;

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    getHttp();
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan Kami'),
        actions: const [],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: EdgeInsets.all(18.0),
        itemCount: kegiatanText.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0, // Tinggi bayangan kartu
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    kegiatanText[index]['nama'],
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  if (kegiatanText[index]['gambar']?['url'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'http://localhost:1337${kegiatanText[index]['gambar']['url']}',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Gambar tidak tersedia');
                        },
                      ),
                    ),
                  SizedBox(height: 18.0),
                  Text(
                    kegiatanText[index]['deskripsi'],
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
