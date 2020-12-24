import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'detil_pelanggan.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Dengan API',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'CRUD Dengan API'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var id, nama, telepon, result;
  bool progress = false;

  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _getRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {'Refresh', 'Exit'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ]),
      body: Padding(padding: const EdgeInsets.all(15.0), child: _getBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Tambah Pelanggan'),
                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                content: Container(
                    width: 300.0,
                    height: 255.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //default align kiri
                            children: [
                              Text(
                                'ID',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey[800], fontSize: 13.0),
                              ),
                              TextField(
                                onChanged: (String text) {
                                  setState(() {
                                    id = text;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true, //utk text height
                                  contentPadding:
                                      EdgeInsets.all(8.0), //utk text height
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //default align kiri
                            children: [
                              Text(
                                'Nama',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              TextField(
                                onChanged: (String text) {
                                  setState(() {
                                    nama = text;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true, //utk text height
                                  contentPadding:
                                      EdgeInsets.all(9.0), //utk text height
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //default align kiri
                            children: [
                              Text(
                                'Telepon',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              TextField(
                                onChanged: (String text) {
                                  setState(() {
                                    telepon = text;
                                  });
                                },
                                decoration: InputDecoration(
                                  isDense: true, //utk text height
                                  contentPadding:
                                      EdgeInsets.all(9.0), //utk text height
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              child: Text('Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              textColor: Colors.blue,
                              onPressed: () {

                                //cara menggunakan Future
                                _postRequest(id, nama, telepon).then((value) {
                                  print(value);
                                  if (value == true){
                                    Navigator.of(context).pop();
                                  }else{
                                    print('Kode pelanggan sudah ada');

                                    Fluttertoast.showToast(
                                        msg:'Aw. data bermasalah',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 15.0
                                    );
                                  }
                                }, onError: (error) {
                                  print(error);
                                });
                              },
                            ),
                            FlatButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        )
                      ],
                    )),
                actions: [], //dikosongkan karena jarak button terlalu jauh
              );
            },
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<bool> _postRequest(String i, String n, String t) async {
    try{
      String url =
          'https://kodeasik.000webhostapp.com/customer-000.php?action=simpan&id=' +
              i + '&nama=' + n + '&telp=' + t;

      Response response = await post(url);
      int statusCode = response.statusCode;
      var json = jsonDecode(response.body);
      print(url);

      if (!json['result'].toString().contains('Duplicate entry')) {
        _getRequest();
        return Future.value(true); //memberikan value true khusus future
      }

      return Future.value(false);
    }catch(e){
      print(e);
      return Future.value(false);
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Refresh':
        _getRequest();
        break;
      case 'Exit':
        Future.delayed(const Duration(milliseconds: 1000), () {
          exit(0);
        });
        break;
    }
  }

  _getRequest() async {
    String url = 'https://kodeasik.000webhostapp.com/customer-000.php';
    Response response = await get(url);
    int code = response.statusCode;

    try {
      var json = jsonDecode(response.body);

      print(json);

      if (json['result'] == 0) {
        setState(() {
          customers.clear();
        });
      } else {
        setState(() {
          customers = (json['result'] as List)
              .map((p) => Customer.fromJson(p))
              .toList();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _getBody() {
    if (customers.length == 0) {
      return new Center(child: Text('Belum ada data'));
    } else if (customers.length > 0) {
      return ListView.builder(
          itemCount: customers.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () async {
                  //menangkap hasil dari halaman lain
                  result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetilPelanggan(
                              id: customers[index].id,
                              nama: customers[index].nama,
                              telp: customers[index].telp)));
                  print('balikan: ' + result);
                  _getRequest();
                },
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                    padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, //default align kiri
                      children: [
                        Text(
                          customers[index].nama,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Text(customers[index].telp)
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                ]));
          });
    }
  }
}
