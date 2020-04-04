import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];

  get products => _products;

  setProducts(products) {
    _products = products;
  }

  getProductData(id) {
    var tempProduct;
    _products.forEach((product) {
      if (product.key == id) {
        tempProduct = product;
      }
      print(tempProduct);
    });
  }
}
