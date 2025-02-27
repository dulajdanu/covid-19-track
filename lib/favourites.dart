import 'package:covid19countrytracker/countryModel.dart';
import 'package:covid19countrytracker/details.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'case.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class favourites extends StatefulWidget {
  favourites({Key key}) : super(key: key);

  @override
  _favouritesState createState() => _favouritesState();
}

class _favouritesState extends State<favourites> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("inside fav page");
    // Hive.box('countries').clear();
    // Hive.box('countriesT').clear();
  }

  Future<Case> getCountryData(val) async {
    var response = await http.get("https://corona.lmao.ninja/countries/$val");
    if (response.statusCode == 200) {
      var c = json.decode(response.body);
      if (response.body.isNotEmpty) {
        Case case1 = Case(
            c["country"],
            c["cases"],
            c["todayCases"],
            c["deaths"],
            c["todayDeaths"],
            c["recovered"],
            c["countriesMapcritical"],
            "");

        return case1;
      }
    }
  }

  removeFav(name) {
    print(name);
    // Hive.box('co')
    Hive.box('countriesT').delete(name);
    final cBox = Hive.box('countries');
    for (var i = 0; i < cBox.length; i++) {
      CountryModel country = cBox.getAt(i);

      if (country.name == name) {
        Hive.box('countries').deleteAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Favourites"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            WatchBoxBuilder(
              box: Hive.box('countries'),
              builder: (context, box) {
                Map<dynamic, dynamic> raw = box.toMap();
                List list = raw.values.toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    CountryModel cModel = list[index];
                    var cde = cModel.code.toString();
                    return FutureBuilder(
                        future: getCountryData(cModel.name),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: LinearProgressIndicator(),
                            );
                          } else {
                            Case case1 = snapshot.data;
                            return Dismissible(
                              background: Container(
                                color: Colors.redAccent,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                    ),
                                    Text(
                                      "Remove",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              key: Key(cModel.name),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                setState(() {
                                  removeFav(cModel.name);
                                });
                              },
                              child: GestureDetector(
                                onTap: () {
                                  print("load details page");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              cModel.name,
                                              case1.cases.toString(),
                                              case1.todayCases.toString(),
                                              case1.deaths.toString(),
                                              case1.todayDeaths.toString(),
                                              case1.recovered.toString(),
                                              case1.critical.toString(),
                                              cModel.code)));
                                },
                                child: Hero(
                                  tag: cModel.name,
                                  child: Material(
                                    child: ListTile(
                                        title: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: <Widget>[
                                              Text(cModel.name),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text("Cases today " +
                                                  case1.todayCases.toString())
                                            ],
                                          ),
                                        ),
                                        // leading: Text(cde),
                                        trailing:
                                            (cModel.code.toString() != 'null'
                                                ? Image.network(
                                                    'https://www.countryflags.io/$cde/flat/64.png',
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 60,
                                                    color: Colors.green,
                                                  ))
                                        // subtitle: Text(
                                        //     personModel.birthDate.toLocal().toString()),
                                        ),
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
