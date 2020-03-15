import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  DetailsPage();
  // this.country, this.cases, this.todayCases, this.deaths,
  //     this.todayDeaths, this.recovered, this.critical, this.countryCode);
  // final String country;
  // final String cases;
  // final String todayCases;
  // final String deaths;
  // final String todayDeaths;
  // final String recovered;
  // final String critical;
  // final String countryCode;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("aaaa"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[Text("abc")],
        ),
      ),
    );
  }
}
