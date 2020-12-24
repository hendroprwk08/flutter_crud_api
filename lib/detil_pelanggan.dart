import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'main.dart' as main;

class DetilPelanggan extends StatefulWidget {
  var id, nama, telp;

  DetilPelanggan({Key key, this.id, this.nama, this.telp}): super(key: key);

  @override
  _DetilPelangganState createState() => _DetilPelangganState();
}

class _DetilPelangganState extends State<DetilPelanggan> {
  bool _progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Detil Pelanggan"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false)
        ),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //default align kiri
                  children: [
                    Text(
                      'ID',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          //fontWeight: FontWeight.bold,
                          fontSize: 13.0
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.id,
                      onChanged: (String text){
                        setState((){
                          widget.id = text;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true, //utk text height
                        contentPadding: EdgeInsets.all( 8.0 ), //utk text height
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.purple,
                                width: 2.0
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //default align kiri
                  children: [
                    Text(
                      'Nama',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[800],
                          //fontWeight: FontWeight.bold,
                          fontSize: 13.0
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.nama,
                      onChanged: (String text){
                        setState((){
                          widget.nama = text;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true, //utk text height
                        contentPadding: EdgeInsets.all( 9.0 ), //utk text height
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey ,
                                width: 2.0
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //default align kiri
                  children: [
                    Text(
                      'Telepon',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[800],
                          //fontWeight: FontWeight.bold,
                          fontSize: 13.0
                      ),
                    ),
                    TextFormField(
                      initialValue: widget.telp,
                      onChanged: (String text){
                        setState((){
                          widget.telp = text;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true, //utk text height
                        contentPadding: EdgeInsets.all( 9.0 ), //utk text height
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey ,
                                width: 2.0
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2.0
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: RaisedButton(
                      child: Text('Simpan',
                          style: TextStyle( fontWeight: FontWeight.bold,)
                      ),
                      textColor: Colors.blue,
                      onPressed: () {
                        _updateRequest( widget.id, widget.nama, widget.telp );
                      },
                    ),
                  ),
                  FlatButton(
                    child: Text('Hapus'),
                    onPressed: () {
                      _deleteRequest( widget.id );
                    },
                  ),
                ],
              ),
              Visibility(
                visible: _progress,
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator( )
                )
              )
            ],
          ),
        )
    );
  }

  _updateRequest(String i, String n, String t) async {
    String url = 'https://kodeasik.000webhostapp.com/customer-000.php?action=ubah&id='+ i +'&nama='+ n +'&telp='+ t ;

    print( url );

    _progressBar();

    Response response = await post(url);
    int statusCode = response.statusCode;
    String body = response.body;

    // print( body );
    if ( statusCode == 200 ){ //ok
      _progressBar();

      setState(() {
        Navigator.pop(context, 'ok');
      });
    }
  }

  _deleteRequest(String id) async {
    String url = 'https://kodeasik.000webhostapp.com/customer-000.php?action=hapus&id='+ widget.id ;

    print( url );

    _progressBar();

    Response response = await post(url);
    int statusCode = response.statusCode;
    String body = response.body;

    if ( statusCode == 200 ){ //ok
      _progressBar();

      setState(() {
        Navigator.pop(context, 'ok');
      });

    }
  }

  _progressBar(){
    setState(() {
      _progress = !_progress;
    });
  }
}
