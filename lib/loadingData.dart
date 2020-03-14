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

Future<List<Country>> _getCountries() async {
  var response = await http.get(
      "https://pkgstore.datahub.io/core/country-list/data_json/data/8c458f2d15d9f2119654b29ede6e45b8/data_json.json");
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    List<Country> countries = [];
    for (var c in jsonData) {
      Country country = Country(c["Code"], c["Name"]);
      countries.add(country);
    }
    print(countries.length);
    return countries;
  }
}

class _LoadingDataState extends State<LoadingData> {
  var countriesMap = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getCountries(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  countriesMap[snapshot.data[index].name.toString()] =
                      snapshot.data[index].code.toString();
                  return ListTile(
                    title: Text(snapshot.data[index].code),
                    subtitle: Text(snapshot.data[index].name),
                  );
                },
              );
            }
          } else {
            return Container(
              child: Center(
                child: Text("Something is Wrong"),
              ),
            );
          }
        },
      ),
    );
  }
}
