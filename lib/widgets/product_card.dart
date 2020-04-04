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
                    future: _getImage(context, 'wortel.jpg'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        image = snapshot.data;

                        return snapshot.data;
                      }

                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();

                      return Icon(
                        Icons.image,
                        color: Colors.greenAccent[100],
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

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.fill,
      );
    });

    return m;
  }
}
