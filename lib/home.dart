import 'package:covid19countrytracker/countryModel.dart';
import 'package:covid19countrytracker/details.dart';
import 'package:covid19countrytracker/favourites.dart';
import 'package:flutter/material.dart';
import 'case.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  Home(this.countriesMap);

  final countriesMap;

  @override
  _HomeState createState() => _HomeState();
}

getCountry() {}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<List<Case>> _getCases() async {
    var response = await http.get("https://corona.lmao.ninja/countries");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      List<Case> cases = [];
      for (var c in jsonData) {
        Case case1 = Case(
            c["country"],
            c["cases"],
            c["todayCases"],
            c["deaths"],
            c["todayDeaths"],
            c["recovered"],
            c["countriesMapcritical"],
            widget.countriesMap[c["country"]]);
        cases.add(case1);
      }
      print(cases.length);
      return cases;
    }
  }

  addToFav(cname, cCode) {
    if (Hive.box('countriesT').get(cname) != null) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("This country is already added as a favourite")));
    } else {
      try {
        Hive.box('countries').add(CountryModel(cname, cCode));

        Hive.box('countriesT').put(cname, CountryModel(cname, cCode));

        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("This country added as a favourite")));
      } catch (e) {
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text("Please try again")));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("in home widget");
    print(widget.countriesMap);
  }

  // final countries = ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => favourites()))
              },
              icon: Icon(Icons.star),
            ),
          )
        ],
        title: Text("Covid-19"),
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
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "The Latest Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return customListTile(
                    //     snapshot.data[index].country,
                    //     snapshot.data[index].cases.toString(),
                    //     snapshot.data[index].countryCode.toString());
                    var cCode = snapshot.data[index].countryCode;
                    var cName = snapshot.data[index].country;
                    if (cCode != null) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      cCode)));
                        },
                        child: Hero(
                            tag: cName,
                            child: Material(
                              child: ListTile(
                                // onTap: () => print("press"),
                                leading: IconButton(
                                    icon: Icon(Icons.star),
                                    onPressed: () => {addToFav(cName, cCode)}),
                                isThreeLine: true,
                                trailing: Image.network(
                                  'https://www.countryflags.io/$cCode/flat/64.png',
                                ),
                                title: Text(
                                  snapshot.data[index].country,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Total Cases : " +
                                    snapshot.data[index].cases.toString() +
                                    "\n" +
                                    "Today Cases : " +
                                    snapshot.data[index].todayCases.toString()),
                              ),
                            )),
                      );
                    } else if (cName == "USA") {
                      print("inside else part");
                      return GestureDetector(
                        onTap: () {
                          print("load usa");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      "um")));
                        },
                        child: Hero(
                          tag: cName,
                          child: Material(
                            child: ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.star),
                                  onPressed: () => {addToFav(cName, "um")}),
                              trailing: Image.network(
                                'https://www.countryflags.io/um/flat/64.png',
                              ),
                              title: Text(
                                snapshot.data[index].country,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: true,
                              subtitle: Text("Total Cases : " +
                                  snapshot.data[index].cases.toString() +
                                  "\n" +
                                  "Today Cases : " +
                                  snapshot.data[index].todayCases.toString()),
                            ),
                          ),
                        ),
                      );
                    } else if (cName == "Iran") {
                      return GestureDetector(
                        onTap: () {
                          print("load usa");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      "ir")));
                        },
                        child: Hero(
                          tag: cName,
                          child: Material(
                            child: ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.star),
                                  onPressed: () => {addToFav(cName, "ir")}),
                              trailing: Image.network(
                                'https://www.countryflags.io/ir/flat/64.png',
                              ),
                              title: Text(
                                snapshot.data[index].country,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: true,
                              subtitle: Text("Total Cases : " +
                                  snapshot.data[index].cases.toString() +
                                  "\n" +
                                  "Today Cases : " +
                                  snapshot.data[index].todayCases.toString()),
                            ),
                          ),
                        ),
                      );
                    } else if (cName == "UK") {
                      return GestureDetector(
                        onTap: () {
                          print("load usa");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      "gb")));
                        },
                        child: Hero(
                          tag: cName,
                          child: Material(
                            child: ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.star),
                                  onPressed: () => {addToFav(cName, "gb")}),
                              trailing: Image.network(
                                'https://www.countryflags.io/gb/flat/64.png',
                              ),
                              title: Text(
                                snapshot.data[index].country,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: true,
                              subtitle: Text("Total Cases : " +
                                  snapshot.data[index].cases.toString() +
                                  "\n" +
                                  "Today Cases : " +
                                  snapshot.data[index].todayCases.toString()),
                            ),
                          ),
                        ),
                      );
                    } else if (cName == "Belgium") {
                      return GestureDetector(
                        onTap: () {
                          print("load usa");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      "be")));
                        },
                        child: Hero(
                          tag: cName,
                          child: Material(
                            child: ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.star),
                                  onPressed: () => {addToFav(cName, "be")}),
                              trailing: Image.network(
                                'https://www.countryflags.io/be/flat/64.png',
                              ),
                              title: Text(
                                snapshot.data[index].country,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: true,
                              subtitle: Text("Total Cases : " +
                                  snapshot.data[index].cases.toString() +
                                  "\n" +
                                  "Today Cases : " +
                                  snapshot.data[index].todayCases.toString()),
                            ),
                          ),
                        ),
                      );
                    } else {
                      print("inside else part");
                      return GestureDetector(
                        onTap: () {
                          print("load usa");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      cName,
                                      snapshot.data[index].cases.toString(),
                                      snapshot.data[index].todayCases
                                          .toString(),
                                      snapshot.data[index].deaths.toString(),
                                      snapshot.data[index].todayDeaths
                                          .toString(),
                                      snapshot.data[index].recovered.toString(),
                                      snapshot.data[index].critical.toString(),
                                      "")));
                        },
                        child: Hero(
                          tag: cName,
                          child: Material(
                            child: ListTile(
                              leading: IconButton(
                                  icon: Icon(Icons.star),
                                  onPressed: () => {addToFav(cName, cCode)}),
                              trailing: Container(
                                height: 50,
                                width: 60,
                                color: Colors.green,
                              ),
                              title: Text(
                                snapshot.data[index].country,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              isThreeLine: true,
                              subtitle: Text("Total Cases : " +
                                  snapshot.data[index].cases.toString() +
                                  "\n" +
                                  "Today Cases : " +
                                  snapshot.data[index].todayCases.toString()),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ))
              ],
            );
          }
        },
      ),
    );
  }
}

Widget customListTile(val1, val2, val3) {
  if (val3 != null) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          height: 100,
          width: 600,
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        val1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(val2),
                      Text(val3)
                    ],
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      // height: 60,
                      // width: 60,
                      // color: Colors.green,
                      child: Image.network(
                        'https://www.countryflags.io/$val3/flat/64.png',
                      ),
                    ),
                  ),
                ],
              ))),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
          height: 100,
          width: 600,
          child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        val1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(val2),
                      Text(val3)
                    ],
                  ),
                  // SizedBox(
                  //   width: 50,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.green,
                      child: Icon(Icons.content_cut),
                      // child: Image.network(
                      //   'https://www.countryflags.io/be/flat/64.png',
                      // ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
