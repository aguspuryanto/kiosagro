import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/screens/detail_product_screen.dart';

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
        width: MediaQuery.of(context).size.width / 3,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 5 - 40,
                margin: EdgeInsets.all(10),
                child: Center(
                  child: FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref()
                        .child('/products/${widget.product.key}/1.jpeg')
                        // .child('brocolli.jpg')
                        .getDownloadURL()
                        .then((value) => value)
                        .catchError((e) {
                      // print('error coi');
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          print('ada error');
                        }
                        if (snapshot.hasData) {
                          image = CachedNetworkImage(
                            imageUrl: snapshot.data,
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
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Text(
                  'Rp ${widget.product.harga}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
