import 'package:flutter/material.dart';

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
