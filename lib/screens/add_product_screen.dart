import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:kios_agro/providers/user_provider.dart';
import 'package:kios_agro/screens/screen_control.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  var isSubmit = false;
  var isFinish = false;

  TextEditingController _nama;
  TextEditingController _deskripsi;
  TextEditingController _berat;
  TextEditingController _harga;
  List<File> _images;
  List _imagesUrl;

  var _kategori;

  var listCategory = ['Peternakan', 'Perkebunan'];

  var dbRef = FirebaseDatabase.instance.reference().child('/products').push();
  var storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nama = TextEditingController(text: '');
    _deskripsi = TextEditingController(text: '');
    _berat = TextEditingController(text: '0');
    _harga = TextEditingController(text: '0');
    _images = [];
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);

    Future uploadImage(_image) async {
      var imageUrl = '';
      print('upload');
      StorageReference storageReference =
          storageRef.child('/products/${dbRef.key}/${_images.length}.jpeg');

      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File uploaded');
      await storageReference.getDownloadURL().then((value) {
        print(value);
        imageUrl = value;
      });
      return imageUrl;
    }

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _images.add(image);
      });
    }

    handleSubmit() async {
      setState(() {
        isSubmit = true;
      });

      var status = false;

      print('submit');

      var sku = dbRef.key;

      var imageUrl = await uploadImage(_images[0]);

      var product = {
        'Berat': _berat.text,
        'Category': _kategori,
        'Comment': 0,
        'Coret': '',
        'Deskripsi': _deskripsi.text,
        'Discount': '',
        'Harga': _harga.text,
        'Image': [imageUrl],
        'Kota': user.user.alamat['kecamatan'],
        'Merchant': user.user.key,
        'Name': _nama.text,
        'OriginID': user.user.alamat['id'],
        'OriginType': 'subdistrict',
        'Priority': 0,
        'Rating': 0,
        'SKU': sku,
        'Unit': 'gram',
        'Update':
            DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        'record': ''
      };

      await dbRef.set(product).then((_) {
        print('produk berhasil ditambahkan');
      });

      await FirebaseDatabase.instance
          .reference()
          .child('/users/${user.user.key}/products/${dbRef.key}')
          .set(product)
          .then((_) async {
        print('product user updated');
        status = true;
        await user.getUserData(user.user.key);
        setState(() {
          isFinish = true;
        });
      });

      return status;
    }

    return Scaffold(
      key: _key,
      floatingActionButton: (isSubmit == true
          ? Container()
          : MaterialButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  handleSubmit();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.green,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )),
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: (isSubmit == true
          ? Center(
              child: (isFinish == false
                  ? CircularProgressIndicator()
                  : AlertDialog(
                      content: Text('Produk Berhasil Ditambahkan'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Tutup'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenControl()));
                          },
                        ),
                      ],
                    )),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nama,
                        validator: (value) =>
                            (value.isEmpty) ? "Mohon Masukkan Nama" : null,
                        decoration: InputDecoration(
                          labelText: "Nama",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _deskripsi,
                        validator: (value) =>
                            (value.isEmpty) ? "Mohon Masukkan Deskripsi" : null,
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _berat,
                        validator: (value) =>
                            (value.isEmpty) ? "Mohon Masukkan Berat" : null,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: "Berat (gram)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _harga,
                        validator: (value) =>
                            (value.isEmpty) ? "Mohon Masukkan Harga" : null,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: "Harga (rupiah)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            elevation: 2,
                            isExpanded: true,
                            hint: Text('Kategori'),
                            onChanged: (newValue) {
                              setState(() {
                                _kategori = newValue;
                              });
                            },
                            value: _kategori,
                            items: listCategory.map<DropdownMenuItem<dynamic>>(
                              (item) {
                                print(item);
                                return DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Gambar',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Wrap(
                        children: <Widget>[
                          Wrap(
                            children: _images
                                .map<Widget>((image) => Container(
                                    margin: EdgeInsets.all(10),
                                    width: 100,
                                    height: 100,
                                    child: Image.file(image)))
                                .toList(),
                          ),
                          (_images.length >= 1
                              ? Container()
                              : FlatButton(
                                  onPressed: () {
                                    getImage();
                                  },
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Tambah',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
