import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _popularProduct = [];

  get products => _products;

  get popularProduct => _popularProduct;

  setProducts(products) {
    _products = products;
    var sortedProducts = products;
    sortedProducts.sort((a, b) {
      return (a.priority.toString().compareTo(b.priority.toString()));
    });
    List<ProductModel> tempPopularProduct = [];
    for (int i = 0; i < 6; i++) {
      tempPopularProduct.add(sortedProducts[i]);
    }
    _popularProduct = tempPopularProduct;
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
