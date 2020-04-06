import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kios_agro/main.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:kios_agro/widgets/merchant_product_list.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AfterSplash()));
            }),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
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
                            .child('/users/${cart.selectedMerchant}')
                            .once()
                            .then((value) => value.value),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Text(
                                'Nama Toko: ${snapshot.data['namatoko'].replaceAll(new RegExp(r'[^\w\s]+'), '')}');
                          }
                          return Container();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MerchantProductList(cart.selectedMerchant, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
