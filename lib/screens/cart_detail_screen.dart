import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/screens/courier_screen.dart';
import 'package:kios_agro/widgets/merchant_product_list.dart';
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
        child: (cart.merchants.length == 0
            ? Center(
                child: Text(
                  'Tidak Ada Troli',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            : ListView.builder(
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Text(
                                'Nama Toko: ${snapshot.data['namatoko'].replaceAll(new RegExp(r'[^\w\s]+'), '')}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
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
                        MerchantProductList(cart.merchants[index], true),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Total Belanja: Rp ${cart.getTotalPrice(cart.merchants[index]).toString()}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            cart.setSelected(cart.merchants[index]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourierScreen()));
                          },
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
              )),
      ),
    );
  }
}
