import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio();

class AboutPage extends StatefulWidget {
  final dynamic about;

  const AboutPage({super.key, this.about});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List aboutText = [];
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      final response = await dio.get('http://localhost:1337/api/abouts');
      aboutText = response.data['data'];
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
        title: Text('Tentang Kami'),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        backgroundColor: Colors.transparent,
        actions: const [],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        padding: EdgeInsets.all(18.0),
        itemCount: aboutText.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (aboutText[index]['gambar']?['url'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'http://localhost:1337${aboutText[index]['gambar']['url']}',
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
                aboutText[index]['deskripsi'],
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
