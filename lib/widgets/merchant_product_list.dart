import 'package:flutter/material.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/widgets/product_cart.dart';
import 'package:provider/provider.dart';

class MerchantProductList extends StatelessWidget {
  var merchant;
  var enableButton;
  var index = 0;

  MerchantProductList(this.merchant, this.enableButton);

  @override
  Widget build(BuildContext context) {
    var carts = Provider.of<CartProvider>(context);

    return Column(
      children: carts.cartProducts.map<Widget>((cart) {
        if (cart.merchant == merchant) {
          return ProductCart(index, enableButton);
        }
        index++;
        return SizedBox();
      }).toList(),
    );
  }
}
