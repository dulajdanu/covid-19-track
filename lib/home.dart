import 'package:flutter/material.dart';
import 'case.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Future<List<Case>> _getCases() async {
  var response = await http.get("https://corona.lmao.ninja/countries");
  if (response.statusCode == 200) {
    var jsonData = json.decode(response.body);

    List<Case> cases = [];
    for (var c in jsonData) {
      Case case1 = Case(c["country"], c["cases"], c["todayCases"], c["deaths"],
          c["todayDeaths"], c["recovered"], c["critical"]);
      cases.add(case1);
    }
    print(cases.length);
    return cases;
  }
}

getCountry() {}

class _HomeState extends State<Home> {
  // final countries = ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Covid 19"),
      ),
      body: FutureBuilder(
        future: _getCases(),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return customListTile(
                    snapshot.data[index].country,
                    snapshot.data[index].cases.toString(),
                    snapshot.data[index].todayDeaths.toString());
              },
            );
          }
        },
      ),
    );
  }
}

Widget customListTile(val1, val2, val3) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
    child: Container(
        decoration: BoxDecoration(
            color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
        height: 100,
        width: 600,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  val1,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(val2),
                Text(val3)
              ],
            ),
          ),
        )),
  );
}
