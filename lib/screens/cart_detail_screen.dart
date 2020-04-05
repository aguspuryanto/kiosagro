import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartDetailScreen extends StatefulWidget {
  @override
  _CartDetailScreenState createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Troli'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: cart.merchants.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FutureBuilder(
                    future: FirebaseDatabase.instance
                        .reference()
                        .child('/users/${cart.merchants[index]}')
                        .once()
                        .then((value) => value.value),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          'Nama Toko: ${snapshot.data['namatoko'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MerchantProductList(cart.merchants[index]),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.green,
                    minWidth: MediaQuery.of(context).size.width,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Belanja',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MerchantProductList extends StatelessWidget {
  var merchant;

  MerchantProductList(this.merchant);

  @override
  Widget build(BuildContext context) {
    var carts = Provider.of<CartProvider>(context);
    var index = 0;

    print('carts');
    print(carts.cartProducts[0].merchant);
    print(merchant);

    return Column(
      children: carts.cartProducts.map<Widget>((cart) {
        if (cart.merchant == merchant) {
          return ProductCart(index);
        }
        index++;
        return SizedBox();
      }).toList(),
    );
  }
}

class ProductCart extends StatefulWidget {
  var index;
  ProductCart(this.index);

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Container(
          height: 100,
          width: 75,
          child: cart.images[widget.index],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
        title: Text(
          cart.cartProducts[widget.index].name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${cart.amounts[widget.index]} x ${cart.cartProducts[widget.index].harga} = ${cart.amounts[widget.index] * cart.cartProducts[widget.index].harga}',
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.redAccent[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.remove,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        if (cart.amounts[widget.index] != 0) {
                          cart.amounts[widget.index]--;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  cart.amounts[widget.index].toString(),
                  // style: titleStyle,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.add,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        cart.amounts[widget.index]++;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
