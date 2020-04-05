import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/widgets/product_card.dart';
import 'package:provider/provider.dart';

class CategoryProductScreen extends StatelessWidget {
  var _title;
  CategoryProductScreen(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: ListProducts(_title)),
          ),
        ),
      ),
    );
  }
}

class ListProducts extends StatelessWidget {
  final _title;
  ListProducts(this._title);

  @override
  Widget build(BuildContext context) {
    List<ProductModel> sortedProducts =
        Provider.of<ProductProvider>(context).products;
    sortedProducts.sort((a, b) {
      return (a.name.compareTo(b.name));
    });
    var index = 0;
    return Wrap(
      children: sortedProducts.map<Widget>((prod) {
        if (prod.category.contains(_title) && index < 20) {
          index++;
          return ProductCard(prod);
        } else
          return SizedBox();
      }).toList(),
    );
  }
}
