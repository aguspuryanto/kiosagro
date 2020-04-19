import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../services/alamat_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _alamat;
  TextEditingController _noTelp;

  var listProvinsi = [];
  var listKabupaten = [];
  var listKecamatan = [];

  var _provinsi;
  var _kabupaten;
  var _kecamatan;

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _name = TextEditingController(text: "");
    _alamat = TextEditingController(text: "");
    _noTelp = TextEditingController(text: "");

    getProvinsi();
  }

  getProvinsi() {
    setState(() {
      listProvinsi = provinsi;
    });
  }

  getKabupaten(provinceId) {
    var kabList = kabupaten;
    var tempList = [];
    kabList.forEach((prov) {
      if (prov['province_id'] == provinceId) {
        tempList.add(prov);
      }
    });
    setState(() {
      listKabupaten = tempList;
    });
  }

  getKecamatan(cityId) {
    Dio()
        .get('https://pro.rajaongkir.com/api/subdistrict?city=$cityId',
            options: Options(headers: {
              "key": "eb9420bd896a4915739f4d8bc1e6ba13",
            }))
        .then(
      (value) {
        var tempList = [];
        value.data['rajaongkir']['results'].forEach((prov) {
          if (prov['city_id'] == cityId) {
            tempList.add(prov);
          }
        });
        setState(() {
          listKecamatan = tempList;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    handleSubmit() async {
      var _provinsiName;
      var _kabupatenName;
      var _kecamatanName;

      listProvinsi.forEach((prov) {
        if (prov['province_id'] == _provinsi) _provinsiName = prov['province'];
      });
      listKabupaten.forEach((kab) {
        if (kab['city_id'] == _kabupaten) _kabupatenName = kab['city_name'];
      });
      listKecamatan.forEach((kec) {
        if (kec['subdistrict_id'] == _kecamatan)
          _kecamatanName = kec['subdistrict_name'];
      });

      if (_formKey.currentState.validate() &&
          _provinsiName != null &&
          _kabupatenName != null &&
          _kecamatanName != null) {
        if (!await auth.register(
            _name.text,
            _email.text,
            _password.text,
            _noTelp.text,
            _alamat.text,
            _kecamatanName,
            _kabupatenName,
            _provinsiName,
            _kecamatan,
            _kabupaten,
            _provinsi))
          _key.currentState.showSnackBar(
            SnackBar(
              content: Text('Email sudah terdaftar'),
            ),
          );
        else {
          auth.setStatus(Status.Unauthenticated);
        }
      }
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
            auth.status == Status.Authenticating ? 'Authenticating' : 'Daftar'),
      ),
      body: SafeArea(
        child: Center(
          child: (auth.status == Status.Authenticating ||
                  listProvinsi.length == 0
              ? CircularProgressIndicator()
              : ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Image.asset('logo.png'),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _name,
                              validator: (value) => (value.isEmpty)
                                  ? "Mohon Masukkan Name"
                                  : null,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: "Nama",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mohon Masukkan Email";
                                } else {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Enter Valid Email';
                                  else
                                    return null;
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _password,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mohon Masukkan Password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _noTelp,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mohon Masukkan Nomor Telepon";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: "Nomor Telepon",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
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
                                  hint: Text('Provinsi'),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _provinsi = newValue;
                                      _kabupaten = null;
                                      _kecamatan = null;
                                    });
                                    getKabupaten(newValue);
                                  },
                                  value: _provinsi,
                                  items: listProvinsi
                                      .map<DropdownMenuItem<dynamic>>(
                                    (item) {
                                      return DropdownMenuItem(
                                        child: Text(item['province']),
                                        value: item['province_id'],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
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
                                  hint: Text('Kabupaten'),
                                  disabledHint: Text('Kabupaten'),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _kabupaten = newValue;
                                      _kecamatan = null;
                                    });
                                    getKecamatan(newValue);
                                  },
                                  value: _kabupaten,
                                  items: listKabupaten.length == 0
                                      ? null
                                      : listKabupaten
                                          .map<DropdownMenuItem<dynamic>>(
                                          (item) {
                                            return DropdownMenuItem(
                                              child: Text(item['city_name']),
                                              value: item['city_id'],
                                            );
                                          },
                                        ).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Container(
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
                                  hint: Text('Kecamatan'),
                                  disabledHint: Text('Kecamatan'),
                                  onChanged: (newValue) {
                                    setState(() {
                                      _kecamatan = newValue;
                                    });
                                  },
                                  value: _kecamatan,
                                  items: listKecamatan.length == 0
                                      ? null
                                      : listKecamatan
                                          .map<DropdownMenuItem<dynamic>>(
                                          (item) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                  item['subdistrict_name']),
                                              value: item['subdistrict_id'],
                                            );
                                          },
                                        ).toList(),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: _alamat,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Mohom Masukkan Alamat";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Alamat Lengkap",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: MaterialButton(
                              onPressed: () {
                                handleSubmit();
                              },
                              padding: EdgeInsets.all(16),
                              minWidth: double.infinity,
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                        onPressed: () {
                          auth.setStatus(Status.Unauthenticated);
                        },
                        padding: EdgeInsets.all(16),
                        minWidth: double.infinity,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Sudah Punya Akun',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: MaterialButton(
                        onPressed: () {
                          auth.googleSignIn();
                        },
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'google_logo.png',
                              width: 40,
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Text(
                              'Daftar Dengan Google',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
        ),
      ),
    );
  }
}
