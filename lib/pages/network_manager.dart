import 'package:dio/dio.dart';
import 'package:ta_ppb_kwttmfreshmart/models/product.dart';

class NetworkManager {
  // ignore: unused_field
  late Dio _dio;

  NetworkManager() {
    _dio = Dio();
  }
  Future<ProdukModel> getAll() async {
    final response = await Dio().get(
      "http://localhost:1337/api/produks",
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
    return ProdukModel.fromJson(response.data);
  }
}
