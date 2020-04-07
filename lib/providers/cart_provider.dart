import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/models/user_model.dart';

class CartProvider extends ChangeNotifier {
  List<ProductModel> _cartProducts = [];
  List _merchants = [];
  List _amounts = [];
  List _images = [];

  List<ProductModel> _selectedCarts = [];
  var _selectedMerchant = '';
  var _selectedCourier;
  var _grossAmount;

  UserModel _seller;

  get cartProducts => _cartProducts;

  get merchants => _merchants;

  get amounts => _amounts;

  get images => _images;

  get selectedCarts => _selectedCarts;

  get selectedMerchant => _selectedMerchant;

  get selectedCourier => _selectedCourier;

  get seller => _seller;

  get grossAmount => _grossAmount;

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

  removeProduct(index) {
    var deletedMerchant = _cartProducts[index].merchant;
    _cartProducts.removeAt(index);
    bool isEmpty = true;
    _cartProducts.forEach((product) {
      if (product.merchant == deletedMerchant) {
        isEmpty = false;
      }
    });

    if (isEmpty) {
      _merchants.removeWhere((merchant) => merchant == deletedMerchant);
    }

    notifyListeners();
  }

  getTotalPrice(merchant) {
    var totalPrice = 0;
    var index = 0;
    _cartProducts.forEach((prod) {
      if (prod.merchant == merchant) {
        totalPrice += (prod.harga * amounts[index]);
      }
      index++;
    });
    return totalPrice;
  }

  getTotalWeight(merchant) {
    var totalWeight = 0;
    var index = 0;
    _cartProducts.forEach((prod) {
      if (prod.merchant == merchant) {
        totalWeight += (prod.berat * amounts[index]);
      }
      index++;
    });
    print(totalWeight);
    return totalWeight;
  }

  setSelected(merchant) {
    List<ProductModel> tempList = [];
    _cartProducts.forEach((prod) {
      if (prod.merchant == merchant) {
        tempList.add(prod);
      }
    });

    _selectedCarts = tempList;
    _selectedMerchant = merchant;
  }

  setSeller(userSeller) {
    _seller = userSeller;
  }

  setCourier(courier) {
    _selectedCourier = courier;
    print(courier);
    _grossAmount =
        getTotalPrice(_selectedMerchant) + courier['cost'][0]['value'];
  }

  cartNotifyListeners() {
    notifyListeners();
  }
}
