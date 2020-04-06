import 'package:flutter/material.dart';
import 'package:kios_agro/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductCart extends StatefulWidget {
  var index;
  var enableButton;
  ProductCart(this.index, this.enableButton);

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context);

    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.green),
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: ListTile(
        isThreeLine: (widget.enableButton == true ? true : false),
        leading: Container(
          height: 100,
          width: 75,
          child: (cart.images[widget.index] == null
              ? Icon(Icons.image)
              : cart.images[widget.index]),
        ),
        trailing: (widget.enableButton == false
            ? null
            : IconButton(
                onPressed: () {
                  cart.removeProduct(widget.index);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )),
        title: Text(
          cart.cartProducts[widget.index].name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: (widget.enableButton == false
            ? Text(
                '${cart.amounts[widget.index]} x ${cart.cartProducts[widget.index].harga} = ${cart.amounts[widget.index] * cart.cartProducts[widget.index].harga}',
              )
            : Column(
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
                              if (cart.amounts[widget.index] > 1) {
                                cart.amounts[widget.index]--;
                                cart.cartNotifyListeners();
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
                              cart.cartNotifyListeners();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
      ),
    );
    ;
  }
}
