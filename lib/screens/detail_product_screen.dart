import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  ProductModel product;
  var image;

  DetailProductScreen(this.product, this.image);

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final _key = GlobalKey<ScaffoldState>();
  var _total = 1;

  TextStyle titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle childStyle = TextStyle(fontSize: 16);

  Future<void> successDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Produk Berhasil Ditambahkan'),
          actions: <Widget>[
            FlatButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    var cart = Provider.of<CartProvider>(context);

    checkIsComplete() {
      if (!user.telepon.isEmpty &&
          !user.alamat['alamat'].isEmpty &&
          !user.alamat['provinsi'].isEmpty &&
          !user.alamat['kabupaten'].isEmpty &&
          !user.alamat['kecamatan'].isEmpty) {
        return true;
      } else {
        return false;
      }
    }

    handleSubmit() {
      cart.addProduct(widget.product, _total, widget.image);
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  color: Colors.greenAccent[100],
                  child: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_total != 0) {
                          _total--;
                        }
                      });
                    },
                  ),
                ),
                Text(
                  _total.toString(),
                  style: titleStyle,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.greenAccent[100],
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _total++;
                      });
                    },
                  ),
                ),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width / 4,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: MaterialButton(
                onPressed: () {
                  if (user.key == widget.product.merchant) {
                    _key.currentState.showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Tidak boleh membeli produk sendiri'),
                      ),
                    );
                  } else {
                    if (_total != 0) {
                      print(checkIsComplete());
                      if (checkIsComplete() == true) {
                        handleSubmit();
                        successDialog();
                      } else {
                        _key.currentState.showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Lengkapi akun pembeli anda terlebih dahulu'),
                          ),
                        );
                      }
                    } else {
                      _key.currentState.showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Jumlah produk tidak boleh kosong'),
                        ),
                      );
                    }
                  }
                },
                color: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                child: Text(
                  'Masukkan Keranjang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ImageSlider(widget: widget),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Rp ${widget.product.harga}',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Rating: ${widget.product.rating}/5',
                        style: titleStyle,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Informasi Produk',
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Berat: ',
                        style: childStyle,
                      ),
                      Text(
                        '${widget.product.berat} Gram',
                        style: childStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Kategori: ',
                        style: childStyle,
                      ),
                      Text(
                        widget.product.category,
                        style: childStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Deskirpsi Produk',
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.deskripsi,
                    style: childStyle,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final DetailProductScreen widget;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  var _carouselIndex = 0;
  var _imageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.widget.product.images is List &&
        widget.widget.product.images.length > 0) {
      setState(() {
        _imageList = widget.widget.product.images;
      });
    }
  }

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
    print(widget.widget.product.images);

    return Column(
      children: <Widget>[
        CarouselSlider.builder(
            itemCount: 2,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: (idx) {
              setState(() {
                _carouselIndex = idx;
              });
            },
            itemBuilder: (context, int) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.widget.image,
                ),
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            indicator(0),
            indicator(1),
          ],
        )
      ],
    );
  }
}
