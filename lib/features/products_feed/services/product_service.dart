import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:task_eyego/features/products_feed/model/products_model.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductsModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      debugPrint(
          'Response status: ${response.statusCode}'); // Debug: Log status code
      debugPrint('Response body: ${response.body}'); // Debug: Log raw response
      if (response.statusCode == 200) {
        final List<dynamic> productList = jsonDecode(response.body);
        return productList.map((json) => ProductsModel.fromJson(json)).toList();
      } else {
        throw Exception(
            "Failed to Load products, Response code ${response.statusCode.toString()}");
      }
    } catch (e) {
      throw Exception('Error fetching products');
    }
  }
}
