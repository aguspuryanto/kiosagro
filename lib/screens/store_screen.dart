import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/screens/cart_detail_screen.dart';
import 'package:kios_agro/screens/category_product_screen.dart';
import 'package:kios_agro/screens/search_screen.dart';
import 'package:kios_agro/widgets/product_card.dart';
import 'package:provider/provider.dart';

class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _height;

  StoreAppBar(this._height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Toko Anda'),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Toko Screen'),
    );
  }
}
