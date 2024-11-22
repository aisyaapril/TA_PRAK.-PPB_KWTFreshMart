import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'produk.dart';
import 'kegiatan.dart';

final dio = Dio();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  List activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch products (limited to 3)
      final productsResponse = await dio.get(
          'http://localhost:1337/api/authors?populate=*&pagination[limit]=4');
      products = productsResponse.data['data'];

      // Fetch activities
      final activitiesResponse =
          await dio.get('http://localhost:1337/api/kegiatans?populate=*');
      activities = activitiesResponse.data['data'];

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

  void openMaps(String location) {
    final Uri mapsUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}");
    launchUrl(mapsUri);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          // Flash Offer Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 244, 236, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Flash Offer!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Taste nature's freshness, \nnow available for you.",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProdukPage(
                                    produk: null,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 176, 231, 178),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Order"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16), // Jarak antara teks dan gambar
                    // Gambar sayur di samping kanan
                    const Icon(Icons.shopping_bag,
                        size: 50, color: Colors.green),
                    const Icon(Icons.eco, size: 50, color: Colors.green),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Products Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Produk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProdukPage(
                              produk: null,
                            )),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap:
                true, // Ensures the ListView takes only the required space
            physics:
                const NeverScrollableScrollPhysics(), // Disables scrolling within this ListView
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final fullGambarUrl =
                  'http://localhost:1337${product['gambar']['url']}';

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    fullGambarUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 50);
                    },
                  ),
                ),
                title: Text(product['nama'] ?? 'Produk Tidak Diketahui'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProdukPage(produk: product),
                      ),
                    );
                  },
                  child: const Text("Selengkapnya"),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Activities Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Kegiatan Tani",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KegiatanPage()),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap:
                true, // Ensures the ListView takes only the required space
            physics:
                const NeverScrollableScrollPhysics(), // Disables scrolling within this ListView
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final product = activities[index];
              final fullGambarUrl =
                  'http://localhost:1337${product['gambar']['url']}';

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    fullGambarUrl,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, size: 50);
                    },
                  ),
                ),
                title: Text(product['nama'] ?? 'Produk Tidak Diketahui'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KegiatanPage(),
                      ),
                    );
                  },
                  child: const Text("Selengkapnya"),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Location Section
          const Text(
            "Kunjungi Kami",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              openMaps("Jl. Belimbing Tertek Pare Kediri, Jawa Timur");
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 244, 236, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Jl. Belimbing Tertek Pare Kediri, Jawa Timur",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "WhatsApp: 085736958065",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
