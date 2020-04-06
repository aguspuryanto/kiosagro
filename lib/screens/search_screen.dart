import 'package:flutter/material.dart';
import 'package:kios_agro/models/product_model.dart';
import 'package:kios_agro/providers/product_provider.dart';
import 'package:kios_agro/widgets/product_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _search;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _search = TextEditingController(text: '');
    _search.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products =
        Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
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
              controller: _search,
              onChanged: (newValue) {},
              autofocus: true,
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: (_search.text.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Wrap(
                      children: products.map<Widget>((prod) {
                        if (prod.name.toLowerCase().contains(_search.text)) {
                          return ProductCard(prod);
                        }
                        return SizedBox();
                      }).toList(),
                    ),
                  ),
                )),
        ),
      ),
    );
  }
}
