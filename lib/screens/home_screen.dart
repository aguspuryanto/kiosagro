import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/screens/category_product_screen.dart';
import 'package:kios_agro/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _height;

  HomeAppBar(this._height);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(_height),
      child: AppBar(
        centerTitle: false,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari Beras',
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
        ),
        actions: <Widget>[
          Stack(children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10),
              child: IconButton(
                onPressed: () {},
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
                  '10',
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
                    'PRODUK TERBARU',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListProducts(products: products)
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
              child: Icon(
                Icons.image,
                size: 150,
                color: Colors.green,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.greenAccent[100],
              child: Icon(
                Icons.image,
                size: 150,
                color: Colors.green,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.greenAccent[100],
              child: Icon(
                Icons.image,
                size: 150,
                color: Colors.green,
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

class ListProducts extends StatelessWidget {
  const ListProducts({
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
    var index = 0;
    return Wrap(
      children: sortedProducts.map<Widget>((prod) {
        // index++;
        // if (index < 10)
        return ProductCard(prod);
        // else
        //   return SizedBox();
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
        Category('Hasil Olahan'),
        Category('Peternakan'),
        Category('Perkebunan'),
        Category('Alat Bantu Usaha'),
        Category('Category'),
        Category('Category'),
        Category('Category'),
        Category('Category'),
      ],
    );
  }
}

class Category extends StatelessWidget {
  var _title;

  Category(this._title);

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
            child: Center(
              child: Icon(
                Icons.image,
                size: 50,
                color: Colors.green,
              ),
            ),
          ),
          Text(_title)
        ],
      ),
    );
  }
}
