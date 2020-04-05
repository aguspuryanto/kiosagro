import 'package:kios_agro/models/product_model.dart';

class CartModel {
  List<ProductModel> products = [];
  List amounts = [];
  List images = [];
  var merchant;

  CartModel({this.products, this.amounts, this.merchant, this.images});
}
