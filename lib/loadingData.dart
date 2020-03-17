import 'package:covid19countrytracker/home.dart';
import 'package:flutter/material.dart';
import 'case.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'country.dart';

class LoadingData extends StatefulWidget {
  LoadingData({Key key}) : super(key: key);

  @override
  _LoadingDataState createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData> {
  var countriesMap = new Map();
  Future<List<Country>> _getCountries() async {
    var response = await http.get(
        "https://pkgstore.datahub.io/core/country-list/data_json/data/8c458f2d15d9f2119654b29ede6e45b8/data_json.json");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      List<Country> countries = [];
      for (var c in jsonData) {
        Country country = Country(c["Code"], c["Name"]);
        countries.add(country);
        countriesMap[c["Name"]] = c["Code"];
      }
      print(countries.length);
      return countries;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: FutureBuilder(
          future: _getCountries(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                print("no data");
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                // return ListView.builder(
                //   itemCount: snapshot.data.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     countriesMap[snapshot.data[index].name.toString()] =
                //         snapshot.data[index].code.toString();
                //     return ListTile(
                //       title: Text(snapshot.data[index].code),
                //       subtitle: Text(snapshot.data[index].name),
                //     );
                //   },
                // );
                return Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.redAccent,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Corona Tracker",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            "lib/assets/c.jpg",
                            // fit: BoxFit.cover,
                            height: 500,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Home(countriesMap)));
                              },
                              child: Text("Continue"),
                            ))
                      ],
                    ),
                    // Positioned(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(10),
                    //     child: Container(
                    //       child: Align(
                    //         // alignment: Alignment.center,
                    //         child: Image.asset(
                    //           "lib/assets/c.jpg",
                    //           // fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              }
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
