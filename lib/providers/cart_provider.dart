import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  List<ProductModel> _cartProducts = [];
  List _merchants = [];
  List _amounts = [];
  List _images = [];

  get cartProducts => _cartProducts;

  get merchants => _merchants;

  get amounts => _amounts;

  get images => _images;

  addProduct(ProductModel product, amount, image) {
    var index = -1;

    _cartProducts.forEach((prod) {
      if (prod.key == product.key) {
        index++;
      }
    });

    if (index == -1) {
      _cartProducts.add(product);
      _merchants.add(product.merchant);
      _amounts.add(amount);
      _images.add(image);
    } else {
      _amounts[index] += amount;
    }

    var tempMerchant = _merchants.toSet().toList();
    _merchants = tempMerchant;

    notifyListeners();
  }
}
