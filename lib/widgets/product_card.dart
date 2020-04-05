import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/screens/detail_product_screen.dart';
import 'package:kios_agro/storage/fire_storage_services.dart';

class ProductCard extends StatefulWidget {
  ProductModel product;

  ProductCard(this.product);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  var image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailProductScreen(widget.product, image)));
      },
      child: Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 5 - 40,
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 2 - 40,
                child: Center(
                  child: FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref()
                        .child('/products/${widget.product.key}/1.jpeg')
                        .getDownloadURL()
                        .then((value) => value)
                        .catchError((e) {
                      print('error coi');
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('error');
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          print('ada error');
                        }
                        if (snapshot.hasData) {
                          image = Image.network(
                            snapshot.data,
                            fit: BoxFit.fill,
                          );
                          return image;
                        } else {
                          image = Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.greenAccent[100],
                          );
                        }
                      }

                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();

                      return Icon(
                        Icons.image,
                        color: Colors.greenAccent[100],
                        size: 100,
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  widget.product.kota,
                  style: TextStyle(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  'Rp ${widget.product.harga}',
                  style: TextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
