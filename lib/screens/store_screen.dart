import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/screens/add_product_screen.dart';
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
    var user = Provider.of<UserProvider>(context);
    user.getUserData(user.user.key);

    return (user.user.verifyshop == false
        ? Center(
            child: Text(
              'Upgrade Penjual Terlebih Dahulu\ndi Halaman Akun',
              textAlign: TextAlign.center,
            ),
          )
        : ProductContent());
  }
}

class ProductContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<UserProvider>(context).user.products;

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            (products == null ? Container() : ProductList(products)),
            Center(
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductScreen()));
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tambah Produk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  var products;
  ProductList(this.products);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var listProduct = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.products.forEach((key, product) {
      print(product);
      listProduct.add(product);
    });
  }

  Future<void> deleteDialog(product) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Apakah anda ingin menghapus produk ini?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print(product['SKU']);
                FirebaseDatabase.instance
                    .reference()
                    .child('/products/${product['SKU']}')
                    .remove()
                    .then((value) => print('deleted'));

                FirebaseDatabase.instance
                    .reference()
                    .child(
                        '/users/${product['Merchant']}/products/${product['SKU']}')
                    .remove()
                    .then((value) => print('deleted from user'));

                FirebaseStorage.instance
                    .ref()
                    .child('/products/${product['SKU']}/1.jpeg')
                    .delete()
                    .then((value) {
                  print('deleted storage');
                });

                var tempList = [];
                listProduct.forEach((prod) {
                  if (prod['SKU'] != product['SKU']) {
                    tempList.add(prod);
                  }
                });
                setState(() {
                  listProduct = tempList;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);

    return Wrap(
      children: listProduct.map<Widget>((product) {
        print(product);
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
          ),
          child: ListTile(
            isThreeLine: true,
            leading: Container(
              width: 75,
              height: 50,
              child: Image.network(
                product['Image'][0],
                fit: BoxFit.fill,
              ),
            ),
            title: Text(product['Name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product['Deskripsi'].toString(),
                  overflow: TextOverflow.ellipsis,
                ),
                Text('Rp ${product['Harga'].toString()}'),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                deleteDialog(product);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
