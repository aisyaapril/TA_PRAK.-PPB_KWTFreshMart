import 'package:flutter/material.dart';
import 'package:ta_ppb_kwttmfreshmart/pages/detail_produk.dart';
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
    final slugList = ['pepaya', 'tomat', 'timun', 'sawi', 'cabai-merah'];

    try {
      // Fetch products (limited to 4)
      final productsResponse = await dio.get(
        'http://localhost:1337/api/authors',
      );
      products = productsResponse.data['data'];
      products = products
          .where((product) => slugList.contains(product['slug']))
          .toList();

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Taste Nature's Freshness, \nNow Available for You.",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Order",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                  width: 8), // Jarak antara teks dan ikon
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProdukPage(),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  size: 25,
                                  color: Colors.green,
                                ),
                              ),
                            ],
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
                      builder: (context) => const ProdukPage(),
                    ),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
          SizedBox(
            height: 180, // Tinggi area untuk card produk
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Membuat scroll horizontal
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final fullGambarUrl =
                    'http://localhost:1337${product['gambar']['url']}';

                return Card(
                  margin: const EdgeInsets.only(right: 16), // Jarak antar card
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailProdukPage(produk: product),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 130, // Lebar tiap card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              fullGambarUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product['nama'] ?? 'Produk Tidak Diketahui',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailProdukPage(produk: product),
                                      ),
                                    );
                                  },
                                  child: const Text("Detail"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                    MaterialPageRoute(
                        builder: (context) => const KegiatanPage()),
                  );
                },
                child: const Text("See All"),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap:
                true, //Memastikan ListView hanya mengambil ruang yang diperlukan
            physics:
                const NeverScrollableScrollPhysics(), //Menonaktifkan scroll dalam ListView
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final fullGambarUrl =
                  'http://localhost:1337${activity['gambar']['url']}';
              return ListTile(
                contentPadding: const EdgeInsets.all(4.0), //jarak antar konten
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
                title: Text(activity['nama'] ?? 'Produk Tidak Diketahui'),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(249, 244, 236, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Jarak di antara elemen
              children: [
                // Kolom teks di sisi kiri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.maps_home_work_outlined,
                          size: 20,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            openMaps(
                                "Jl. Belimbing Tertek Pare Kediri, Jawa Timur");
                          },
                          child: Text(
                            "Jl. Belimbing Tertek Pare Kediri, Jawa Timur",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "WhatsApp: 085736958065",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                // Gambar di sisi kanan
                Image.network(
                  'http://localhost:1337/uploads/logo_KWT_fd10808a2d.png',
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
