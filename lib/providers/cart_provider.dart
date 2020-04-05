import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<ProductModel> _cartProducts = [];
  List _merchants = [];

  get cartProducts => _cartProducts;

  get merchants => _merchants;

  addProduct(product) {
    _cartProducts.add(product);
    notifyListeners();
  }
}
