import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-58a5a-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;

  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    if (product.id == null) {
      //es necesario crear
      // isSaving = true;
      await this.createProduct(product);
      notifyListeners();
    } else {
      // es necesario actualizar
      await this.updateProduct(product);
    }
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: json.encode(product.toJson()));
    final decodedData = json.decode(resp.body);
    //TODO actualizar el producto en la lista

    final index = products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;
    notifyListeners();

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: json.encode(product.toJson()));
    final decodedData = json.decode(resp.body);
    //TODO actualizar el producto en la lista

    product.id = decodedData['name'];

    this.products.add(product);
    notifyListeners();

    return '';
  }
}
