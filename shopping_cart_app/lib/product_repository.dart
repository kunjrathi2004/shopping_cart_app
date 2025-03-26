import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class ProductRepository {
  final String apiUrl = 'https://dummyjson.com/products';

  Future<List<Product>> fetchProducts(int page) async {
    final response = await http.get(Uri.parse('$apiUrl?limit=10&skip=${(page - 1) * 10}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['products'] as List)
          .map((product) => Product(
                name: product['name'],
                price: product['price'] * (1 - product['discountPercentage'] / 100),
              ))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
