import 'package:flutter/material.dart';

import '../models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'https://flutter-varios-58a5a-default-rtdb.firebaseio.com';

  final List<Product> products = [];

  //TODO: Hacer fetch de los productos
}
