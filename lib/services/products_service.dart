import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-58a5a-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  late Product selectedProduct;
  File? newPictureFile;
  final storage = FlutterSecureStorage();

  bool isLoading = true;

  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromRawJson(value);
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

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: json.encode(product.toJson()));
    final decodedData = json.decode(resp.body);
    //TODO actualizar el producto en la lista

    final index = products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;
    notifyListeners();

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: json.encode(product.toJson()));
    final decodedData = json.decode(resp.body);
    //TODO actualizar el producto en la lista

    product.id = decodedData['name'];

    this.products.add(product);
    notifyListeners();

    return '';
  }

  void uodateSelectedProductImage(String path) {
    this.selectedProduct.picture = path;
    this.newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dxgckodih/image/upload?upload_preset=xrlmacpy');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', this.newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
    print(resp.body);
  }
}
