import 'package:covid19countrytracker/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'case.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'country.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
                return FutureBuilder(
                  future: Hive.openBox('countries'),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError)
                        return Text(snapshot.error.toString());
                      else {
                        return Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.redAccent,
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Corona",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Tracker",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: SizedBox(
                                    width: 250.0,
                                    child: TyperAnimatedTextKit(
                                        // speed: Duration(milliseconds: 100),
                                        onTap: () {
                                          print("Tap Event");
                                        },
                                        text: [
                                          "Get the latest details about the spread of Coronavirus across countries",
                                          "Within one touch",
                                          "Press continue to start"
                                        ],
                                        textStyle: TextStyle(
                                            fontSize: 30.0,
                                            fontFamily: "Bobbers"),
                                        textAlign: TextAlign.start,
                                        alignment: AlignmentDirectional
                                            .topStart // or Alignment.topLeft
                                        ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Image.asset(
                                //     "lib/assets/c.jpg",
                                //     // fit: BoxFit.cover,
                                //     height: 500,
                                //   ),
                                // ),
                                // Padding(
                                //     padding: EdgeInsets.all(10),
                                //     child: RaisedButton(
                                //       color: Colors.green,
                                //       onPressed: () {
                                //         Navigator.push(
                                //             context,
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     Home(countriesMap)));
                                //       },
                                //       child: Text("Continue"),
                                //     ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Home(countriesMap)))
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.blue,
                                          Colors.green
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    height: 50,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
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
