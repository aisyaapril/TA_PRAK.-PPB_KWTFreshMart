import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../pages/home.dart';
import '../pages/about.dart';
import '../pages/kegiatan.dart';
import '../pages/produk.dart';

final dio = Dio();

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  List logos = [];

  // List halaman untuk setiap tab
  final List<Widget> _pages = [
    HomePage(),
    AboutPage(),
    KegiatanPage(),
    ProdukPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch products (limited to 4)
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {});
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman berdasarkan tab aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            Colors.green, // Warna ikon dan teks untuk item yang dipilih
        unselectedItemColor:
            Colors.grey, // Warna ikon dan teks untuk item yang tidak dipilih
        backgroundColor:
            Colors.white, // Warna latar belakang BottomNavigationBar
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Products',
          ),
        ],
      ),
    );
  }
}
