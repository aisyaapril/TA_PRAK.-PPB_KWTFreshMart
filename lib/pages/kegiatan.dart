import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class KegiatanPage extends StatefulWidget {
  const KegiatanPage({super.key});

  @override
  _KegiatanPageState createState() => _KegiatanPageState();
}

class _KegiatanPageState extends State<KegiatanPage> {
  List kegiatanText = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await dio.get('http://localhost:1337/api/kegiatans');
      kegiatanText = response.data['data'];
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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan Tani'),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
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
