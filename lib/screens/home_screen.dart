import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/auth_provider.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/screens/cart_detail_screen.dart';
import 'package:kios_agro/screens/category_product_screen.dart';
import 'package:kios_agro/screens/search_screen.dart';
import 'package:kios_agro/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _height;

  HomeAppBar(this._height);

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);
    var auth = Provider.of<AuthProvider>(context);

    print('uid: ${auth.user.uid}');

    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: TextFormField(
              enabled: false,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari Beras',
                hintStyle: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Stack(children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartDetailScreen()));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 5,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: Text(
                  cart.cartProducts.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_height);
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<ProductProvider>(context);
    var auth = Provider.of<AuthProvider>(context);

    return StreamBuilder(
      stream: FirebaseDatabase().reference().child('products').onValue,
      builder: (context, snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          Map data = snap.data.snapshot.value;
          List<ProductModel> list = [];

          data.forEach((key, value) {
            list.add(ProductModel.fromSnapshot(key, value));
          });

          products.setProducts(list);

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                BannerSlider(),
                SizedBox(
                  height: 20,
                ),
                CategoryList(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'PRODUK TERLARIS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopularListProducts(products: products),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'PRODUK TERBARU',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                NewListProducts(products: products)
              ],
            ),
          );
        } else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class BannerSlider extends StatefulWidget {
  const BannerSlider({
    Key key,
  }) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  var _carouselIndex = 0;

  Widget indicator(int idx) {
    var size = (idx == _carouselIndex ? 16.0 : 8.0);
    var color = (idx == _carouselIndex ? Colors.green : Colors.grey);

    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          viewportFraction: 1.0,
          autoPlay: true,
          onPageChanged: (idx) {
            setState(() {
              _carouselIndex = idx;
            });
          },
          items: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.greenAccent[100],
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fbanner.png?alt=media&token=fb4561a6-c9af-4fde-acf3-0533498a7a15',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.greenAccent[100],
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fbanner2.png?alt=media&token=b6a9abc7-ef2e-4281-8b04-422e42b200d9',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.greenAccent[100],
              child: CachedNetworkImage(
                imageUrl:
                    'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fbanner3.png?alt=media&token=eab2db8a-0d22-4abf-b322-3df44200f9de',
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            indicator(0),
            indicator(1),
            indicator(2),
          ],
        ),
      ],
    );
  }
}

class PopularListProducts extends StatelessWidget {
  const PopularListProducts({
    Key key,
    @required this.products,
  }) : super(key: key);

  final ProductProvider products;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3 - 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: products.popularProduct.map<Widget>((prod) {
          return ProductCard(prod);
        }).toList(),
      ),
    );
  }
}

class NewListProducts extends StatelessWidget {
  const NewListProducts({
    Key key,
    @required this.products,
  }) : super(key: key);

  final ProductProvider products;

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<ProductProvider>(context);

    List<ProductModel> sortedProducts = products.products;

    sortedProducts.sort((a, b) {
      return (a.record.compareTo(b.record));
    });
    return Wrap(
      children: sortedProducts.map<Widget>((prod) {
        return ProductCard(prod);
      }).toList(),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Category('Pertanian',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fpertaniann.png?alt=media&token=d344cc04-a1df-4ab3-a3dc-48192a82299d'),
        Category('Peternakan',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fternaksapi.jpeg?alt=media&token=0779ddbc-8fb9-4c6a-b315-bd6bbdce1668'),
        Category('Perikanan',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fperikanann.png?alt=media&token=197f7709-cb2f-4a45-890d-dcb650a621f5'),
        Category('Perkebunan',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fperkebunann.png?alt=media&token=d4ceade5-c240-45a8-a7e6-ced4806b2a66'),
        Category('Kelautan',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fikanikan.jpeg?alt=media&token=9c0d5776-4936-4452-a85e-614876aa497b'),
        Category('Hasil Olahan',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fhasil_olahann.png?alt=media&token=f7bb2969-d7ae-47ed-9333-93d714c48c21'),
        Category('Papukbesbat',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fpapukpesbat.png?alt=media&token=a86cea03-244b-4cbe-a6e5-fac357c7d0c8'),
        Category('Alat Bantu Usaha',
            'https://firebasestorage.googleapis.com/v0/b/projectflutter-9b7b1.appspot.com/o/cms%2Fperalatan.png?alt=media&token=124a3813-bba7-4551-8d03-0c3c825465cb'),
      ],
    );
  }
}

class Category extends StatelessWidget {
  var _title;
  var _image;

  Category(this._title, this._image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProductScreen(_title)));
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width - 100) / 4,
            height: (MediaQuery.of(context).size.width - 100) / 4,
            decoration: BoxDecoration(
              color: Colors.greenAccent[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: CachedNetworkImage(
              imageUrl: _image,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
